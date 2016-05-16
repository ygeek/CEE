//
//  LoginViewController.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import AJWValidator;
@import SVProgressHUD;
@import ReactiveCocoa;

#import <SMS_SDK/SMSSDK.h>

#import "RegisterViewController.h"
#import "UIImage+Utils.h"
#import "AppearanceConstants.h"
#import "ThirdPartyLoginButton.h"
#import "VerificationCodeViewController.h"
#import "CEEUserSession.h"
#import "CEEDatabase.h"
#import "CEEUtils.h"
#import "UtilsMacros.h"


@interface RegisterViewController ()

@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UILabel * phonePrefixLabel;
@property (nonatomic, strong) UIView * phoneSeperator;
@property (nonatomic, strong) UITextField * phoneField;
@property (nonatomic, strong) AJWValidator * phoneValidator;

@property (nonatomic, strong) UIImageView * passwordIcon;
@property (nonatomic, strong) UIView * passwordSeperator;
@property (nonatomic, strong) UITextField * passwordField;
@property (nonatomic, strong) AJWValidator * passwordValidator;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupContentScrollView];
    [self setupPhone];
    [self setupPassword];
    [self setupRegisterButton];
    [self setupHasAccountButton];
    [self setupHasAccountButton];
    [self setupFindPasswordButton];
    [self setupThirdPartyLoginButtons];
    [self setupBottomLine];
    [self setupLayout];
    [self setupNavigationItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events Handling

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerPressed:(id)sender {
    [self.phoneValidator validate:self.phoneField.text];
    if (self.phoneValidator.state != AJWValidatorValidationStateValid) {
        [SVProgressHUD showErrorWithStatus:[self.phoneValidator.errorMessages componentsJoinedByString:@"\n"]];
        return;
    }
    
    [self.passwordValidator validate:self.passwordField.text];
    if (self.passwordValidator.state != AJWValidatorValidationStateValid) {
        [SVProgressHUD showErrorWithStatus:[self.passwordValidator.errorMessages componentsJoinedByString:@"\n"]];
        return;
    }
    
    [SVProgressHUD show];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneField.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:
     ^(NSError *error) {
         if (!error) {
             [SVProgressHUD dismiss];
             VerificationCodeViewController * vc = [[VerificationCodeViewController alloc] init];
             vc.phoneNumber = self.phoneField.text;
             vc.password = self.passwordField.text;
             [self.navigationController pushViewController:vc animated:YES];
         } else {
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }
    }];
}

- (void)hasAccountPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSUInteger animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationCurve|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGFloat keyboardHeight = [UIScreen mainScreen].bounds.size.height - endFrame.origin.y;
                         self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
                     }
                     completion:nil];
    
    if (self.phoneField.isFirstResponder) {
        [self.contentScrollView scrollRectToVisible:self.phoneField.frame animated:YES];
    }
    
    if (self.passwordField.isFirstResponder) {
        [self.contentScrollView scrollRectToVisible:self.passwordField.frame animated:YES];
    }
}

#pragma mark - Setup Layout

- (void)setupContentScrollView {
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    
    self.contentView = [[UIView alloc] init];
    
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.contentView];
}

- (void)setupPhone {
    self.phonePrefixLabel = [[UILabel alloc] init];
    self.phonePrefixLabel.textColor = kCEETextGrayColor;
    self.phonePrefixLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.phonePrefixLabel.text = @"+86";
    
    self.phoneSeperator = [[UIView alloc] init];
    self.phoneSeperator.backgroundColor = kCEETextGrayColor;
    
    self.phoneField = [[UITextField alloc] init];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.attributedPlaceholder
    = [[NSAttributedString alloc]
       initWithString:@"手机号"
       attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                    NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    self.phoneField.textColor = kCEETextBlackColor;
    self.phoneField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    
    [self.contentView addSubview:self.phonePrefixLabel];
    [self.contentView addSubview:self.phoneSeperator];
    [self.contentView addSubview:self.phoneField];
    
    self.phoneValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
    [self.phoneValidator addValidationToEnsureRegularExpressionIsMetWithPattern:kPhoneNumberRegex
                                                                 invalidMessage:@"手机号码格式有误"];
}

- (void)setupPassword {
    self.passwordIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码"]];
    self.passwordIcon.contentMode = UIViewContentModeCenter;
    
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
    
    [self.contentView addSubview:self.passwordIcon];
    [self.contentView addSubview:self.passwordSeperator];
    [self.contentView addSubview:self.passwordField];
    
    self.passwordValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
    [self.passwordValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString * password) {
        return [CEEUtils isValidPassword:password];
    } invalidMessage:@"密码格式有误，需要同时包含数字、大写和小写字母"];
}

- (void)setupRegisterButton {
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.backgroundColor = kCEEThemeYellowColor;
    self.registerButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    [self.registerButton addTarget:self action:@selector(registerPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.registerButton];
}

- (void)setupHasAccountButton {
    self.hasAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString * attributedHasAccount
    = [[NSAttributedString alloc] initWithString:@"已有账户"
                                      attributes:@{NSForegroundColorAttributeName: kCEETextBlackColor,
                                                   NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:11],
                                                   /*NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)*/
                                                   }];
    [self.hasAccountButton setAttributedTitle:attributedHasAccount forState:UIControlStateNormal];
    [self.hasAccountButton addTarget:self action:@selector(hasAccountPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.hasAccountUnderline = [[UIView alloc] init];
    self.hasAccountUnderline.backgroundColor = kCEETextBlackColor;
    
    [self.contentView addSubview:self.hasAccountButton];
    [self.contentView addSubview:self.hasAccountUnderline];
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

- (void)setupThirdPartyLoginButtons {
    self.qqLoginButton = [[ThirdPartyLoginButton alloc] init];
    self.qqLoginButton.iconView.image = [UIImage imageNamed:@"qq"];
    self.qqLoginButton.titleLabel.text = @"QQ 登录";
    
    self.weixinLoginButton = [[ThirdPartyLoginButton alloc] init];
    self.weixinLoginButton.iconView.image = [UIImage imageNamed:@"微信"];
    self.weixinLoginButton.titleLabel.text = @"微信 登录";
    
    self.weiboLoginButton = [[ThirdPartyLoginButton alloc] init];
    self.weiboLoginButton.iconView.image = [UIImage imageNamed:@"微博"];
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
        make.right.equalTo(self.contentView.mas_right).offset(-58);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(255);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
    }];
    
    [self.hasAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-147);
        make.left.equalTo(self.contentView.mas_left).offset(59);
        make.height.mas_equalTo(11);
    }];
    
    [self.findPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-147);
        make.right.equalTo(self.contentView.mas_right).offset(-59);
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
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backPressed:)];
    
    /*
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"个人主页"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(menuPressed:)];
     */
}

@end
