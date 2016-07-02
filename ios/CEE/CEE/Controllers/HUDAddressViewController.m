//
//  HUDAddressViewController.m
//  CEE
//
//  Created by Meng on 16/7/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDAddressViewController.h"
#import "AppearanceConstants.h"
#import "CEETask.h"
#import "CEENotificationNames.h"

@interface HUDAddressViewController ()
@property (nonatomic, strong) UIImageView * panelView;
@property (nonatomic, strong) UILabel * address;
@property (nonatomic, strong) UILabel * detail;
@property (nonatomic, strong) UILabel * phone;
@property (nonatomic, strong) UIButton * confirmButton;
@end

@implementation HUDAddressViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    
    self.panelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"地址框"]];
    self.panelView.userInteractionEnabled = YES;
    [self.view addSubview:self.panelView];
    
    self.address = [[UILabel alloc] init];
    self.address.font = [UIFont fontWithName:kCEEFontNameRegular size:21];
    self.address.textColor = kCEETextBlackColor;
    [self.panelView addSubview:self.address];
    
    self.detail = [[UILabel alloc] init];
    self.detail.numberOfLines = 5;
    self.detail.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.detail.textColor = kCEETextBlackColor;
    [self.panelView addSubview:self.detail];
    
    self.phone = [[UILabel alloc] init];
    self.phone.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.phone.textColor = kCEETextBlackColor;
    [self.panelView addSubview:self.phone];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.userInteractionEnabled = YES;
    // self.confirmButton.backgroundColor = [UIColor clearColor];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    [self.confirmButton addTarget:self
                           action:@selector(confirmPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:self.confirmButton];
    
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(345);
        make.height.mas_equalTo(102);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panelView.mas_left).offset(20);
        make.top.equalTo(self.panelView.mas_top).offset(10);
        make.right.equalTo(self.confirmButton.mas_left).offset(-20);
    }];
    
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.address.mas_bottom);
        make.left.equalTo(self.panelView.mas_left).offset(20);
        make.right.equalTo(self.confirmButton.mas_left).offset(-20);
    }];
    
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panelView.mas_left).offset(20);
        make.right.equalTo(self.confirmButton.mas_left).offset(-20);
        make.bottom.equalTo(self.panelView.mas_bottom).offset(-10);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(66);
        make.right.equalTo(self.panelView.mas_right);
        make.top.equalTo(self.panelView.mas_top).offset(4);
        make.bottom.equalTo(self.panelView.mas_bottom).offset(-4);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadTask:(CEEJSONTask *)task {
    self.address.text = task.location;
    self.detail.text = task.detail_location;
    self.phone.text = task.phone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
