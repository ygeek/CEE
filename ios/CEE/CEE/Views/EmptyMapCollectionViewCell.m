//
//  EmptyMapCollectionViewCell.m
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "EmptyMapCollectionViewCell.h"
#import "AppearanceConstants.h"

@implementation EmptyMapCollectionViewCell

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
    self.circleView = [[UIView alloc] init];
    self.circleView.backgroundColor = kCEECircleGrayColor;
    self.circleView.layer.cornerRadius = 15;
    self.circleView.layer.masksToBounds = YES;
    
    [self addSubview:self.circleView];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

@end
