//
//  LoginViewController.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "RegisterViewController.h"
#import "UIImage+Utils.h"
#import "AppearanceConstants.h"
#import "ThirdPartyLoginButton.h"
#import "VerificationCodeViewController.h"


@interface RegisterViewController ()
@property (nonatomic, strong) UILabel * phonePrefixLabel;
@property (nonatomic, strong) UIView * phoneSeperator;
@property (nonatomic, strong) UITextField * phoneField;

@property (nonatomic, strong) UIImageView * passwordIcon;
@property (nonatomic, strong) UIView * passwordSeperator;
@property (nonatomic, strong) UITextField * passwordField;

@property (nonatomic, strong) UIButton * registerButton;

@property (nonatomic, strong) UIButton * hasAccountButton;
@property (nonatomic, strong) UIButton * findPasswordButton;
@property (nonatomic, strong) UIView * hasAccountUnderline;
@property (nonatomic, strong) UIView * findPasswordUnderline;

@property (nonatomic, strong) ThirdPartyLoginButton * qqLoginButton;
@property (nonatomic, strong) ThirdPartyLoginButton * weixinLoginButton;
@property (nonatomic, strong) ThirdPartyLoginButton * weiboLoginButton;

@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, strong) UILabel * bottomLabel;

@end


@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.phonePrefixLabel = [[UILabel alloc] init];
    self.phonePrefixLabel.textColor = kCEETextGrayColor;
    self.phonePrefixLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.phonePrefixLabel.text = @"+86";
    
    self.phoneSeperator = [[UIView alloc] init];
    self.phoneSeperator.backgroundColor = kCEETextGrayColor;
    
    self.phoneField = [[UITextField alloc] init];
    self.phoneField.attributedPlaceholder
        = [[NSAttributedString alloc]
           initWithString:@"手机号"
               attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                            NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    self.phoneField.textColor = kCEETextBlackColor;
    self.phoneField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    
    self.passwordIcon = [[UIImageView alloc] init];
    
    self.passwordSeperator = [[UIView alloc] init];
    self.passwordSeperator.backgroundColor = kCEETextGrayColor;
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.attributedPlaceholder
        =  [[NSAttributedString alloc]
            initWithString:@"密码"
            attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                         NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    self.passwordField.textColor = kCEETextBlackColor;
    self.passwordField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.backgroundColor = kCEEThemeYellowColor;
    self.registerButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    [self.registerButton addTarget:self action:@selector(registerPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.hasAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString * attributedHasAccount
        = [[NSAttributedString alloc] initWithString:@"已有账户"
                                          attributes:@{NSForegroundColorAttributeName: kCEETextBlackColor,
                                                       NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:11],
                                                       /*NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)*/
                                                       }];
    [self.hasAccountButton setAttributedTitle:attributedHasAccount forState:UIControlStateNormal];
    
    self.findPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString * attributedFindPassword
    = [[NSAttributedString alloc] initWithString:@"找回密码"
                                      attributes:@{NSForegroundColorAttributeName: kCEETextBlackColor,
                                                   NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:11],
                                                   /*NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)*/
                                                   }];
    [self.findPasswordButton setAttributedTitle:attributedFindPassword forState:UIControlStateNormal];
    
    self.hasAccountUnderline = [[UIView alloc] init];
    self.hasAccountUnderline.backgroundColor = kCEETextBlackColor;
    
    self.findPasswordUnderline = [[UIView alloc] init];
    self.findPasswordUnderline.backgroundColor = kCEETextBlackColor;
    
    self.qqLoginButton = [[ThirdPartyLoginButton alloc] init];
    
    self.weixinLoginButton = [[ThirdPartyLoginButton alloc] init];
    
    self.weiboLoginButton = [[ThirdPartyLoginButton alloc] init];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = kCEETextBlackColor;
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.bottomLabel.textColor = kCEETextBlackColor;
    self.bottomLabel.backgroundColor = [UIColor whiteColor];
    self.bottomLabel.text = @"or";
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.phonePrefixLabel];
    [self.view addSubview:self.phoneSeperator];
    [self.view addSubview:self.phoneField];
    
    [self.view addSubview:self.passwordIcon];
    [self.view addSubview:self.passwordSeperator];
    [self.view addSubview:self.passwordField];
    
    [self.view addSubview:self.registerButton];
    
    [self.view addSubview:self.hasAccountButton];
    [self.view addSubview:self.findPasswordButton];
    
    [self.view addSubview:self.hasAccountUnderline];
    [self.view addSubview:self.findPasswordUnderline];
    
    [self.view addSubview:self.qqLoginButton];
    [self.view addSubview:self.weixinLoginButton];
    [self.view addSubview:self.weiboLoginButton];
    
    [self.view addSubview:self.bottomLine];
    [self.view addSubview:self.bottomLabel];
    
    [self.phonePrefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(165);
        make.left.equalTo(self.view.mas_left).offset(58);
    }];
    
    [self.phonePrefixLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.phoneSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phonePrefixLabel.mas_centerY);
        make.left.equalTo(self.phonePrefixLabel.mas_right).offset(5);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(18);
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phonePrefixLabel.mas_centerY);
        make.left.equalTo(self.phoneSeperator.mas_right).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-58);
    }];
    
    [self.passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(23);
        make.left.equalTo(self.view.mas_left).offset(62);
        make.top.equalTo(self.phonePrefixLabel.mas_bottom).offset(25);
    }];
    
    [self.passwordSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.phoneSeperator.mas_centerX);
        make.centerY.equalTo(self.passwordIcon.mas_centerY);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(18);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passwordIcon.mas_centerY);
        make.left.equalTo(self.passwordSeperator.mas_right).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-58);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(255);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
    }];
    
    [self.hasAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-147);
        make.left.equalTo(self.view.mas_left).offset(59);
        make.height.mas_equalTo(11);
    }];
    
    [self.findPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-147);
        make.right.equalTo(self.view.mas_right).offset(-59);
        make.height.mas_equalTo(11);
    }];
    
    [self.hasAccountUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hasAccountButton.mas_centerX);
        make.width.equalTo(self.hasAccountButton.mas_width);
        make.top.equalTo(self.hasAccountButton.mas_bottom).offset(4);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    [self.findPasswordUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.findPasswordButton.mas_centerX);
        make.width.equalTo(self.findPasswordButton.mas_width);
        make.top.equalTo(self.findPasswordButton.mas_bottom).offset(4);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    [self.weixinLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.weixinLoginButton.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-66);
    }];
    
    [self.qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weixinLoginButton.mas_centerY);
        make.right.equalTo(self.weixinLoginButton.mas_left).offset(-78);
    }];
    
    [self.weiboLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weixinLoginButton.mas_centerY);
        make.left.equalTo(self.weixinLoginButton.mas_right).offset(78);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(30);
        make.bottom.equalTo(self.weixinLoginButton.mas_top).offset(-16);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.bottomLabel.mas_centerY).offset(1);
        make.width.mas_equalTo(236 + 30);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor]
                                                                  size:CGSizeMake(23, 23)]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(backPressed:)];
    
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor]
                                                                  size:CGSizeMake(23, 23)]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(menuPressed:)];
    
    self.passwordIcon.backgroundColor = [UIColor grayColor];
    self.qqLoginButton.iconView.backgroundColor = [UIColor grayColor];
    self.qqLoginButton.titleLabel.text = @"QQ 登录";
    self.weixinLoginButton.iconView.backgroundColor = [UIColor grayColor];
    self.weixinLoginButton.titleLabel.text = @"微信 登录";
    self.weiboLoginButton.iconView.backgroundColor = [UIColor grayColor];
    self.weiboLoginButton.titleLabel.text = @"微博 登录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events Handling

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menuPressed:(id)sender {
    
}

- (void)registerPressed:(id)sender {
    VerificationCodeViewController * vc = [[VerificationCodeViewController alloc] init];
    vc.phoneNumber = @"18898989898";
    [self.navigationController pushViewController:vc animated:YES];
}

@end