//
//  VerificationCodeViewController.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "VerificationCodeViewController.h"
#import "AppearanceConstants.h"
#import "FillProfileViewController.h"
#import "UIImage+Utils.h"

@interface VerificationCodeViewController ()
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UITextField * codeField;
@property (nonatomic, strong) UIView * codeUnderline;
@property (nonatomic, strong) UIButton * requireCodeButton;
@property (nonatomic, strong) UIButton * nextButton;
@property (nonatomic, strong) UIButton * switchButton;
@property (nonatomic, strong) UIView * switchUnderline;
@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.attributedText = [self genMessageText];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.backgroundColor = kCEETextYellowColor;
    self.nextButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    [self.nextButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.requireCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.requireCodeButton.layer.borderColor = kCEETextBlackColor.CGColor;
    self.requireCodeButton.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    self.requireCodeButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    [self.requireCodeButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.requireCodeButton setTitle:@"获取" forState:UIControlStateNormal];
    
    self.codeField = [[UITextField alloc] init];
    self.codeField.attributedPlaceholder
        = [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                          attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                                                       NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    self.codeField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.codeField.textColor = kCEETextBlackColor;
    self.codeField.textAlignment = NSTextAlignmentCenter;
    
    self.codeUnderline = [[UIView alloc] init];
    self.codeUnderline.backgroundColor = kCEETextBlackColor;
    
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    [self.switchButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.switchButton setTitle:@"更换获取验证方式" forState:UIControlStateNormal];
    
    self.switchUnderline = [[UIView alloc] init];
    self.switchUnderline.backgroundColor = kCEETextBlackColor;
    
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.requireCodeButton];
    [self.view addSubview:self.codeField];
    [self.view addSubview:self.codeUnderline];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.switchUnderline];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(146);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).offset(42 + 37 + 15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
    }];
    
    [self.requireCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nextButton.mas_top).offset(-15);
        make.right.equalTo(self.nextButton.mas_right);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(37);
    }];
    
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nextButton.mas_top).offset(-15);
        make.left.equalTo(self.nextButton.mas_left);
        make.height.equalTo(self.requireCodeButton.mas_height);
        make.right.equalTo(self.requireCodeButton.mas_left).offset(-10);
    }];
    
    [self.codeUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeField.mas_left);
        make.right.equalTo(self.codeField.mas_right);
        make.bottom.equalTo(self.codeField.mas_bottom);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-108);
        make.height.mas_equalTo(12);
    }];
    
    [self.switchUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.switchButton.mas_left);
        make.right.equalTo(self.switchButton.mas_right);
        make.top.equalTo(self.switchButton.mas_bottom).offset(4);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    self.navigationItem.leftBarButtonItem
        = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor]
                                                                    size:CGSizeMake(23, 23)]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(backPressed:)];
    
    self.navigationItem.rightBarButtonItem
        = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor]
                                                                    size:CGSizeMake(23, 23)]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(menuPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)genMessageText {
    NSMutableAttributedString * message
        = [[NSMutableAttributedString alloc] initWithString:@"我们已发送验证短信到 "
                                                 attributes:@{NSForegroundColorAttributeName: kCEETextBlackColor,
                                                              NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15]}];
    [message appendAttributedString:
        [[NSAttributedString alloc] initWithString:self.phoneNumber
                                        attributes:@{NSForegroundColorAttributeName: kCEETextYellowColor,
                                                     NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15]}]];
    return message;
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menuPressed:(id)sender {
    
}

- (void)nextPressed:(id)sender {
    FillProfileViewController * vc = [[FillProfileViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
