//
//  StoryDifficultyView.m
//  CEE
//
//  Created by Meng on 16/4/17.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "StoryDifficultyView.h"

@interface StoryDifficultyView ()
@property (nonatomic, strong) NSMutableArray<UIImageView *> * starViews;
@end


@implementation StoryDifficultyView

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
    self.starViews = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        UIImageView * starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"星星"]];
        //starView.backgroundColor = [UIColor grayColor]; // TODO (zhangmeng): load image icon
        [self.starViews addObject:starView];
        [self addSubview:starView];
    }
    
    [self.starViews[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.starViews[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.starViews[2].mas_left).offset(-7);
    }];
    
    [self.starViews[3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.starViews[2].mas_right).offset(7);
    }];
    
    [self.starViews[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.starViews[1].mas_left).offset(-7);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.starViews[4] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.starViews[3].mas_right).offset(7);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)setDifficulty:(NSInteger)difficulty {
    // TODO (zhangmeng): set star images according to difficulty
}

@end
