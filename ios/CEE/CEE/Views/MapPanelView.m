//
//  MapPanelView.m
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "MapPanelView.h"
#import "AppearanceConstants.h"

@implementation MapPanelView

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
    self.backgroundColor = kCEEThemeYellowColor;
    
    NSMutableArray<UIButton *> * mapButtons = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(mapPressed:) forControlEvents:UIControlEventTouchUpInside];
        [mapButtons addObject:button];
        
        [self addSubview:button];
    }
    self.mapButtons = mapButtons;
    
    self.moreMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreMapButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.moreMapButton setTitle:@"更多地图 >" forState:UIControlStateNormal];
    self.moreMapButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:11];
    
    [self addSubview:self.moreMapButton];
    
    [self.mapButtons[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(22);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.mapButtons[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mapButtons[0]).offset(38);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.mapButtons[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mapButtons[1]).offset(38);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.moreMapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-23);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(96);
    }];
}

- (void)mapPressed:(id)sender {
    
}


@end
