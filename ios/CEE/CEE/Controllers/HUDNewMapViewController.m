//
//  HUDNewMapViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDNewMapViewController.h"
#import "AppearanceConstants.h"
#import "CEEMap.h"
#import "UIImageView+Utils.h"

@interface HUDNewMapViewController ()
@property (nonatomic, strong) UIView * panelView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * mapLabel;
@property (nonatomic, strong) UIImageView * backgroundView;
@property (nonatomic, strong) UILabel * messageLabel;
@end


@implementation HUDNewMapViewController

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
    self.backgroundView.clipsToBounds = YES;
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.panelView addSubview:self.backgroundView];
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeCenter;
    [self.panelView addSubview:self.iconView];
    
    self.mapLabel = [[UILabel alloc] init];
    self.mapLabel.font = [UIFont fontWithName:kCEEFontNameBold size:18];
    self.mapLabel.textColor = [UIColor whiteColor];
    self.mapLabel.textAlignment = NSTextAlignmentCenter;
    [self.panelView addSubview:self.mapLabel];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.messageLabel.textColor = kCEETextBlackColor;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.text = @"获得新地图！";
    [self.panelView addSubview:self.messageLabel];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panelView.mas_top);
        make.left.equalTo(self.panelView.mas_left);
        make.right.equalTo(self.panelView.mas_right);
        make.height.mas_equalTo(251);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panelView.mas_centerX);
        make.top.equalTo(self.panelView.mas_top).offset(68);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(64);
    }];
    
    [self.mapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panelView.mas_centerX);
        make.top.equalTo(self.iconView.mas_bottom).offset(30);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_bottom);
        make.bottom.equalTo(self.panelView.mas_bottom);
        make.left.equalTo(self.panelView.mas_left);
        make.right.equalTo(self.panelView.mas_right);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self.view addSubview:self.panelView];
    
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(232);
        make.height.mas_equalTo(251 + 48);
        make.center.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backgroundTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadMap:(CEEJSONMap *)map {
    [self.backgroundView cee_setImageWithKey:map.summary_image_key];
    [self.iconView cee_setImageWithKey:map.icon_key];
    self.mapLabel.text = map.name;
}

@end
