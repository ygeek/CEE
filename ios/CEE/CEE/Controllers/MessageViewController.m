//
//  MessageViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import RDVTabBarController;

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "AppearanceConstants.h"
#import "UserProfileViewController.h"

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIImageView * titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"消息_title"]];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = kCEETextBlackColor;
    [self.titleView addSubview:titleIcon];
    [self.titleView addSubview:lineView];
    [titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.titleView);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView.mas_left);
        make.right.equalTo(self.titleView.mas_right);
        make.bottom.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[MessageTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([MessageTableViewCell class])];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"个人主页"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(menuPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuPressed:(id)sender {
    UserProfileViewController * profileVC = [[UserProfileViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [self.rdv_tabBarController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageTableViewCell class])];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    switch (indexPath.row) {
        case 0:
            cell.iconView.image = [[UIImage imageNamed:@"消息_故事"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
            cell.messageLabel.text = @"《Wade》任务正在进行中…";
            break;
        case 1:
            cell.iconView.image = [[UIImage imageNamed:@"消息_注意"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
            cell.messageLabel.text = @"发现在您周围的城市彩蛋《深夜食堂》，马上开始体验吧";
            break;
        case 2:
            cell.iconView.image = [[UIImage imageNamed:@"消息_提示"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
            cell.messageLabel.text = @"您有条优惠券即将过期——万达广场茶餐厅";
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
