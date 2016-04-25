//
//  WorldViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "WorldViewController.h"
#import "MapPanelView.h"
#import "MapAnchorView.h"

@interface WorldViewController ()
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIImageView * mapView;
@property (nonatomic, strong) NSMutableArray<MapAnchorView *> * anchorViews;
@property (nonatomic, strong) MapPanelView * panelView;
@end

@implementation WorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.bounces = NO;
    self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    
    self.mapView = [[UIImageView alloc] init];
    [self.contentScrollView addSubview:self.mapView];
    
    self.panelView = [[MapPanelView alloc] init];
    [self.view addSubview:self.panelView];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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

- (void)menuPressed:(id)sender {
    
}

- (void)setupMapImage:(UIImage *)image {
    self.mapView.image = image;
    self.contentScrollView.contentSize = self.mapView.image.size;
}

- (void)loadSampleData {
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
