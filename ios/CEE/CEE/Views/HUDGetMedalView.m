//
//  HUDGetMedalView.m
//  CEE
//
//  Created by Meng on 16/4/28.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDGetMedalView.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"


@interface HUDGetMedalView ()
@property (nonatomic, strong) UIView * panelView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UIImageView * backgroundView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIButton * confirmButton;
@end


@implementation HUDGetMedalView

- (void)commonInit {
    [super commonInit];
    self.overlayAlpha = 0.65;
}

- (UIView *)genHUDView {
    if (!self.panelView) {
        self.panelView = [[UIView alloc] init];
        self.panelView.backgroundColor = [UIColor whiteColor];
        self.panelView.layer.cornerRadius = 10;
        self.panelView.layer.masksToBounds = YES;
        
        self.backgroundView = [[UIImageView alloc] init];
        [self.panelView addSubview:self.backgroundView];
        
        self.iconView = [[UIImageView alloc] init];
        [self.panelView addSubview:self.iconView];
       
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
        self.messageLabel.textColor = kCEETextYellowColor;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.text = @"获得新徽章！";
        [self.panelView addSubview:self.messageLabel];
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.backgroundColor = [UIColor whiteColor];
        [self.confirmButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.panelView addSubview:self.confirmButton];
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.panelView.mas_top);
            make.left.equalTo(self.panelView.mas_left);
            make.right.equalTo(self.panelView.mas_right);
            make.height.mas_equalTo(251);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panelView.mas_centerX);
            make.top.equalTo(self.panelView.mas_top).offset(63);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(95);
        }];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panelView.mas_centerX);
            make.top.equalTo(self.iconView.mas_bottom).offset(18);
        }];
        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.panelView.mas_left);
            make.right.equalTo(self.panelView.mas_right);
            make.bottom.equalTo(self.panelView.mas_bottom);
            make.height.mas_equalTo(48);
        }];
    }
    return self.panelView;
}

- (void)makeHUDConstraints {
    [self.hudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(232);
        make.height.mas_equalTo(251 + 48);
        make.center.equalTo(self.hudView.superview);
    }];
}

- (void)updateData {
    [self loadSampleData];
}

- (void)loadSampleData {
    self.backgroundView.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(232, 251)];
    self.iconView.image = [UIImage imageWithColor:[UIColor greenColor] size:CGSizeMake(180, 95)];
}

@end
