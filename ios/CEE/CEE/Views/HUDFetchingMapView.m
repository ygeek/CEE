//
//  HUDFetchingMapView.m
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDFetchingMapView.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"
#import "UIImageView+Utils.h"


@interface HUDFetchingMapView ()
@property (nonatomic, strong) UIView * panelView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UIImageView * backgroundView;
@property (nonatomic, strong) UILabel * messageLabel;
@end


@implementation HUDFetchingMapView

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
        self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundView.clipsToBounds = YES;
        [self.panelView addSubview:self.backgroundView];
        
        self.iconView = [[UIImageView alloc] init];
        self.iconView.contentMode = UIViewContentModeCenter;
        [self.panelView addSubview:self.iconView];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
        self.messageLabel.textColor = kCEETextBlackColor;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.text = @"别闹，正在分配地图…";
        [self.panelView addSubview:self.messageLabel];
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.panelView.mas_top);
            make.left.equalTo(self.panelView.mas_left);
            make.right.equalTo(self.panelView.mas_right);
            make.height.mas_equalTo(251);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panelView.mas_centerX);
            make.top.equalTo(self.panelView.mas_top).offset(75);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
        }];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView.mas_bottom);
            make.bottom.equalTo(self.panelView.mas_bottom);
            make.left.equalTo(self.panelView.mas_left);
            make.right.equalTo(self.panelView.mas_right);
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
    
}

- (void)setMap:(CEEJSONMap *)map {
    _map = map;
    // TODO: use placeholder image
    [self.backgroundView cee_setImageWithKey:map.summary_image_key placeholder:[UIImage imageWithColor:kCEEThemeYellowColor size:CGSizeMake(232, 251)]];
    [self.iconView cee_setImageWithKey:map.icon_key];
}

@end
