//
//  ThirdPartyLoginButton.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "ThirdPartyLoginButton.h"
#import "AppearanceConstants.h"


@implementation ThirdPartyLoginButton

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
    self.userInteractionEnabled = YES;
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeCenter;
    self.iconView.userInteractionEnabled = NO;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:9];
    self.titleLabel.textColor = kCEETextBlackColor;
    self.titleLabel.userInteractionEnabled = NO;
    
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.greaterThanOrEqualTo(self.mas_left);
        make.right.lessThanOrEqualTo(self.mas_right);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(2);
        make.centerX.equalTo(self.mas_centerX);
        make.left.greaterThanOrEqualTo(self.mas_left);
        make.right.lessThanOrEqualTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

@end
