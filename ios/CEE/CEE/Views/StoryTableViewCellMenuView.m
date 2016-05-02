//
//  StoryTableViewCellMenuView.m
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "StoryTableViewCellMenuView.h"
#import "AppearanceConstants.h"
#import "CEEStory.h"


@interface StoryTableViewCellMenuView ()
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIImageView * timingIcon;
@property (nonatomic, strong) UILabel * timingLabel;
@property (nonatomic, strong) UIImageView * heartIcon;
@property (nonatomic, strong) UILabel * heartLabel;
@property (nonatomic, strong) UIImageView * distanceIcon;
@property (nonatomic, strong) UILabel * distanceLabel;
@end


@implementation StoryTableViewCellMenuView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor blackColor];
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = kCEEThemeYellowColor;
    
    self.timingIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"统计耗时"]];
    
    self.timingLabel = [[UILabel alloc] init];
    self.timingLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:18];
    self.timingLabel.textColor = kCEEStoryMenuTextColor;
    
    self.heartIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"点赞"]];
    
    self.heartLabel = [[UILabel alloc] init];
    self.heartLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:18];
    self.heartLabel.textColor = kCEEStoryMenuTextColor;
    
    self.distanceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"里程数"]];
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:18];
    self.distanceLabel.textColor = kCEEStoryMenuTextColor;
    
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.timingIcon];
    [self.backgroundView addSubview:self.timingLabel];
    [self.backgroundView addSubview:self.heartIcon];
    [self.backgroundView addSubview:self.heartLabel];
    [self.backgroundView addSubview:self.distanceIcon];
    [self.backgroundView addSubview:self.distanceLabel];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 1.0 / [UIScreen mainScreen].scale, 0));
    }];
    
    [self.timingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top).offset(28);
        make.left.equalTo(self.backgroundView.mas_left).offset(33);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.timingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timingIcon.mas_centerY);
        make.left.equalTo(self.timingIcon.mas_right).offset(24);
    }];
    
    [self.heartIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top).offset(112);
        make.left.equalTo(self.backgroundView.mas_left).offset(33);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.heartIcon.mas_centerY);
        make.left.equalTo(self.heartIcon.mas_right).offset(24);
    }];
    
    [self.distanceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-28);
        make.left.equalTo(self.backgroundView.mas_left).offset(33);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceIcon.mas_centerY);
        make.left.equalTo(self.distanceIcon.mas_right).offset(24);
    }];

}

- (void)loadStory:(CEEJSONStory *)story {
    self.distanceLabel.text = story.distance.stringValue;
    self.timingLabel.text = story.time.stringValue;
    self.heartLabel.text = story.good.stringValue;
}

@end
