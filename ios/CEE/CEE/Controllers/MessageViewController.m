//
//  MessageViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import RDVTabBarController;
@import ReactiveCocoa;

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "AppearanceConstants.h"
#import "UserProfileViewController.h"
#import "CEEUserSession.h"
#import "CEEMessagesManager.h"
#import "CEEStoriesManager.h"


@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) RACDisposable * messagesToken;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self)
    self.messagesToken = [RACObserve([CEEMessagesManager manager], messages) subscribeNext:^(NSArray *messages) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [[CEEMessagesManager manager] fetchMessages].then(^{
        return [[CEEStoriesManager manager] checkStartedStories];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.messagesToken dispose];
}

- (void)menuPressed:(id)sender {
    UserProfileViewController * profileVC = [[UserProfileViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [self.rdv_tabBarController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CEEJSONMessage * message = [CEEMessagesManager manager].messages[indexPath.row];
    if (message.unread.boolValue) {
        [[CEEMessagesManager manager] markReadWithMessageID:message.id];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [CEEMessagesManager manager].messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageTableViewCell class])];
    
    CEEJSONMessage * message = [CEEMessagesManager manager].messages[indexPath.row];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    cell.dateLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:message.timestamp.floatValue]];
    cell.messageLabel.text = message.text;
    
    cell.bodyView.backgroundColor = message.unread.boolValue ? hexColor(0xefe529) : hexColor(0xefefef);
    
    if ([message.type isEqualToString:@"story"]) {
        cell.iconView.image = [[UIImage imageNamed:@"消息_故事"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else if ([message.type isEqualToString:@"attention"]) {
        cell.iconView.image = [[UIImage imageNamed:@"消息_注意"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else if ([message.type isEqualToString:@"coupon"]) {
        cell.iconView.image = [[UIImage imageNamed:@"消息_提示"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
