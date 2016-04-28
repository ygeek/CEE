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

#import "WorldViewController.h"
#import "AcquiredMapsViewController.h"
#import "MapPanelView.h"
#import "MapAnchorView.h"
#import "HUDGetNewMapView.h"
#import "HUDFetchingMapView.h"
#import "HUDGetMedalView.h"
#import "TaskViewController.h"


@interface WorldViewController () <HUDViewDelegate>
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIImageView * mapView;
@property (nonatomic, strong) NSMutableArray<MapAnchorView *> * anchorViews;
@property (nonatomic, strong) MapPanelView * panelView;
@property (nonatomic, strong) HUDGetNewMapView * getNewMapHUD;
@property (nonatomic, strong) HUDFetchingMapView * fetchingMapHUD;
@property (nonatomic, strong) HUDGetMedalView * getMedalHUD;
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
    
    [self loadSampleData];
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
    
    if (!self.getNewMapHUD) {
        self.getNewMapHUD = [[HUDGetNewMapView alloc] init];
        self.getNewMapHUD.delegate = self;
        [self.getNewMapHUD show];
    } else if (!self.fetchingMapHUD) {
        self.fetchingMapHUD = [[HUDFetchingMapView alloc] init];
        self.fetchingMapHUD.delegate = self;
        [self.fetchingMapHUD show];
    } else if (!self.getMedalHUD) {
        self.getMedalHUD = [[HUDGetMedalView alloc] init];
        self.getMedalHUD.delegate = self;
        [self.getMedalHUD show];
    } else {
        TaskViewController * vc = [[TaskViewController alloc] init];
        [self.rdv_tabBarController presentViewController:vc animated:YES completion:nil];
    }
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

- (void)loadSampleData {
    self.navigationItem.title = @"埃尔多安";
    
    NSString * imgFile = [[NSBundle mainBundle] pathForResource:@"map-sample" ofType:@"png"];
    UIImage * img = [UIImage imageWithContentsOfFile:imgFile];
    img = [UIImage imageWithCGImage:img.CGImage
                              scale:[UIScreen mainScreen].scale
                        orientation:UIImageOrientationUp];
    
    [self setupMapImage:img];
    
    MapAnchorView * anchor1 = [[MapAnchorView alloc] init];
    anchor1.anchorType = MapAnchorTypeStory;
    anchor1.number = 3;
    anchor1.frame = CGRectMake(200, 300, 100, 100);
    
    MapAnchorView * anchor2 = [[MapAnchorView alloc] init];
    anchor2.anchorType = MapAnchorTypeTask;
    anchor2.center = CGPointMake(300, 400);
    
    MapAnchorView * anchor3 = [[MapAnchorView alloc] init];
    anchor3.anchorType = MapAnchorTypeStoryFinished;
    anchor3.center = CGPointMake(400, 200);
    
    MapAnchorView * anchor4 = [[MapAnchorView alloc] init];
    anchor4.anchorType = MapAnchorTypeTaskFinished;
    anchor4.center = CGPointMake(100, 500);
    
    [self.mapView addSubview:anchor1];
    [self.mapView addSubview:anchor2];
    [self.mapView addSubview:anchor3];
    [self.mapView addSubview:anchor4];
}

@end
