//
//  UserProfileView.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "UserProfileView.h"
#import "AppearanceConstants.h"


@implementation UserProfileView

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
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 66;
    [self addSubview:self.headImageView];
    
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:40];
    self.nicknameLabel.textColor = hexColor(0xb4b4b4);
    [self addSubview:self.nicknameLabel];
    
    self.coinLabel = [[UILabel alloc] init];
    self.coinLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:26];
    self.coinLabel.textColor = kCEETextBlackColor;
    [self addSubview:self.coinLabel];
    
    self.coinTitleLabel = [[UILabel alloc] init];
    self.coinTitleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:20];
    self.coinTitleLabel.textColor = hexColor(0xb4b4b4);
    self.coinTitleLabel.text = @"金币";
    [self addSubview:self.coinTitleLabel];
    
    self.friendsLabel = [[UILabel alloc] init];
    self.friendsLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:26];
    self.friendsLabel.textColor = kCEETextBlackColor;
    [self addSubview:self.friendsLabel];
    
    self.friendsTitleLabel = [[UILabel alloc] init];
    self.friendsTitleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:20];
    self.friendsTitleLabel.textColor = hexColor(0xb4b4b4);
    self.friendsTitleLabel.text = @"好友";
    [self addSubview:self.friendsTitleLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(66);
        make.width.mas_offset(132);
        make.height.mas_offset(132);
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.headImageView.mas_bottom).offset(18);
    }];
    
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(282);
        make.centerX.equalTo(self.coinTitleLabel.mas_centerX);
    }];
    
    [self.coinTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-83);
        make.top.equalTo(self.coinLabel.mas_bottom).offset(18);
    }];
    
    [self.friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(282);
        make.centerX.equalTo(self.friendsTitleLabel.mas_centerX);
    }];
    
    [self.friendsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(83);
        make.top.equalTo(self.friendsLabel.mas_bottom).offset(18);
    }];
}

@end
