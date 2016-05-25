//
//  IntroViewController.m
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "IntroViewController.h"

@interface IntroViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * imagesScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSMutableArray<UIImageView *> * imageViews;
@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.imagesScrollView = [[UIScrollView alloc] init];
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.alwaysBounceVertical = NO;
    self.imagesScrollView.alwaysBounceHorizontal = YES;
    self.imagesScrollView.showsHorizontalScrollIndicator = NO;
    self.imagesScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.imagesScrollView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.hidesForSinglePage = YES;
    [self.pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.imageViews = [NSMutableArray array];
    for (NSString * imgName in @[@"对话1", @"对话2"]) {
        UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame = CGRectMake(screenSize.width * self.imageViews.count, 0, screenSize.width, screenSize.height);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageViews addObject:imgView];
        [self.imagesScrollView addSubview:imgView];
    }
    self.imagesScrollView.contentSize = CGSizeMake(screenSize.width * self.imageViews.count, screenSize.height);

    self.pageControl.numberOfPages = self.imageViews.count;
    self.pageControl.currentPage = 0;
    
    [self.imagesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.imagesScrollView.mas_bottom).offset(-30);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.imageViews.count > 0) {
        [self.imagesScrollView scrollRectToVisible:self.imageViews[0].frame animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pageControlClicked:(UIPageControl *)pageControl {
    [self.imagesScrollView scrollRectToVisible:self.imageViews[pageControl.currentPage].frame animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
    
    if (scrollView.contentOffset.x > scrollView.bounds.size.width * (self.imageViews.count - 1)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
