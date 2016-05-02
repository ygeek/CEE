//
//  AcquiredMapCollectionViewCell.m
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;


#import "AcquiredMapCollectionViewCell.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"
#import "CEEMap.h"
#import "UIImageView+Utils.h"


@implementation AcquiredMapCollectionViewCell

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
    self.containerView = [[UIView alloc] init];
    self.iconView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:11];
    self.titleLabel.textColor = kCEETextBlackColor;
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.iconView];
    [self.containerView addSubview:self.titleLabel];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(64);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView.mas_top);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.height.mas_equalTo(12);
        make.top.equalTo(self.iconView.mas_bottom).offset(13);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
}

- (void)loadMap:(CEEJSONMap *)map {
    [self.iconView cee_setImageWithKey:map.icon_key];
    self.titleLabel.text = map.name;
}


@end
