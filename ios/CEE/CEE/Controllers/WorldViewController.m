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

#import <PromiseKit/PromiseKit.h>

#import "WorldViewController.h"
#import "AcquiredMapsViewController.h"
#import "MapPanelView.h"
#import "MapAnchorView.h"
#import "HUDGetNewMapView.h"
#import "HUDFetchingMapView.h"
#import "HUDGetMedalView.h"
#import "TaskViewController.h"
#import "CEEImageManager.h"
#import "CEELocationManager.h"
#import "CEEMap.h"
#import "CEEAnchor.h"
#import "UIImageView+Utils.h"


@interface WorldViewController () <HUDViewDelegate>
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIImageView * mapView;
@property (nonatomic, strong) NSMutableArray<MapAnchorView *> * anchorViews;
@property (nonatomic, strong) MapPanelView * panelView;
@property (nonatomic, strong) HUDGetNewMapView * getNewMapHUD;
@property (nonatomic, strong) HUDFetchingMapView * fetchingMapHUD;
@property (nonatomic, strong) HUDGetMedalView * getMedalHUD;

@property (nonatomic, strong) CEEJSONMap * currentMap;
@property (nonatomic, strong) NSArray<CEEJSONAnchor *> * anchors;
@end


@implementation WorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    
    self.mapView = [[UIImageView alloc] init];
    [self.contentScrollView addSubview:self.mapView];
    
    self.panelView = [[MapPanelView alloc] init];
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
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        make.height.mas_equalTo(96);
    }];
    
    self.navigationItem.rightBarButtonItem
    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"弹窗个人主页_发光"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(menuPressed:)];
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
    
    if (!self.currentMap) {
        [self.fetchingMapHUD show];
        [[CEELocationManager manager] fetchNearestMap]
        .then(^(CEEJSONMap *map, NSArray<CEEJSONAnchor *> *anchors) {
            self.currentMap = map;
            self.anchors = anchors;
            [self loadMap:map];
            [self loadAnchors:anchors];
            [self.fetchingMapHUD dismiss];
        }).catch(^(NSError *error) {
            [self.fetchingMapHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    }
    
    /*
    if (!self.getNewMapHUD) {
        self.getNewMapHUD = [[HUDGetNewMapView alloc] init];
        self.getNewMapHUD.delegate = self;
        [self.getNewMapHUD show];
    } else if (!self.getMedalHUD) {
        self.getMedalHUD = [[HUDGetMedalView alloc] init];
        self.getMedalHUD.delegate = self;
        [self.getMedalHUD show];
    } else {
        TaskViewController * vc = [[TaskViewController alloc] init];
        [self.rdv_tabBarController presentViewController:vc animated:YES completion:nil];
    }
     */
}

- (HUDFetchingMapView *)fetchingMapHUD {
    if (!_fetchingMapHUD) {
        _fetchingMapHUD = [[HUDFetchingMapView alloc] init];
    }
    return _fetchingMapHUD;
}

- (void)menuPressed:(id)sender {
    NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:^{
        [player play];
    }];
}

- (void)moreMapPressed:(id)sender {
    AcquiredMapsViewController * mapsVC = [[AcquiredMapsViewController alloc] init];
    [self.navigationController pushViewController:mapsVC animated:YES];
}

- (void)setupMapImage:(UIImage *)image {
    self.mapView.image = image;
    self.contentScrollView.contentSize = self.mapView.image.size;
}

#pragma mark - HUDViewDelegate

- (void)HUDOverlayViewTouched:(HUDBaseView *)view {
    [view dismiss];
}

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
        MapAnchorView * anchorView = [[MapAnchorView alloc] init];
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

@end
