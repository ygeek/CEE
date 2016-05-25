//
//  FeedbackViewController.m
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import SVProgressHUD;

#import <MailCore/MailCore.h>

#import "FeedbackViewController.h"
#import "AppearanceConstants.h"
#import "CEEUserSession.h"

@interface FeedbackViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView * textView;
@end


@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = kCEECircleGrayColor;
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    self.textView.textColor = kCEETextBlackColor;
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
    self.navigationItem.title = @"意见反馈";
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backPressed:)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(submitPressed:)];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(300);
    }];
}

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitPressed:(id)sender {
    MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.hostname = @"smtp.163.com";
    smtpSession.port = 465;
    smtpSession.username = @"n_ightfade@163.com";
    smtpSession.password = @"87655161";
    smtpSession.authType = MCOAuthTypeSASLNone;
    smtpSession.connectionType = MCOConnectionTypeTLS;
    
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    MCOAddress *from = [MCOAddress addressWithDisplayName:[CEEUserSession session].userProfile.username
                                                  mailbox:@"n_ightfade@163.com"];
    MCOAddress *to = [MCOAddress addressWithDisplayName:nil
                                                mailbox:@"nightfade@163.com"];//@"weidaiwei@pintag.cn"];
    [[builder header] setFrom:from];
    [[builder header] setTo:@[to]];
    [[builder header] setSubject:@"用户反馈"];
    [builder setHTMLBody:self.textView.text];
    NSData * rfc822Data = [builder data];
    
    MCOSMTPSendOperation *sendOperation =
    [smtpSession sendOperationWithData:rfc822Data];
    
    [SVProgressHUD show];
    [sendOperation start:^(NSError *error) {
        if(error) {
            NSLog(@"Error sending email: %@", error);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else {
            NSLog(@"Successfully sent email!");
            [SVProgressHUD showInfoWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

@end
