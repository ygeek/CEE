//
//  StoryInfoView.m
//  CEE
//
//  Created by Meng on 16/4/17.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "StoryInfoView.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"

@implementation StoryInfoView

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
    self.timingIcon = [[UIImageView alloc] init];
    self.heartIcon = [[UIImageView alloc] init];
    self.distanceIcon = [[UIImageView alloc] init];
    self.timingLabel = [[UILabel alloc] init];
    self.heartLabel = [[UILabel alloc] init];
    self.distanceLabel = [[UILabel alloc] init];
    
    [self addSubview:self.timingIcon];
    [self addSubview:self.heartIcon];
    [self addSubview:self.distanceIcon];
    [self addSubview:self.timingLabel];
    [self addSubview:self.heartLabel];
    [self addSubview:self.distanceLabel];
    
    self.timingIcon.contentMode = UIViewContentModeCenter;
    self.timingIcon.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.heartIcon.contentMode = UIViewContentModeCenter;
    self.heartIcon.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.distanceIcon.contentMode = UIViewContentModeCenter;
    self.distanceIcon.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.timingLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.timingLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:18];
    self.timingLabel.textColor = [UIColor whiteColor];
    self.timingLabel.textAlignment = NSTextAlignmentCenter;
    
    self.heartLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.heartLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:18];
    self.heartLabel.textColor = [UIColor whiteColor];
    self.heartLabel.textAlignment = NSTextAlignmentCenter;
    
    self.distanceLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.distanceLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:18];
    self.distanceLabel.textColor = [UIColor whiteColor];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.timingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(44);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 3.0);
    }];
    
    [self.heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(44);
        make.left.equalTo(self.timingLabel.mas_right);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 3.0);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(44);
        make.left.equalTo(self.heartLabel.mas_right);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 3.0);
    }];
    
    [self.timingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.timingLabel.mas_top);
        make.height.mas_equalTo(90);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 3.0);
    }];
    
    [self.heartIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.timingIcon.mas_right);
        make.bottom.equalTo(self.heartLabel.mas_top);
        make.height.mas_equalTo(90);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 3.0);
    }];
    
    [self.distanceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.heartIcon.mas_right);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.distanceLabel.mas_top);
        make.height.mas_equalTo(90);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 3.0);
    }];
    
    self.timingIcon.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(25, 25)];
    self.heartIcon.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(25, 25)];
    self.distanceIcon.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(25, 25)];
    self.timingLabel.text = @"120";
    self.heartLabel.text = @"243";
    self.distanceLabel.text = @"5.1";
}

@end
