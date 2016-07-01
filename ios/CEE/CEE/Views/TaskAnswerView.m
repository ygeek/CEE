//
//  TaskAnswerView.m
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "TaskAnswerView.h"
#import "AppearanceConstants.h"

@implementation TaskAnswerView

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
    self.closeButtonBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"弹窗关闭按钮_背景"]];
    [self addSubview:self.closeButtonBG];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = kCEEThemeYellowColor;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 10;
    [self addSubview:self.containerView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"弹窗关闭按钮_前景"] forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
    
    self.photoView = [[UIImageView alloc] init];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.clipsToBounds = YES;
    [self.containerView addSubview:self.photoView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    self.titleLabel.textColor = kCEETextBlackColor;
    [self.containerView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.numberOfLines = 3;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    self.detailLabel.textColor = kCEETextBlackColor;
    [self.containerView addSubview:self.detailLabel];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.backgroundColor = [UIColor whiteColor];
    self.nextButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    [self.nextButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.nextButton setTitle:@"抬走！下一题" forState:UIControlStateNormal];
    [self.containerView addSubview:self.nextButton];
    
    [self setupLayout];
}

- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(232);
        make.height.mas_equalTo(360);
    }];
    
    
    [self.closeButtonBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.containerView.mas_right);
        make.centerY.equalTo(self.containerView.mas_top);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(27);
        make.center.equalTo(self.closeButtonBG);
    }];
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.height.mas_equalTo(180);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_bottom).offset(56);
        make.left.equalTo(self.containerView.mas_left).offset(20);
        make.right.equalTo(self.containerView.mas_right).offset(-20);
        make.height.mas_equalTo(18);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(24);
        make.left.equalTo(self.containerView.mas_left).offset(20);
        make.right.equalTo(self.containerView.mas_right).offset(-20);
        make.height.mas_equalTo(14);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.height.mas_equalTo(48);
    }];
}

@end
