//
//  MemoryItemView.m
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "MemoryItemView.h"
#import "AppearanceConstants.h"
#import "CEEStory.h"


@implementation MemoryItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeCenter;
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    self.nameLabel.textColor = UIColor.whiteColor;
    
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(92);
        make.height.mas_equalTo(92);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.iconView.mas_bottom).offset(3);
    }];
}

- (void)loadLevel:(CEEJSONLevel *)level {
    NSString * type = level.content[@"type"];
    if ([type isEqualToString:@"dialog"]) {
        self.iconView.image = [UIImage imageNamed:@"记忆-对话"];
    } else if ([type isEqualToString:@"video"]) {
        self.iconView.image = [UIImage imageNamed:@"记忆-播放"];
    }
    self.nameLabel.text = level.name;
}

@end
