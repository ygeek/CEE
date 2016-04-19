//
//  RefreshingPanel.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "RefreshingPanel.h"
#import "AppearanceConstants.h"

@interface RefreshingPanel ()
@property (nonatomic, strong) UIImageView * iconView;
@end


@implementation RefreshingPanel

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

+ (CGFloat)defaultHeight {
    return 58 + 23 + 15;
}

- (void)commonInit {
    self.iconView = [[UIImageView alloc] init];
    [self addSubview:self.iconView];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(58);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(23);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    
    self.iconView.backgroundColor = [UIColor grayColor];
}

@end
