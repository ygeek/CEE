//
//  CouponAcquiringViewController.m
//  CEE
//
//  Created by Meng on 16/4/28.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "CouponAcquiringViewController.h"
#import "CouponCard.h"
#import "AppearanceConstants.h"


@interface CouponAcquiringViewController ()
@property (nonatomic, strong) CouponCard * couponCard;
@property (nonatomic, strong) UIButton * confirmButton;
@end


@implementation CouponAcquiringViewController

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
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.couponCard = [[CouponCard alloc] init];
    [self.view addSubview:self.couponCard];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = 10;
    self.confirmButton.backgroundColor = [UIColor whiteColor];
    [self.confirmButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:16];
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
    [self.couponCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view).centerOffset(CGPointMake(0, -30));
        make.width.mas_equalTo(334);
        make.height.mas_equalTo(212);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponCard.mas_bottom).offset(14);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.couponCard.shadowView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
