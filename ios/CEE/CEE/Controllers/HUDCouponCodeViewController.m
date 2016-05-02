//
//  HUDCouponCodeViewController.m
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import SVProgressHUD;


#import "HUDCouponCodeViewController.h"
#import "HUDCouponCodeView.h"
#import "CEECouponConsumeAPI.h"


@interface HUDCouponCodeViewController () <HUDCouponCodeViewDelegate>
@property (nonatomic, strong) HUDCouponCodeView * codeView;
@end

@implementation HUDCouponCodeViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.codeView = [[HUDCouponCodeView alloc] init];
    self.codeView.delegate = self;
    [self.view addSubview:self.codeView];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(230);
        make.height.mas_equalTo(52);
        make.center.equalTo(self.view);
    }];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.codeView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.codeView resignFirstResponder];
}

- (void)backgroundTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)couponCodeChanged:(NSString *)code {
    if (code.length < 4) {
        return;
    }
    [SVProgressHUD showWithStatus:@"正在验证"];
    [[CEECouponConsumeAPI api] consumeUUID:self.couponUUID withCode:code].then(^(NSString * msg){
        [SVProgressHUD dismiss];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"消费成功"
                                                                        message:msg
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.delegate couponCodeVerified:self];
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
    }).catch(^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    });
}

@end
