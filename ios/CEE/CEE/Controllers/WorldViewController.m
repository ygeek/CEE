//
//  WorldViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import AVKit;
@import AVFoundation;
@import Masonry;
@import RDVTabBarController;
@import SVProgressHUD;
@import ReactiveCocoa;


#import <PromiseKit/PromiseKit.h>

#import "WorldViewController.h"
#import "AcquiredMapsViewController.h"
#import "UserProfileViewController.h"
#import "MapPanelView.h"
#import "MapAnchorView.h"
#import "HUDFetchingMapView.h"
#import "HUDGetMedalView.h"
#import "HUDTaskCompletedViewController.h"
#import "HUDNewMapViewController.h"
#import "TaskViewController.h"
#import "CEEImageManager.h"
#import "CEELocationManager.h"
#import "CEEMap.h"
#import "CEEAnchor.h"
#import "UIImageView+Utils.h"
#import "CEEAcquiredMapsAPI.h"
#import "CEETaskAPI.h"
#import "CEETaskCompleteAPI.h"
#import "CEELocationManager.h"
#import "HUDStoryFetchingViewController.h"
#import "CEEStoriesManager.h"
#import "CEEStoryDetailAPI.h"
#import "StoryLevelsRootViewController.h"
#import "CEEMessagesManager.h"
#import "CEENotificationNames.h"


@interface WorldViewController () <HUDViewDelegate,
                                   TaskViewControllerDelegate,
                                   MapPanelViewDelegate,
                                   AcquiredMapsViewControllerDelegate>
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIImageView * mapView;
@property (nonatomic, strong) NSMutableArray<MapAnchorView *> * anchorViews;
@property (nonatomic, strong) MapPanelView * panelView;
@property (nonatomic, strong) MASConstraint * panelOffset;

@property (nonatomic, strong) HUDFetchingMapView * fetchingMapHUD;
@property (nonatomic, strong) HUDGetMedalView * getMedalHUD;

@end


@implementation WorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.delaysContentTouches = NO;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    
    self.mapView = [[UIImageView alloc] init];
    self.mapView.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:self.mapView];
    
    self.panelView = [[MapPanelView alloc] init];
    self.panelView.delegate = self;
    [self.view addSubview:self.panelView];
    
    [self.panelView.moreMapButton addTarget:self action:@selector(moreMapPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
    }];
    
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        self.panelOffset = make.bottom.equalTo(self.view.mas_bottom).offset(96);
        make.height.mas_equalTo(96);
    }];
    
    self.navigationItem.rightBarButtonItem
    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"弹窗个人主页_发光"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(menuPressed:)];
    
    @weakify(self)
    [RACObserve([CEELocationManager manager], acquiredMaps) subscribeNext:^(NSArray<CEEJSONMap *> * maps) {
        @strongify(self)
        
        [self.view layoutIfNeeded];
        if (!maps || maps.count == 0) {
            self.panelOffset.offset(96);
            self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            self.panelOffset.offset(-49);
            self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 96, 0);
        }
        [UIView promiseWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foundNewMapNotification:)
                                                 name:CEEFoundNewMapNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storyCompletedNotification:)
                                                 name:kCEEStoryCompleteNotificationName
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![CEELocationManager manager].currentMap) {
        [self.fetchingMapHUD show];
        [[CEELocationManager manager] fetchNearestMap]
        .then(^(CEEJSONMap *map, NSArray<CEEJSONAnchor *> *anchors) {
            [self loadMap:map];
            [self loadAnchors:anchors];
            [self.fetchingMapHUD dismiss];
        }).catch(^(NSError *error) {
            [self.fetchingMapHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    }
    
    [self loadAcquiredMaps];
}

- (HUDFetchingMapView *)fetchingMapHUD {
    if (!_fetchingMapHUD) {
        _fetchingMapHUD = [[HUDFetchingMapView alloc] init];
    }
    return _fetchingMapHUD;
}

- (void)menuPressed:(id)sender {
    UserProfileViewController * profileVC = [[UserProfileViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [self.rdv_tabBarController presentViewController:navController animated:YES completion:nil];
}

- (void)moreMapPressed:(id)sender {
    AcquiredMapsViewController * mapsVC = [[AcquiredMapsViewController alloc] init];
    mapsVC.maps = [CEELocationManager manager].acquiredMaps;
    mapsVC.delegate = self;
    [self.navigationController pushViewController:mapsVC animated:YES];
}

- (void)setupMapImage:(UIImage *)image {
    self.mapView.image = image;
    self.contentScrollView.contentSize = self.mapView.image.size;
}

- (void)anchorPressed:(MapAnchorView *)anchorView {
    if ([anchorView.anchor.type isEqualToString:kAnchorTypeNameTask]) {
        [SVProgressHUD showWithStatus:@"正在获取问题"];
        [[CEETaskAPI api] fetchTaskWithID:anchorView.anchor.ref_id]
        .then(^(CEEJSONTask * task) {
            [SVProgressHUD dismiss];
            TaskViewController * vc = [[TaskViewController alloc] init];
            vc.delegate = self;
            vc.task = task;
            [self.rdv_tabBarController presentViewController:vc animated:YES completion:nil];
        }).catch(^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    } else if ([anchorView.anchor.type isEqualToString:kAnchorTypeNameStory]) {
        NSNumber * storyID = anchorView.anchor.ref_id;
        [SVProgressHUD show];
        [[CEEStoryDetailAPI api] fetchDetailWithStoryID:storyID].then(^(CEEJSONStory *story) {
            [SVProgressHUD dismiss];
            HUDStoryFetchingViewController * hud = [[HUDStoryFetchingViewController alloc] init];
            [hud loadStory:story];
            [self.rdv_tabBarController presentViewController:hud animated:YES completion:nil];
            
            [[CEEStoriesManager manager] downloadStoryWithID:story.id]
            .then(^(NSArray * levelsAndItems) {
                [hud dismissViewControllerAnimated:YES completion:^{
                    StoryLevelsRootViewController * levelsRoot = [[StoryLevelsRootViewController alloc] init];
                    levelsRoot.story = story;
                    levelsRoot.levels = levelsAndItems[0];
                    levelsRoot.items = levelsAndItems[1];
                    [levelsRoot nextLevel];
                    [[CEEMessagesManager manager] notifyRunningStory:story];
                    [self.rdv_tabBarController presentViewController:levelsRoot animated:YES completion:nil];
                }];
            });
        }).catch(^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    }
}

- (void)foundNewMapNotification:(NSNotification *)notification {
    CEEJSONMap * map = notification.userInfo[CEENewMapKey];
    HUDNewMapViewController * vc = [[HUDNewMapViewController alloc] init];
    [vc loadMap:map];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)storyCompletedNotification:(NSNotification *)notification {
    CEEJSONStory * story = notification.userInfo[kCEEStoryCompleteStoryKey];
    for (CEEJSONAnchor * anchor in [CEELocationManager manager].currentAnchors) {
        if ([anchor.type isEqualToString:kAnchorTypeNameStory] &&
            [anchor.ref_id isEqualToNumber:story.id]) {
            anchor.completed = @(YES);
        }
    }
    
    for (MapAnchorView * anchorView in self.anchorViews) {
        CEEJSONAnchor * anchor = anchorView.anchor;
        if ([anchor.type isEqualToString:kAnchorTypeNameStory] &&
            [anchor.ref_id isEqualToNumber:story.id]) {
            anchor.completed = @(YES);
            anchorView.anchorType = MapAnchorTypeTaskFinished;
        }
    }
}

#pragma mark - HUDViewDelegate

- (void)HUDOverlayViewTouched:(HUDBaseView *)view {
    [view dismiss];
}

#pragma mark - TaskViewControllerDelegate

- (void)task:(CEEJSONTask *)task completedInController:(TaskViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD showWithStatus:@"请稍等…"];
        
        for (CEEJSONAnchor * anchor in [CEELocationManager manager].currentAnchors) {
            if ([anchor.type isEqualToString:kAnchorTypeNameTask] &&
                [anchor.ref_id isEqualToNumber:task.id]) {
                anchor.completed = @(YES);
            }
        }
        
        for (MapAnchorView * anchorView in self.anchorViews) {
            CEEJSONAnchor * anchor = anchorView.anchor;
            if ([anchor.type isEqualToString:kAnchorTypeNameTask] &&
                [anchor.ref_id isEqualToNumber:task.id]) {
                anchor.completed = @(YES);
                anchorView.anchorType = MapAnchorTypeTaskFinished;
            }
        }
        
        [[CEETaskCompleteAPI api] completeTaskWithID:task.id]
        .then(^(NSArray<CEEJSONAward *> * awards, NSString * image_key) {
            [SVProgressHUD dismiss];
            HUDTaskCompletedViewController * vc = [[HUDTaskCompletedViewController alloc] init];
            [vc loadAwards:awards andImageKey:image_key];
            [self presentViewController:vc animated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCEETaskCompleteNotificationName object:self];
            
        }).catch(^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    }];
}

- (void)task:(CEEJSONTask *)task failedInController:(TaskViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MapPanelViewDelegate

- (void)mapPressed:(CEEJSONMap *)map {
    [self.fetchingMapHUD show];

    [[CEELocationManager manager] fetchMapData:map]
    .then(^(CEEJSONMap *map, NSArray<CEEJSONAnchor *> *anchors) {
        [self loadMap:map];
        [self loadAnchors:anchors];
        [self.fetchingMapHUD dismiss];
    }).catch(^(NSError *error) {
        [self.fetchingMapHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    });
}

#pragma mark - AcquiredMapsViewControllerDelegate

- (void)acquiredMapsViewController:(AcquiredMapsViewController *)controller didSelectMap:(CEEJSONMap *)map {
    [self.navigationController popViewControllerAnimated:YES];
    [self mapPressed:map];
}

#pragma mark - Loads

- (void)loadMap:(CEEJSONMap *)map {
    self.navigationItem.title = map.name;
   
    [[CEEImageManager manager] queryImageForKey:map.image_key]
    .then(^(UIImage *image) {
        [self setupMapImage:image];
    });
}

- (void)loadAnchors:(NSArray<CEEJSONAnchor *> *)anchors {
    for (MapAnchorView * view in self.anchorViews) {
        [view removeFromSuperview];
    }
    
    self.anchorViews = [NSMutableArray array];
    
    for (CEEJSONAnchor * anchor in anchors) {
        MapAnchorView * anchorView = [[MapAnchorView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [anchorView addTarget:self action:@selector(anchorPressed:) forControlEvents:UIControlEventTouchUpInside];
        anchorView.anchor = anchor;
        if ([anchor.type isEqualToString:kAnchorTypeNameStory]) {
            if (anchor.completed.boolValue) {
                anchorView.anchorType = MapAnchorTypeStoryFinished;
            } else {
                anchorView.anchorType = MapAnchorTypeStory;
            }
        } else if ([anchor.type isEqualToString:kAnchorTypeNameTask]) {
            if (anchor.completed.boolValue) {
                anchorView.anchorType = MapAnchorTypeTaskFinished;
            } else {
                anchorView.anchorType = MapAnchorTypeTask;
            }
        }
        anchorView.center = CGPointMake(anchor.dx.floatValue, anchor.dy.floatValue);
        [self.anchorViews addObject:anchorView];
        [self.mapView addSubview:anchorView];
    }
}

- (void)loadAcquiredMaps {
    [[CEELocationManager manager] loadAcquiredMaps]
    .then(^(NSArray<CEEJSONMap *> * maps) {
        return [self.panelView loadAcquiredMaps:maps];
    });
}

@end
