//
//  LoginViewController.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import AJWValidator;

#import "LoginViewController.h"
#import "UIImage+Utils.h"
#import "AppearanceConstants.h"
#import "ThirdPartyLoginButton.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UILabel * phonePrefixLabel;
@property (nonatomic, strong) UIView * phoneSeperator;
@property (nonatomic, strong) UITextField * phoneField;

@property (nonatomic, strong) UIImageView * passwordIcon;
@property (nonatomic, strong) UIView * passwordSeperator;
@property (nonatomic, strong) UITextField * passwordField;

@property (nonatomic, strong) UIButton * loginButton;

@property (nonatomic, strong) UIButton * registerButton;
@property (nonatomic, strong) UIButton * findPasswordButton;
@property (nonatomic, strong) UIView * registerUnderline;
@property (nonatomic, strong) UIView * findPasswordUnderline;

@property (nonatomic, strong) ThirdPartyLoginButton * qqLoginButton;
@property (nonatomic, strong) ThirdPartyLoginButton * weixinLoginButton;
@property (nonatomic, strong) ThirdPartyLoginButton * weiboLoginButton;

@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, strong) UILabel * bottomLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupContentScrollView];
    [self setupPhoneViews];
    [self setupPasswordViews];
    [self setupLoginButton];
    [self setupRegisterButton];
    [self setupFindPasswordButton];
    [self setupThirdpartyLoginButtons];
    [self setupBottomLine];
    [self setupNavigationItems];

    [self setupLayout];
    
    self.passwordIcon.backgroundColor = [UIColor grayColor];
    self.qqLoginButton.iconView.backgroundColor = [UIColor grayColor];
    self.weixinLoginButton.iconView.backgroundColor = [UIColor grayColor];
    self.weiboLoginButton.iconView.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events Handling

- (void)backPressed:(id)sender {
    
}

- (void)menuPressed:(id)sender {
    
}

- (void)registerPressed:(id)sender {
    [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
}

- (void)loginPressed:(id)sender {
    
}

#pragma mark - Layout

- (void)setupContentScrollView {
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.alwaysBounceVertical = YES;
    
    self.contentView = [[UIView alloc] init];
    
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.contentView];
}

- (void)setupPhoneViews {
    self.phonePrefixLabel = [[UILabel alloc] init];
    self.phonePrefixLabel.textColor = kCEETextGrayColor;
    self.phonePrefixLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.phonePrefixLabel.text = @"+86";
    
    self.phoneSeperator = [[UIView alloc] init];
    self.phoneSeperator.backgroundColor = kCEETextGrayColor;
    
    self.phoneField = [[UITextField alloc] init];
    self.phoneField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.phoneField.attributedPlaceholder =
    [[NSAttributedString alloc]
       initWithString:@"手机号"
       attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                    NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    self.phoneField.textColor = kCEETextBlackColor;
    self.phoneField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    
    [self.contentView addSubview:self.phonePrefixLabel];
    [self.contentView addSubview:self.phoneSeperator];
    [self.contentView addSubview:self.phoneField];
}

- (void)setupPasswordViews {
    self.passwordIcon = [[UIImageView alloc] init];
    
    self.passwordSeperator = [[UIView alloc] init];
    self.passwordSeperator.backgroundColor = kCEETextGrayColor;
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.attributedPlaceholder =
    [[NSAttributedString alloc]
        initWithString:@"密码"
        attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                     NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    self.passwordField.textColor = kCEETextBlackColor;
    self.passwordField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    
    [self.contentView addSubview:self.passwordIcon];
    [self.contentView addSubview:self.passwordSeperator];
    [self.contentView addSubview:self.passwordField];
}

- (void)setupLoginButton {
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = kCEEThemeYellowColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    
    [self.loginButton addTarget:self
                         action:@selector(loginPressed:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.loginButton];
}

- (void)setupRegisterButton {
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString * attributedRegister
    = [[NSAttributedString alloc] initWithString:@"注册账户"
                                      attributes:@{NSForegroundColorAttributeName: kCEETextBlackColor,
                                                   NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:11],
                                                   /*NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)*/
                                                   }];
    [self.registerButton setAttributedTitle:attributedRegister forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerUnderline = [[UIView alloc] init];
    self.registerUnderline.backgroundColor = kCEETextBlackColor;
    
    [self.contentView addSubview:self.registerButton];
    [self.contentView addSubview:self.registerUnderline];
}

- (void)setupFindPasswordButton {
    self.findPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString * attributedFindPassword
    = [[NSAttributedString alloc] initWithString:@"找回密码"
                                      attributes:@{NSForegroundColorAttributeName: kCEETextBlackColor,
                                                   NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:11],
                                                   /*NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)*/
                                                   }];
    [self.findPasswordButton setAttributedTitle:attributedFindPassword forState:UIControlStateNormal];
    
    self.findPasswordUnderline = [[UIView alloc] init];
    self.findPasswordUnderline.backgroundColor = kCEETextBlackColor;
    
    [self.contentView addSubview:self.findPasswordButton];
    [self.contentView addSubview:self.findPasswordUnderline];
}

- (void)setupThirdpartyLoginButtons {
    self.qqLoginButton = [[ThirdPartyLoginButton alloc] init];
    self.qqLoginButton.titleLabel.text = @"QQ 登录";
    
    self.weixinLoginButton = [[ThirdPartyLoginButton alloc] init];
    self.weixinLoginButton.titleLabel.text = @"微信 登录";
    
    self.weiboLoginButton = [[ThirdPartyLoginButton alloc] init];
    self.weiboLoginButton.titleLabel.text = @"微博 登录";
    
    [self.contentView addSubview:self.qqLoginButton];
    [self.contentView addSubview:self.weixinLoginButton];
    [self.contentView addSubview:self.weiboLoginButton];
    
}

- (void)setupBottomLine {
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = kCEETextBlackColor;
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.bottomLabel.textColor = kCEETextBlackColor;
    self.bottomLabel.backgroundColor = [UIColor whiteColor];
    self.bottomLabel.text = @"or";
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.bottomLabel];
}

- (void)setupLayout {
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
    }];
    
    [self.phonePrefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(165);
        make.left.equalTo(self.contentView.mas_left).offset(58);
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
        make.right.equalTo(self.contentView.mas_right).offset(-58);
    }];
    
    [self.passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(23);
        make.left.equalTo(self.contentView.mas_left).offset(62);
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
        make.right.equalTo(self.contentView.mas_right).offset(-58);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(255);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-147);
        make.left.equalTo(self.contentView.mas_left).offset(59);
        make.height.mas_equalTo(11);
    }];
    
    [self.findPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-147);
        make.right.equalTo(self.contentView.mas_right).offset(-59);
        make.height.mas_equalTo(11);
    }];
    
    [self.registerUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.registerButton.mas_centerX);
        make.width.equalTo(self.registerButton.mas_width);
        make.top.equalTo(self.registerButton.mas_bottom).offset(4);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    [self.findPasswordUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.findPasswordButton.mas_centerX);
        make.width.equalTo(self.findPasswordButton.mas_width);
        make.top.equalTo(self.findPasswordButton.mas_bottom).offset(4);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    [self.weixinLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.weixinLoginButton.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-66);
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
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(30);
        make.bottom.equalTo(self.weixinLoginButton.mas_top).offset(-16);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.bottomLabel.mas_centerY).offset(1);
        make.width.mas_equalTo(236 + 30);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
 
}

- (void)setupNavigationItems {
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
}

@end
