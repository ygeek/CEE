//
//  SettingViewController.m
//  CEE
//
//  Created by Meng on 16/5/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import SDWebImage;
@import Masonry;
@import SVProgressHUD;

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "IntroViewController.h"
#import "AppearanceConstants.h"
#import "CEEUserSession.h"


@interface SettingCell : UIControl
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * nextArrow;
@end


@implementation SettingCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.titleLabel.textColor = kCEETextBlackColor;
    self.nextArrow = [[UIImageView alloc] init];
    self.nextArrow.image = [UIImage imageNamed:@"下一步"];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nextArrow];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(46);
    }];
    
    [self.nextArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_offset(23);
        make.height.mas_offset(23);
        make.right.equalTo(self.mas_right).offset(-11);
    }];
}

@end



@interface ClearCacheCell : UIControl
@property (nonatomic, strong) UILabel * clearCacheLabel;
@property (nonatomic, strong) UILabel * cacheSizeLabel;
@end


@implementation ClearCacheCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    self.clearCacheLabel = [[UILabel alloc] init];
    self.clearCacheLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.clearCacheLabel.textColor = kCEETextBlackColor;
    self.clearCacheLabel.text = @"清除缓存";
    self.cacheSizeLabel = [[UILabel alloc] init];
    self.cacheSizeLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.cacheSizeLabel.textColor = kCEETextBlackColor;
    
    [self addSubview:self.clearCacheLabel];
    [self addSubview:self.cacheSizeLabel];
    
    [self.clearCacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(46);
    }];
    
    [self.cacheSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-22);
    }];
}

@end



@interface SettingViewController ()
@property (nonatomic, strong) UIImageView * titleView;
@property (nonatomic, strong) SettingCell * aboutCell;
@property (nonatomic, strong) SettingCell * introCell;
@property (nonatomic, strong) SettingCell * feedbackCell;
@property (nonatomic, strong) SettingCell * supportCell;
@property (nonatomic, strong) SettingCell * recommendCell;

@property (nonatomic, strong) ClearCacheCell * clearCacheCell;

@property (nonatomic, strong) UIButton * logoutButton;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kCEECircleGrayColor;
    
    self.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人设置页大齿轮"]];
    self.titleView.frame = CGRectMake(0, 0, self.titleView.image.size.width, self.titleView.image.size.height);
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backPressed:)];
   
    self.navigationItem.titleView = self.titleView;
    
    self.aboutCell = [[SettingCell alloc] init];
    self.aboutCell.titleLabel.text = @"关于我们";
    [self.aboutCell addTarget:self
                       action:@selector(aboutPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.aboutCell];
    
    self.introCell = [[SettingCell alloc] init];
    self.introCell.titleLabel.text = @"intro";
    [self.introCell addTarget:self
                       action:@selector(introPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.introCell];
    
    self.feedbackCell = [[SettingCell alloc] init];
    self.feedbackCell.titleLabel.text = @"意见反馈";
    [self.view addSubview:self.feedbackCell];
    
    self.supportCell = [[SettingCell alloc] init];
    self.supportCell.titleLabel.text = @"给予支持";
    [self.view addSubview:self.supportCell];
    
    self.recommendCell = [[SettingCell alloc] init];
    self.recommendCell.titleLabel.text = @"推荐给朋友";
    [self.view addSubview:self.recommendCell];
    
    self.clearCacheCell = [[ClearCacheCell alloc] init];
    self.clearCacheCell.cacheSizeLabel.text = [NSString stringWithFormat:@"%.2fMB", [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0];
    [self.clearCacheCell addTarget:self action:@selector(clearCachePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearCacheCell];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.backgroundColor = [UIColor whiteColor];
    [self.logoutButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutButton];
    
    
    [self.aboutCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(36);
    }];
    
    [self.introCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aboutCell.mas_bottom).offset(9);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(36);
    }];
    
    [self.feedbackCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introCell.mas_bottom).offset(9);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(36);
    }];
    
    [self.supportCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackCell.mas_bottom).offset(9);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(36);
    }];
    
    [self.recommendCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supportCell.mas_bottom).offset(9);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(36);
    }];
    
    [self.clearCacheCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendCell.mas_bottom).offset(9);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(36);
    }];
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clearCacheCell.mas_bottom).offset(54);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(36);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearCachePressed:(id)sender {
    [SVProgressHUD show];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        self.clearCacheCell.cacheSizeLabel.text = [NSString stringWithFormat:@"%.2fMB", [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0];
        [SVProgressHUD showSuccessWithStatus:@"成功清除缓存！"];
    }];
}

- (void)logoutPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[CEEUserSession session] onUnauthorized];
    }];
}

- (void)aboutPressed:(id)sender {
    AboutViewController * aboutVC = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)introPressed:(id)sender {
    IntroViewController * introVC = [[IntroViewController alloc] init];
    [self presentViewController:introVC animated:YES completion:nil];
}

- (void)feedbackPressed:(id)sender {
    
}

- (void)supportPressed:(id)sender {
    
}

- (void)recommendPressed:(id)sender {
    
}

@end
