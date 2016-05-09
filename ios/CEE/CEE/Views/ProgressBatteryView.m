//
//  ProgressBatteryView.m
//  CEE
//
//  Created by Meng on 16/5/9.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "ProgressBatteryView.h"

@implementation ProgressBatteryView

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
    self.frameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电池外轮廓"]];
    [self addSubview:self.frameView];
    [self.frameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(90);
    }];
    
    NSMutableArray<UIImageView *> * lines = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电池电量"]];
        [lines addObject:line];
        [self.frameView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.frameView.mas_centerX);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(1.5);
            if (i == 0) {
                make.bottom.equalTo(self.frameView.mas_bottom).offset(-9);
            } else {
                make.bottom.equalTo(lines[i - 1].mas_top).offset(-6);
            }
        }];
    }
    self.lineViews = lines;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    for (int i = 0; i < 10; i++) {
        if (i * 10.0 < progress) {
            self.lineViews[i].hidden = NO;
        } else {
            self.lineViews[i].hidden = YES;
        }
    }
}

@end
