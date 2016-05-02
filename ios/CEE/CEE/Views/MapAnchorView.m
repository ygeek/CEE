//
//  MapAnchorView.m
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "MapAnchorView.h"
#import "AppearanceConstants.h"


NSString * const kAnchorTypeNameStory = @"story";
NSString * const kAnchorTypeNameTask = @"task";


@interface MapAnchorView ()
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * numberLabel;
@end


@implementation MapAnchorView

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
    self.layer.anchorPoint = CGPointMake(0.5, 1);
    self.iconView = [[UIImageView alloc] init];
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    self.numberLabel.textColor = kCEETextBlackColor;
    
    [self addSubview:self.iconView];
    [self addSubview:self.numberLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-6);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (void)setAnchorType:(MapAnchorType)anchorType {
    _anchorType = anchorType;
    switch (anchorType) {
        case MapAnchorTypeTask:
            self.iconView.image = [UIImage imageNamed:@"地图定位"];
            break;
        case MapAnchorTypeStory:
            self.iconView.image = [UIImage imageNamed:@"地图定位_story"];
            break;
        case MapAnchorTypeTaskFinished:
            self.iconView.image = [UIImage imageNamed:@"地图定位_黑"];
            break;
        case MapAnchorTypeStoryFinished:
            self.iconView.image = [UIImage imageNamed:@"黑色story"];
            break;
        default:
            break;
    }
}

- (void)setNumber:(NSInteger)number {
    self.numberLabel.text = [@(number) stringValue];
}

@end
