//
//  VerificationCodeViewController.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import ReactiveCocoa;
@import SVProgressHUD;

#import <SMS_SDK/SMSSDK.h>

#import "VerificationCodeViewController.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"
#import "CEERegisterAPI.h"
#import "CEEFetchUserProfileAPI.h"
#import "CEEUserSession.h"

@interface VerificationCodeViewController ()
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UITextField * codeField;
@property (nonatomic, strong) UIView * codeUnderline;
@property (nonatomic, strong) UIButton * requireCodeButton;
@property (nonatomic, strong) UIButton * nextButton;
@property (nonatomic, strong) UIButton * switchButton;
@property (nonatomic, strong) UIView * switchUnderline;
@property (nonatomic, assign) BOOL isCodeSent;

@property (nonatomic, assign) NSInteger countdown;
@property (nonatomic, strong) NSTimer * countdownTimer;
@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isCodeSent = NO;
    
    [self setupContentScrollView];
    [self setupMessageLabel];
    [self setupNextButton];
    [self setupCodeField];
    //[self setupSwitchButton];
    [self setupLayout];
   
    self.navigationItem.leftBarButtonItem
        = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(backPressed:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [RACObserve(self, isCodeSent) subscribeNext:^(NSNumber * isSent) {
        self.messageLabel.attributedText = [self genMessageText];
    }];
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

- (NSAttributedString *)genMessageText {
    NSString * str = self.isCodeSent ? @"我们已发送验证短信到 " : @"准备发送验证码到 ";
    NSMutableAttributedString * message
        = [[NSMutableAttributedString alloc] initWithString:str
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

- (void)requireCodePressed:(id)sender {
    [SVProgressHUD show];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.phoneNumber
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
             self.isCodeSent = YES;
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

- (void)nextPressed:(id)sender {
    [SVProgressHUD show];
    [SMSSDK commitVerificationCode:self.codeField.text
                       phoneNumber:self.phoneNumber
                              zone:@"86"
                            result:
    ^(NSError *error) {
        if (!error) {
            [[[CEERegisterAPI alloc] init] registerWithMobile:self.phoneNumber password:self.password]
            .then(^(NSString * authToken) {
                return [[CEEUserSession session] loggedInWithAuth:authToken username:self.phoneNumber platform:kCEEPlatformMobile];
            }).then(^{
                [SVProgressHUD dismiss];
            }).catch(^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:@"验证失败，再试一次吧！"];
        }
    }];
}

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
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
    
    if (self.codeField.isFirstResponder) {
        [self.contentScrollView scrollRectToVisible:self.codeField.frame animated:YES];
    }
}

#pragma mark - Setup Layout

- (void)setupContentScrollView {
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    
    self.contentView = [[UIView alloc] init];
    
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.contentView];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.contentView addGestureRecognizer:tapRecognizer];
}

- (void)setupMessageLabel {
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.attributedText = [self genMessageText];
    
    [self.contentView addSubview:self.messageLabel];
}

- (void)setupNextButton {
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.backgroundColor = kCEETextYellowColor;
    self.nextButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    [self.nextButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton addTarget:self
                        action:@selector(nextPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.nextButton];
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

- (void)setupSwitchButton {
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    [self.switchButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.switchButton setTitle:@"更换获取验证方式" forState:UIControlStateNormal];
    
    self.switchUnderline = [[UIView alloc] init];
    self.switchUnderline.backgroundColor = kCEETextBlackColor;
    
    [self.contentView addSubview:self.switchButton];
    [self.contentView addSubview:self.switchUnderline];
}

- (void)setupLayout {
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_height);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(146);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).offset(42 + 37 + 15);
        make.centerX.equalTo(self.contentView.mas_centerX);
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
    
    /*
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-108);
        make.height.mas_equalTo(12);
    }];
    
    [self.switchUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.switchButton.mas_left);
        make.right.equalTo(self.switchButton.mas_right);
        make.top.equalTo(self.switchButton.mas_bottom).offset(4);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
     */
}

@end
