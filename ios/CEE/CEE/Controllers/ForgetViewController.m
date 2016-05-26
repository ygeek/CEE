//
//  ForgetViewController.m
//  CEE
//
//  Created by Meng on 16/5/26.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import AJWValidator;
@import Masonry;
@import SVProgressHUD;

#import <SMS_SDK/SMSSDK.h>

#import "ForgetViewController.h"
#import "VerificationCodeViewController.h"
#import "AppearanceConstants.h"
#import "CEEUserSession.h"
#import "CEEDatabase.h"
#import "CEEUtils.h"
#import "UtilsMacros.h"
#import "CEEResetPasswordAPI.h"

@interface ForgetViewController ()
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

@property (nonatomic, strong) UITextField * codeField;
@property (nonatomic, strong) UIView * codeUnderline;
@property (nonatomic, strong) UIButton * requireCodeButton;
@property (nonatomic, assign) NSInteger countdown;
@property (nonatomic, strong) NSTimer * countdownTimer;


@property (nonatomic, strong) UIButton * resetButton;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupContentScrollView];
    [self setupPhone];
    [self setupPassword];
    [self setupResetButton];
    [self setupCodeField];
    [self setupLayout];
    [self setupNavigationItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

#pragma mark - Events Handling

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetPressed:(id)sender {
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
     [[[CEEResetPasswordAPI alloc] init] resetUsername:self.phoneField.text password:self.passwordField.text code:self.codeField.text]
     .then(^(NSString * authToken) {
         return [[CEEUserSession session] loggedInWithAuth:authToken platform:kCEEPlatformMobile];
     }).then(^{
         [SVProgressHUD dismiss];
     }).catch(^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:error.localizedDescription];
     });
}

- (void)requireCodePressed:(id)sender {
    [SVProgressHUD show];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.phoneField.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:
     ^(NSError *error) {
         if (!error) {
             [SVProgressHUD dismiss];
             
             [self.requireCodeButton setTitle:@"60" forState:UIControlStateDisabled];
             self.requireCodeButton.enabled = NO;
             self.countdown = 60;
             self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                    target:self
                                                                  selector:@selector(timerFired:)
                                                                  userInfo:nil
                                                                   repeats:YES];
         } else {
             [SVProgressHUD showErrorWithStatus:@"发送失败，再试一次吧！"];
         }
     }];
}

- (void)timerFired:(NSTimer *)timer {
    if (self.countdown > 0) {
        self.countdown--;
        [self.requireCodeButton setTitle:@(self.countdown).stringValue forState:UIControlStateDisabled];
    } else {
        self.requireCodeButton.enabled = YES;
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
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

- (void)setupResetButton {
    self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resetButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.resetButton setTitle:@"重设密码" forState:UIControlStateNormal];
    self.resetButton.backgroundColor = kCEEThemeYellowColor;
    self.resetButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    [self.resetButton addTarget:self action:@selector(resetPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.resetButton];
}

- (void)setupCodeField {
    self.requireCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.requireCodeButton.layer.borderColor = kCEETextBlackColor.CGColor;
    self.requireCodeButton.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    self.requireCodeButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    [self.requireCodeButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.requireCodeButton setTitle:@"获取" forState:UIControlStateNormal];
    [self.requireCodeButton addTarget:self
                               action:@selector(requireCodePressed:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    self.codeField = [[UITextField alloc] init];
    self.codeField.attributedPlaceholder
    = [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                      attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                                                   NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    self.codeField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.codeField.textColor = kCEETextBlackColor;
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.codeUnderline = [[UIView alloc] init];
    self.codeUnderline.backgroundColor = kCEETextBlackColor;
    
    [self.contentView addSubview:self.requireCodeButton];
    [self.contentView addSubview:self.codeField];
    [self.contentView addSubview:self.codeUnderline];
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
    
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordIcon.mas_bottom).offset(20);
        make.left.equalTo(self.resetButton.mas_left);
        make.height.equalTo(self.requireCodeButton.mas_height);
        make.right.equalTo(self.requireCodeButton.mas_left).offset(-10);
    }];
    
    [self.codeUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeField.mas_left);
        make.right.equalTo(self.codeField.mas_right);
        make.bottom.equalTo(self.codeField.mas_bottom);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    [self.requireCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordIcon.mas_bottom).offset(20);
        make.right.equalTo(self.resetButton.mas_right);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(37);
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.requireCodeButton.mas_bottom).offset(25);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
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
