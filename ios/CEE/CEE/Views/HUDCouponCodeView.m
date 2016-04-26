//
//  HUDCouponCodeView.m
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDCouponCodeView.h"
#import "AppearanceConstants.h"


@interface HUDCouponCodeView () <UIKeyInput>
@property (nonatomic, strong) UIView * container;
@property (nonatomic, copy) NSMutableString * codeText;
@property (nonatomic, strong) UILabel * num1Label;
@property (nonatomic, strong) UIView * separator1;
@property (nonatomic, strong) UILabel * num2Label;
@property (nonatomic, strong) UIView * separator2;
@property (nonatomic, strong) UILabel * num3Label;
@property (nonatomic, strong) UIView * separator3;
@property (nonatomic, strong) UILabel * num4Label;
@end


@implementation HUDCouponCodeView

- (UIView *)genHUDView {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor whiteColor];
        
        _num1Label = [[UILabel alloc] init];
        _num1Label.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
        _num1Label.textColor = kCEETextBlackColor;
        _num1Label.textAlignment = NSTextAlignmentCenter;
        [_container addSubview:_num1Label];
        
        _num2Label = [[UILabel alloc] init];
        _num2Label.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
        _num2Label.textColor = kCEETextBlackColor;
        _num2Label.textAlignment = NSTextAlignmentCenter;
        [_container addSubview:_num2Label];
        
        _num3Label = [[UILabel alloc] init];
        _num3Label.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
        _num3Label.textColor = kCEETextBlackColor;
        _num3Label.textAlignment = NSTextAlignmentCenter;
        [_container addSubview:_num3Label];
        
        _num4Label = [[UILabel alloc] init];
        _num4Label.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
        _num4Label.textColor = kCEETextBlackColor;
        _num4Label.textAlignment = NSTextAlignmentCenter;
        [_container addSubview:_num4Label];
        
        _separator1 = [[UIView alloc] init];
        _separator1.backgroundColor = kCEETextBlackColor;
        [_container addSubview:_separator1];
        
        _separator2 = [[UIView alloc] init];
        _separator2.backgroundColor = kCEETextBlackColor;
        [_container addSubview:_separator2];
        
        _separator3 = [[UIView alloc] init];
        _separator3.backgroundColor = kCEETextBlackColor;
        [_container addSubview:_separator3];
        
        [_num1Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_container.mas_top);
            make.bottom.equalTo(_container.mas_bottom);
            make.left.equalTo(_container.mas_left);
            make.width.equalTo(_container.mas_width).multipliedBy(0.25);
        }];
        
        [_num2Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_container.mas_top);
            make.bottom.equalTo(_container.mas_bottom);
            make.left.equalTo(_num1Label.mas_right);
            make.width.equalTo(_container.mas_width).multipliedBy(0.25);
        }];
        
        [_num3Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_container.mas_top);
            make.bottom.equalTo(_container.mas_bottom);
            make.left.equalTo(_num2Label.mas_right);
            make.width.equalTo(_container.mas_width).multipliedBy(0.25);
        }];
        
        [_num4Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_container.mas_top);
            make.bottom.equalTo(_container.mas_bottom);
            make.left.equalTo(_num3Label.mas_right);
            make.width.equalTo(_container.mas_width).multipliedBy(0.25);
        }];
        
        [_separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_container.mas_centerY);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(28);
            make.left.equalTo(_num1Label.mas_right);
        }];
        
        [_separator2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_container.mas_centerY);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(28);
            make.left.equalTo(_num2Label.mas_right);
        }];
        
        [_separator3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_container.mas_centerY);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(28);
            make.left.equalTo(_num3Label.mas_right);
        }];
    }
    return _container;
}

- (void)makeHUDConstraints {
    [self.hudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(230);
        make.height.mas_equalTo(52);
        make.center.equalTo(self.hudView.superview);
    }];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSMutableString *)codeText {
    if (!_codeText) {
        _codeText = [NSMutableString string];
    }
    return _codeText;
}

- (void)updateUI {
    if (self.codeText.length > 0) {
        self.num1Label.text = [self.codeText substringWithRange:NSMakeRange(0, 1)];
    } else {
        self.num1Label.text = @"";
    }
    
    if (self.codeText.length > 1) {
        self.num2Label.text = [self.codeText substringWithRange:NSMakeRange(1, 1)];
    } else {
        self.num2Label.text = @"";
    }
    
    if (self.codeText.length > 2) {
        self.num3Label.text = [self.codeText substringWithRange:NSMakeRange(2, 1)];
    } else {
        self.num3Label.text = @"";
    }
    
    if (self.codeText.length > 3) {
        self.num4Label.text = [self.codeText substringWithRange:NSMakeRange(3, 1)];
    } else {
        self.num4Label.text = @"";
    }
}

#pragma mark - UIKeyInput

- (BOOL)hasText {
    return self.codeText.length > 0;
}

- (void)insertText:(NSString *)text {
    if (self.codeText.length >= 4) {
        return;
    }
    [self.codeText appendString:text];

    [self updateUI];
}

- (void)deleteBackward {
    if (self.codeText.length == 0) {
        return;
    }
    [self.codeText deleteCharactersInRange:NSMakeRange(self.codeText.length - 1, 1)];
    
    [self updateUI];
}

- (void)show {
    [super show];
    self.keyboardType = UIKeyboardTypeNumberPad;
    [self becomeFirstResponder];
}

- (void)dismiss {
    [self resignFirstResponder];
    [super dismiss];
}

@end
