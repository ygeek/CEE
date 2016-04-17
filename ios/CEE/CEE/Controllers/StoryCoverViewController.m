//
//  StoryCoverViewController.m
//  CEE
//
//  Created by Meng on 16/4/17.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import RDVTabBarController;

#import "StoryCoverViewController.h"
#import "StoryInfoView.h"
#import "StoryDifficultyView.h"
#import "StoryTagView.h"
#import "UIImage+Utils.h"
#import "AppearanceConstants.h"

@interface StoryCoverViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIScrollView * imagesScrollView;
@property (nonatomic, strong) StoryInfoView * infoView;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) StoryDifficultyView * difficultyView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * descView;
@property (nonatomic, strong) NSMutableArray<StoryTagView *> * tagViews;
@property (nonatomic, strong) UIImageView * progressIcon;
@property (nonatomic, strong) UILabel * progressTitleLabel;
@property (nonatomic, strong) UILabel * progressLabel;
@property (nonatomic, strong) UIImageView * distanceIcon;
@property (nonatomic, strong) UILabel * distanceTitleLabel;
@property (nonatomic, strong) UILabel * distanceLabel;
@property (nonatomic, strong) UIButton * goButton;

@property (nonatomic, strong) NSMutableArray<UIImageView *> * imageViews;

@end

@implementation StoryCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentView = [[UIView alloc] init];
    
    self.imagesScrollView = [[UIScrollView alloc] init];
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.showsHorizontalScrollIndicator = NO;
    self.imagesScrollView.showsVerticalScrollIndicator = NO;
    
    self.infoView = [[StoryInfoView alloc] init];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.hidesForSinglePage = YES;
    [self.pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    
    /*
    self.difficultyView = [[StoryDifficultyView alloc] init];
    
    self.lineView = [[UIView alloc] init];
    
    self.descView = [[UILabel alloc] init];
    
    self.tagViews = [NSMutableArray array];
    
    self.progressIcon = [[UIImageView alloc] init];
    self.progressTitleLabel = [[UILabel alloc] init];
    self.progressLabel = [[UILabel alloc] init];
    
    self.distanceIcon = [[UIImageView alloc] init];
    self.distanceTitleLabel = [[UILabel alloc] init];
    self.distanceLabel = [[UILabel alloc] init];
     */
    
    self.goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.goButton setTitle:@"G  O" forState:UIControlStateNormal];
    [self.goButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.goButton setBackgroundColor:kCEEThemeYellowColor];
    self.goButton.titleLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:35];
    
    [self.view addSubview:self.contentScrollView];
    
    [self.contentScrollView addSubview:self.contentView];
    
    [self.contentView addSubview:self.imagesScrollView];
    [self.contentView addSubview:self.infoView];
    
    [self.contentView addSubview:self.pageControl];
    
    /*
    [self.contentView addSubview:self.difficultyView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.descView];
    
    // TODO (zhangmeng): add tag views
    
    [self.contentView addSubview:self.progressIcon];
    [self.contentView addSubview:self.progressTitleLabel];
    [self.contentView addSubview:self.progressLabel];
    
    [self.contentView addSubview:self.distanceIcon];
    [self.contentView addSubview:self.distanceTitleLabel];
    [self.contentView addSubview:self.distanceLabel];
     */
    
    [self.view addSubview:self.goButton];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
    }];
    
    [self.imagesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(406);
        
        // TODO (zhangmeng): remove this
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.imagesScrollView.mas_bottom);
        make.height.mas_equalTo(90 + 44);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.infoView.mas_top).offset(-5);
    }];
    
    /*
    [self.difficultyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.imagesScrollView.mas_bottom).offset(32);
        make.height.mas_equalTo(16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.difficultyView.mas_bottom).offset(12);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(1);
    }];
    
    [self.descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView).offset(15);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
     */
    
    [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
    
    [self.contentView layoutIfNeeded];
    
    self.contentScrollView.contentSize = self.contentView.frame.size;
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(23, 23)]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backPressed:)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(23, 23)]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(menuPressed:)];
   
    [self loadCoverImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
}


#pragma mark - Actions Handling

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menuPressed:(id)sender {
    
}

- (void)pageControlClicked:(UIPageControl *)pageControl {
    [self.imagesScrollView scrollRectToVisible:self.imageViews[pageControl.currentPage].frame animated:YES];
}

#pragma mark - Private Methods

- (void)loadCoverImages {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    // self.imagesScrollView.pagingEnabled = YES;
    UIImage * img1 = [UIImage imageWithColor:[UIColor greenColor]
                                        size:CGSizeMake(screenWidth, 406)];
    UIImage * img2 = [UIImage imageWithColor:[UIColor yellowColor]
                                        size:CGSizeMake(screenWidth, 406)];
    UIImage * img3 = [UIImage imageWithColor:[UIColor redColor]
                                        size:CGSizeMake(screenWidth, 406)];
    
    UIImageView * img1View = [[UIImageView alloc] initWithImage:img1];
    img1View.frame = CGRectMake(0, 0, screenWidth, 406);
    UIImageView * img2View = [[UIImageView alloc] initWithImage:img2];
    img2View.frame = CGRectMake(screenWidth, 0, screenWidth, 406);
    UIImageView * img3View = [[UIImageView alloc] initWithImage:img3];
    img3View.frame = CGRectMake(screenWidth + screenWidth, 0, screenWidth, 406);
    
    for (UIImageView * imgView in self.imageViews) {
        [imgView removeFromSuperview];
    }
    self.imageViews = [NSMutableArray array];
    
    [self.imagesScrollView addSubview:img1View];
    [self.imageViews addObject:img1View];
    
    [self.imagesScrollView addSubview:img2View];
    [self.imageViews addObject:img2View];
    
    [self.imagesScrollView addSubview:img3View];
    [self.imageViews addObject:img3View];
    
    self.imagesScrollView.contentSize = CGSizeMake(screenWidth * 3, 406);
    
    self.pageControl.numberOfPages = self.imageViews.count;
    self.pageControl.currentPage = 0;
    
    [self.imagesScrollView scrollRectToVisible:self.imageViews[0].frame animated:NO];
}

@end
