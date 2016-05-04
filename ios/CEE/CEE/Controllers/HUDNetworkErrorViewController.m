//
//  HUDNetworkErrorViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDNetworkErrorViewController.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"

@interface HUDNetworkErrorViewController ()
@property (nonatomic, strong) UIView * panelView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * messageLabel;
@end

@implementation HUDNetworkErrorViewController

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
    
    self.panelView = [[UIView alloc] init];
    self.panelView.backgroundColor = [UIColor whiteColor];
    self.panelView.layer.cornerRadius = 10;
    self.panelView.layer.masksToBounds = YES;
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeCenter;
    [self.panelView addSubview:self.iconView];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:10];
    self.messageLabel.textColor = hexColor(0x8c8c8c);
    self.messageLabel.numberOfLines = 2;
    self.messageLabel.text = @"嗯 它掉线了 不要大惊小怪\n点击设置网络吧！";
    [self.panelView addSubview:self.messageLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panelView.mas_top).offset(60);
        make.centerX.equalTo(self.panelView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(100);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panelView.mas_top).offset(188);
        make.centerX.equalTo(self.panelView.mas_centerX);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [self.view addSubview:self.panelView];
    
    UITapGestureRecognizer * bgTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:bgTapRecognizer];
    
    UITapGestureRecognizer * panelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panelTapped:)];
    [self.panelView addGestureRecognizer:panelTapRecognizer];
    
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(232);
        make.height.mas_equalTo(299);
        make.center.equalTo(self.view);
    }];
    
    self.iconView.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(200, 100)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backgroundTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)panelTapped:(id)sender {
    NSURL * url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
