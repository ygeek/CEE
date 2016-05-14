//
//  HUDGetMedalViewController.m
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDGetMedalViewController.h"
#import "AppearanceConstants.h"
#import "CEENotificationNames.h"
#import "CEEAward.h"
#import "UIImage+Utils.h"
#import "UIImageView+Utils.h"

@interface HUDGetMedalViewController ()
@property (nonatomic, strong) UIView * panelView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UIImageView * backgroundView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIButton * confirmButton;
@end

@implementation HUDGetMedalViewController

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
    
    self.backgroundView = [[UIImageView alloc] init];
    [self.panelView addSubview:self.backgroundView];
    
    self.iconView = [[UIImageView alloc] init];
    [self.panelView addSubview:self.iconView];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    self.messageLabel.textColor = kCEETextYellowColor;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.text = @"获得新徽章！";
    [self.panelView addSubview:self.messageLabel];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = [UIColor whiteColor];
    [self.confirmButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:self.confirmButton];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    [self.view addSubview:self.panelView];
    
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(232);
        make.height.mas_equalTo(251 + 48);
        make.center.equalTo(self.view);
    }];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panelView.mas_top);
        make.left.equalTo(self.panelView.mas_left);
        make.right.equalTo(self.panelView.mas_right);
        make.height.mas_equalTo(251);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panelView.mas_centerX);
        make.top.equalTo(self.panelView.mas_top).offset(63);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(95);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panelView.mas_centerX);
        make.top.equalTo(self.iconView.mas_bottom).offset(18);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panelView.mas_left);
        make.right.equalTo(self.panelView.mas_right);
        make.bottom.equalTo(self.panelView.mas_bottom);
        make.height.mas_equalTo(48);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEHUDDismissNotificationName
                                                        object:self
                                                      userInfo:@{kCEEHUDKey: self}];
}

- (void)loadAward:(CEEJSONAward *)award {
    if ([award.type isEqualToString:@"medal"]) {
        // TODO: 换正式的占位图
        self.backgroundView.image = [UIImage imageWithColor:kCEEYellowColor size:CGSizeMake(232, 251)];
        [self.iconView cee_setImageWithKey:award.detail[@"icon_key"]];
    }
}

@end
