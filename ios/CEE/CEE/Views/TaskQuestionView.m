//
//  TaskQuestionView.m
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import ReactiveCocoa;

#import "TaskQuestionView.h"
#import "AppearanceConstants.h"

@implementation TaskQuestionView

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
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 10;
    [self addSubview:self.containerView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"弹窗关闭按钮_前景"] forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
    
    self.photoView = [[UIImageView alloc] init];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.containerView addSubview:self.photoView];
    
    UIImage * locationIcon = [UIImage imageNamed:@"白定位"];
    self.locationAttachment = [[NSTextAttachment alloc] init];
    self.locationAttachment.image = locationIcon;
    UIFont * font = [UIFont fontWithName:kCEEFontNameRegular size:13];
    CGFloat mid = font.descender + font.capHeight;
    self.locationAttachment.bounds = CGRectIntegral(CGRectMake(0,
                                                               font.descender - locationIcon.size.height / 2 + mid + 2,
                                                               locationIcon.size.width,
                                                               locationIcon.size.height));
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.locationLabel];
    
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.numberOfLines = 10;
    self.questionLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:10];
    self.questionLabel.textColor = kCEETextBlackColor;
    [self.containerView addSubview:self.questionLabel];
   
    self.optionButtons = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIButton * optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [optionButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
        optionButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:10];
        optionButton.layer.masksToBounds = YES;
        optionButton.layer.cornerRadius = 6;
        RAC(optionButton, backgroundColor) = [RACObserve(optionButton, selected) map:^(NSNumber *selected) {
            if (selected.boolValue) {
                return kCEEThemeYellowColor;
            } else {
                return kCEECircleGrayColor;
            }
        }];
        [optionButton addTarget:self action:@selector(optionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionButtons addObject:optionButton];
    }
    
    self.pageControl = [[UIPageControl alloc] init];
    [self.containerView addSubview:self.pageControl];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = kCEEThemeYellowColor;
    self.confirmButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    [self.confirmButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.containerView addSubview:self.confirmButton];
    
    [self setupLayout];
    
    [RACObserve(self, selectedIndex) subscribeNext:^(NSNumber *index) {
        for (UIButton * button in self.optionButtons) {
            button.selected = NO;
        }
        
        if (index.integerValue < 0) {
            return;
        }

        self.optionButtons[index.integerValue].selected = YES;
    }];
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
        make.height.mas_equalTo(79);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.photoView);
    }];
    
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_bottom).offset(10);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.height.mas_equalTo(65);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.height.mas_equalTo(48);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.bottom.equalTo(self.confirmButton.mas_top).offset(6);
    }];
}

- (void)optionButtonPressed:(UIButton *)button {
    self.selectedIndex = [self.optionButtons indexOfObject:button];
}

- (void)loadOptions:(NSArray<NSString *> *)options {
    self.selectedIndex = -1;
    for (UIButton * optionButton in self.optionButtons) {
        [optionButton removeFromSuperview];
    }
    for (NSUInteger i = 0; i < options.count; i++) {
        UIButton * optionButton = self.optionButtons[i];
        NSString * option = options[i];
        [optionButton setTitle:option forState:UIControlStateNormal];
        optionButton.selected = NO;
        [self.containerView addSubview:optionButton];
        if (i == 0) {
            [optionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.questionLabel.mas_bottom).offset(10);
                make.centerX.equalTo(self.containerView.mas_centerX);
                make.width.mas_equalTo(180);
                make.height.mas_equalTo(20);
            }];
        } else {
            UIButton * prevButton = self.optionButtons[i - 1];
            [optionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(prevButton.mas_bottom).offset(12);
                make.centerX.equalTo(self.containerView.mas_centerX);
                make.width.mas_equalTo(180);
                make.height.mas_equalTo(20);
            }];
        }
    }
}

- (void)setLocation:(NSString *)location {
    NSAttributedString * attachment = [NSAttributedString attributedStringWithAttachment:self.locationAttachment];
    NSAttributedString * locationAttriStr =
    [[NSAttributedString alloc] initWithString:location
                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:13],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]}];
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] initWithAttributedString:attachment];
    [result appendAttributedString:locationAttriStr];
    self.locationLabel.attributedText = result;
}

@end
