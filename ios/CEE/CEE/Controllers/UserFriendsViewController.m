//
//  UserFriendsViewController.m
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import SVProgressHUD;

#import <PromiseKit/PromiseKit.h>

#import "UserFriendsViewController.h"
#import "UserFriendTableViewCell.h"
#import "CEEUserSession.h"
#import "UIImage+Utils.h"
#import "AppearanceConstants.h"
#import "CEENotificationNames.h"


#define kUserFriendCellIdentifier @"kUserFriendCellIdentifier"


@interface UserFriendsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel * friendsNumLabel;
@property (nonatomic, strong) UIImageView * friendsIcon;
@property (nonatomic, strong) UITextField * inviteField;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray<CEEJSONFriendInfo *> * friends;
@end

@implementation UserFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.friendsNumLabel = [[UILabel alloc] init];
    self.friendsNumLabel.textAlignment = NSTextAlignmentRight;
    self.friendsNumLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:15];
    self.friendsNumLabel.textColor = kCEETextBlackColor;
    self.friendsNumLabel.text = @"0";
    
    [self.view addSubview:self.friendsNumLabel];
    
    self.friendsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"好友列表"]];
    [self.view addSubview:self.friendsIcon];
    
    self.inviteField = [[UITextField alloc] init];
    self.inviteField.textAlignment = NSTextAlignmentCenter;
    self.inviteField.backgroundColor = hexColor(0xdcdcdc);
    self.inviteField.textColor = kCEETextBlackColor;
    self.inviteField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"邀请"
                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:12],
                                                 NSForegroundColorAttributeName: hexColor(0xb4b4b4)}];
    self.inviteField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView * searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.frame = CGRectMake(0, 0, 20, 20);
    self.inviteField.leftView = searchIcon;
    self.inviteField.rightViewMode = UITextFieldViewModeAlways;
    self.inviteField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.view addSubview:self.inviteField];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 110;
    [self.tableView registerClass:[UserFriendTableViewCell class] forCellReuseIdentifier:kUserFriendCellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self.friendsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(67);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(23);
        make.centerX.equalTo(self.view.mas_left).offset(37 + 46);
    }];
    
    [self.friendsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.friendsIcon.mas_left).offset(-3);
        make.centerY.equalTo(self.friendsIcon.mas_centerY);
    }];
    
    [self.inviteField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.friendsIcon.mas_right).offset(16);
        make.centerY.equalTo(self.friendsIcon.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(213);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.friendsIcon.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backPressed:)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(23, 23)]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(settingPressed:)];
    
    CEEUserSession * session = [CEEUserSession session];
    if (session.friends) {
        self.friends = session.friends;
        [self update];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendsUpdatedNotification:)
                                                 name:kCEEFriendsUpdatedNotificationName
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.friends) {
        [SVProgressHUD show];
        CEEUserSession * session = [CEEUserSession session];
        [session loadFriends].then(^(NSArray *friends) {
            self.friends = friends;
            [self update];
            [SVProgressHUD dismiss];
        }).catch(^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    }
}

- (void)update {
    self.friendsNumLabel.text = @(self.friends.count).stringValue;
    [self.tableView reloadData];
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)settingPressed:(id)sender {
    
}

- (void)friendsUpdatedNotification:(NSNotification *)notification {
    CEEUserSession * session = [CEEUserSession session];
    [session loadFriends].then(^(NSArray *friends) {
        self.friends = friends;
        [self update];
    });
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kUserFriendCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadFriendInfo:self.friends[indexPath.row]];
    return cell;
}

@end
