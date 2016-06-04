//
//  AboutViewController.m
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import AVFoundation;
@import AVKit;

#import "AboutViewController.h"
#import "AppearanceConstants.h"

@interface AboutViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UILabel * commentLabel;
@property (nonatomic, strong) UIButton * videoButton;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableViewCell * webCell;
@property (nonatomic, strong) UITableViewCell * weixinCell;

@property (nonatomic, strong) UILabel * versionLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kCEECircleGrayColor;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"最有态度的设计点评应用";
    self.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    self.titleLabel.textColor = kCEETextBlackColor;
    [self.view addSubview:self.titleLabel];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = kCEETextBlackColor;
    [self.view addSubview:self.line];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.text = @"追寻更美好的可能";
    self.commentLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.commentLabel.textColor = kCEETextGrayColor;
    [self.view addSubview:self.commentLabel];
    
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.backgroundColor = kCEEBackgroundGrayColor;
    [self.videoButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.videoButton setTitle:@"产品视频" forState:UIControlStateNormal];
    self.videoButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    [self.videoButton addTarget:self action:@selector(videoPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.videoButton];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.webCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    self.webCell.textLabel.text = @"深入了解";
    self.webCell.textLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.webCell.textLabel.textColor = kCEETextLightBlackColor;
    self.webCell.detailTextLabel.text = @"前往官网";
    self.webCell.detailTextLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    self.webCell.detailTextLabel.textColor = kCEETextLightBlackColor;
    
    self.weixinCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    self.weixinCell.textLabel.text = @"关注微信";
    self.weixinCell.textLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.weixinCell.textLabel.textColor = kCEETextLightBlackColor;
    self.weixinCell.detailTextLabel.text = @"@ceeapp";
    self.weixinCell.detailTextLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    self.weixinCell.detailTextLabel.textColor = kCEETextLightBlackColor;
    
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:8];
    self.versionLabel.textColor = kCEETextGrayColor;
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本号%@", version];
    [self.view addSubview:self.versionLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(1);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.line.mas_bottom).offset(10);
    }];
    
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(243);
        make.height.mas_equalTo(82);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoButton.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.versionLabel.mas_top);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    self.navigationItem.title = @"关于我们";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)videoPressed:(id)sender {
    AVPlayerViewController * playerVC = [[AVPlayerViewController alloc] init];
    playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:playerVC animated:YES completion:^{
        NSString * videoPath = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"mp4"];
        if (!videoPath) {
            return;
        }
        playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:videoPath]];
        [playerVC.player play];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.webCell;
    }
    if (indexPath.row == 1) {
        return self.weixinCell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ceeapp.cn"]];
    }
}

@end
