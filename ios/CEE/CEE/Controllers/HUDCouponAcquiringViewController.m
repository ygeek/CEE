//
//  CouponAcquiringViewController.m
//  CEE
//
//  Created by Meng on 16/4/28.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDCouponAcquiringViewController.h"
#import "CouponCard.h"
#import "AppearanceConstants.h"
#import "CEENotificationNames.h"


@interface HUDCouponAcquiringViewController ()
@property (nonatomic, strong) CouponCard * couponCard;
@property (nonatomic, strong) UIButton * confirmButton;
@end


@implementation HUDCouponAcquiringViewController

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
    self.couponCard.codeButton.hidden = YES;
    [self.view addSubview:self.couponCard];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = 10 * verticalScale();
    self.confirmButton.backgroundColor = [UIColor whiteColor];
    [self.confirmButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:16];
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.couponCard.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                         CGRectGetMidY(self.view.bounds) - 30);
    
    self.couponCard.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                       verticalScale(),
                                                       verticalScale());
    
    self.confirmButton.frame = CGRectMake(0,
                                          0,
                                          120 * verticalScale(),
                                          44 * verticalScale());
    
    self.confirmButton.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                            CGRectGetMaxY(self.couponCard.frame) + 14 + 44 * verticalScale() / 2);
}

- (void)confirmPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEHUDDismissNotificationName
                                                        object:self
                                                      userInfo:@{kCEEHUDKey: self}];
}

- (void)loadCoupon:(CEEJSONCoupon *)coupon {
    [self.couponCard loadCoupon:coupon];
}

@end
