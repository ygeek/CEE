//
//  StoryCoverViewController.m
//  CEE
//
//  Created by Meng on 16/4/17.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import RDVTabBarController;
@import SDWebImage;

#import "StoryCoverViewController.h"
#import "CEEStory.h"
#import "StoryInfoView.h"
#import "StoryDifficultyView.h"
#import "StoryTagView.h"
#import "UIImage+Utils.h"
#import "UIImageView+Utils.h"
#import "AppearanceConstants.h"

@interface StoryCoverViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIScrollView * imagesScrollView;
@property (nonatomic, strong) StoryInfoView * infoView;
@property (nonatomic, strong) StoryInfoView * infoViewPinning;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) StoryDifficultyView * difficultyView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * descView;

@property (nonatomic, strong) UIView * tagContainer;
@property (nonatomic, strong) NSMutableArray<StoryTagView *> * tagViews;

@property (nonatomic, strong) UIImageView * progressIcon;
@property (nonatomic, strong) UILabel * progressTitleLabel;
@property (nonatomic, strong) UILabel * progressLabel;

@property (nonatomic, strong) UIImageView * distanceIcon;
@property (nonatomic, strong) UILabel * distanceTitleLabel;
@property (nonatomic, strong) UILabel * distanceLabel;

@property (nonatomic, strong) UIButton * goButton;

@property (nonatomic, strong) NSMutableArray<UIImageView *> * imageViews;

@property (nonatomic, assign) BOOL hasProgress;

@end

@implementation StoryCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.imagesScrollView = [[UIScrollView alloc] init];
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.bounces = NO;
    self.imagesScrollView.showsHorizontalScrollIndicator = NO;
    self.imagesScrollView.showsVerticalScrollIndicator = NO;
    
    self.infoView = [[StoryInfoView alloc] init];
    self.infoViewPinning = [[StoryInfoView alloc] init];
    self.infoViewPinning.hidden = YES;
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.hidesForSinglePage = YES;
    [self.pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    
    self.difficultyView = [[StoryDifficultyView alloc] init];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kCEETextBlackColor;
    
    self.descView = [[UILabel alloc] init];
    self.descView.font = [UIFont fontWithName:kCEEFontNameRegular size:11];
    self.descView.textColor = kCEETextDescColor;
    self.descView.numberOfLines = 100;
    self.descView.textAlignment = NSTextAlignmentCenter;
    
    self.tagContainer = [[UIView alloc] init];
    
    self.progressIcon = [[UIImageView alloc] init];
    self.progressIcon.contentMode = UIViewContentModeCenter;
    self.progressTitleLabel = [[UILabel alloc] init];
    self.progressTitleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:10];
    self.progressTitleLabel.textColor = kCEETextBlackColor;
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:15];
    self.progressLabel.textColor = kCEETextBlackColor;
    
    self.distanceIcon = [[UIImageView alloc] init];
    self.distanceIcon.contentMode = UIViewContentModeCenter;
    self.distanceTitleLabel = [[UILabel alloc] init];
    self.distanceTitleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:10];
    self.distanceTitleLabel.textColor = kCEETextBlackColor;
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:15];
    self.distanceLabel.textColor = kCEETextBlackColor;
    
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
    
    [self.view addSubview:self.infoViewPinning];
    
    [self.contentView addSubview:self.difficultyView];
    
    [self.contentView addSubview:self.lineView];
    
    [self.contentView addSubview:self.descView];
    
    [self.contentView addSubview:self.tagContainer];
    
    [self.contentView addSubview:self.progressIcon];
    [self.contentView addSubview:self.progressTitleLabel];
    [self.contentView addSubview:self.progressLabel];
    
    [self.contentView addSubview:self.distanceIcon];
    [self.contentView addSubview:self.distanceTitleLabel];
    [self.contentView addSubview:self.distanceLabel];

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
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.imagesScrollView.mas_bottom);
        make.height.mas_equalTo(90 + 44);
    }];
    
    [self.infoViewPinning mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(90 + 44);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.infoView.mas_top).offset(-5);
    }];
    
    [self.difficultyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.imagesScrollView.mas_bottom).offset(32);
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
    
    [self.tagContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descView.mas_bottom).offset(41);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.progressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagContainer.mas_bottom).offset(28);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(100);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressIcon.mas_bottom).offset(11);
        make.left.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.progressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.distanceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressLabel.mas_bottom).offset(17);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(100);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceIcon.mas_bottom).offset(11);
        make.left.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.distanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_centerX);
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-60);
    }];
   
    [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
    
    [self.contentView layoutIfNeeded];
    
    self.contentScrollView.contentSize = self.contentView.frame.size;
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"弹窗返回_发光"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backPressed:)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"弹窗个人主页_发光"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(menuPressed:)];
   
    [self loadCoverImages];
    
    [self.infoView loadStory:self.story];
    
    [self.infoViewPinning loadStory:self.story];
    
    [self loadTags];
    
    self.descView.text = self.story.desc;
    
    self.difficultyView.difficulty = self.story.difficulty.integerValue;
    
    self.progressIcon.backgroundColor = [UIColor grayColor];
    self.progressTitleLabel.text = @"进度：";
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.story.progress.floatValue * 100];
    
    [self.distanceIcon cee_setImageWithKey:self.story.tour_img_key];
    self.distanceTitleLabel.text = @"行程：";
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1fKM", self.story.distance.floatValue];
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
    if ([scrollView isEqual:self.imagesScrollView]) {
        int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        self.pageControl.currentPage = page;
    } else {
        CGRect frame = [self.infoView convertRect:self.infoView.bounds toView:self.view];
        if (frame.origin.y < 0) {
            self.infoView.hidden = YES;
            self.infoViewPinning.hidden = NO;
        } else {
            self.infoView.hidden = NO;
            self.infoViewPinning.hidden = YES;
        }
    }
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
    for (UIImageView * imgView in self.imageViews) {
        [imgView removeFromSuperview];
    }
    self.imageViews = [NSMutableArray array];
    CGFloat x = 0;
    for (NSString * key in self.story.image_keys) {
        UIImageView * imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.backgroundColor = kCEEBackgroundGrayColor;
        imgView.frame = CGRectMake(x, 0, screenWidth, 406);
        x += screenWidth;
        [imgView cee_setImageWithKey:key];
        [self.imagesScrollView addSubview:imgView];
        [self.imageViews addObject:imgView];
    }
    
    self.imagesScrollView.contentSize = CGSizeMake(screenWidth * self.imageViews.count, 406);
    
    self.pageControl.numberOfPages = self.imageViews.count;
    self.pageControl.currentPage = 0;
    
    if (self.imageViews.count > 0) {
        [self.imagesScrollView scrollRectToVisible:self.imageViews[0].frame animated:NO];
    }
}

- (void)loadTags {
    for (StoryTagView * tagView in self.tagViews) {
        [tagView removeFromSuperview];
    }
    
    self.tagViews = [NSMutableArray array];
    for (NSString * tag in self.story.tags) {
        StoryTagView * tagView = [[StoryTagView alloc] init];
        tagView.tagText = tag;
        [self.tagContainer addSubview:tagView];
        [self.tagViews addObject:tagView];
    }
   
    if (self.tagViews.count == 0) {
        return;
    }
    
    if (self.tagViews.count % 2 == 0) {
        int tag_center_left = (int)(self.tagViews.count / 2) - 1;
        int tag_center_right = tag_center_left + 1;
        
        [self.tagViews[tag_center_left] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagContainer.mas_centerY);
            make.right.equalTo(self.tagContainer.mas_centerX).offset(-7);
            make.bottom.equalTo(self.tagContainer.mas_bottom);
        }];
        
        [self.tagViews[tag_center_right] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagContainer.mas_centerY);
            make.left.equalTo(self.tagContainer.mas_centerX).offset(7);
            make.bottom.equalTo(self.tagContainer.mas_bottom);
        }];
        
        for (int i = tag_center_left - 1; i >= 0; i--) {
            [self.tagViews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.tagViews[i + 1].mas_centerY);
                make.right.equalTo(self.tagViews[i + 1].mas_left).offset(-15);
            }];
        }
        
        for (int i = tag_center_right + 1; i < self.tagViews.count; i++) {
            [self.tagViews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.tagViews[i - 1].mas_centerY);
                make.left.equalTo(self.tagViews[i - 1].mas_right).offset(15);
            }];
        }
    } else {
        int tag_length_half = (int)(self.tagViews.count / 2);
        
        [self.tagViews[tag_length_half] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.tagContainer);
            make.bottom.equalTo(self.tagContainer.mas_bottom);
        }];
        
        for (int i = tag_length_half - 1; i > -1; i--) {
            [self.tagViews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.tagViews[i + 1].mas_centerY);
                make.right.equalTo(self.tagViews[i + 1].mas_left).offset(-15);
            }];
        }
        
        for (int i = tag_length_half + 1; i < self.tagViews.count; i++) {
            [self.tagViews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.tagViews[i - 1].mas_centerY);
                make.left.equalTo(self.tagViews[i - 1].mas_right).offset(15);
            }];
        }
    }
}

@end
