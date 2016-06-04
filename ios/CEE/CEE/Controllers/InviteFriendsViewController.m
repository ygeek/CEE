//
//  InviteFriendsViewController.m
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import SVProgressHUD;

#import <PromiseKit/PromiseKit.h>

#import "InviteFriendsViewController.h"
#import "InviteFriendTableViewCell.h"
#import "CEESearchFriendAPI.h"
#import "CEEUserSession.h"
#import "UIImageView+Utils.h"

@interface InviteFriendsViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray<CEEJSONFriendInfo *> * users;
@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"通过CEE帐号查找并添加好友";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[InviteFriendTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.navigationItem.title = @"添加好友";
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backPressed:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.users) {
        [self.tableView reloadData];
        return;
    }
    
    if (self.query && self.query.length > 0) {
        [SVProgressHUD show];
        [[CEESearchFriendAPI api] queryFriends:self.query]
        .then(^(NSArray<CEEJSONFriendInfo *> * friends) {
            self.query = nil;
            [SVProgressHUD dismiss];
            self.users = [friends mutableCopy];
            for (CEEJSONFriendInfo * friend in self.users) {
                friend.comment = @"来自用户搜索";
            }
            [self.tableView reloadData];
        }).catch(^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
        return;
    }
    
    self.users = [NSMutableArray array];
    if ([CEEUserSession session].mobileFriends || [CEEUserSession session].weiboFriends) {
        [self.users addObjectsFromArray:[CEEUserSession session].mobileFriends];
        [self.users addObjectsFromArray:[CEEUserSession session].weiboFriends];
        [self.tableView reloadData];
    } else {
        [SVProgressHUD show];
        [[CEEUserSession session] checkAddressBookFriends]
        .then(^(NSArray<CEEJSONFriendInfo *> *mobileFriends) {
            [CEEUserSession session].mobileFriends = [mobileFriends mutableCopy];
            for (CEEJSONFriendInfo * friendInfo in [CEEUserSession session].mobileFriends) {
                friendInfo.comment = @"来自通讯录"; //friendInfo.username;
            }
            [self.users addObjectsFromArray:[CEEUserSession session].mobileFriends];
            //return [[CEEUserSession session] loadFriends];
        }).then(^{
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }).catch(^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)followPressed:(id)sender {
    InviteFriendTableViewCell * cell = sender;
    while (cell && ![cell isKindOfClass:[InviteFriendTableViewCell class]]) {
        cell = (InviteFriendTableViewCell *)(cell.superview);
    }
    if (cell) {
        [SVProgressHUD show];
        CEEJSONFriendInfo * friendInfo = cell.friendInfo;
        [[CEEUserSession session] followFriend:friendInfo.id].then(^{
            NSInteger index = [self.users indexOfObjectPassingTest:
                               ^BOOL(CEEJSONFriendInfo * obj, NSUInteger idx, BOOL * stop) {
                                   return [obj.id isEqualToNumber:friendInfo.id];
                               }];
            if (index != NSNotFound) {
                [self.users removeObjectAtIndex:index];
            }
            index = [[CEEUserSession session].mobileFriends indexOfObjectPassingTest:
                     ^BOOL(CEEJSONFriendInfo * obj, NSUInteger idx, BOOL * stop) {
                         return [obj.id isEqualToNumber:friendInfo.id];
                     }];
            if (index != NSNotFound) {
                [[CEEUserSession session].mobileFriends removeObjectAtIndex:index];
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }).catch(^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [SVProgressHUD show];
    [[CEESearchFriendAPI api] queryFriends:searchBar.text]
    .then(^(NSArray<CEEJSONFriendInfo *> * friends) {
        [SVProgressHUD dismiss];
        self.users = [friends mutableCopy];
        for (CEEJSONFriendInfo * friend in self.users) {
            friend.comment = @"来自用户搜索";
        }
        [self.tableView reloadData];
    }).catch(^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CEEJSONFriendInfo * friendInfo = self.users[indexPath.row];
    
    cell.friendInfo = friendInfo;
    [cell.iconView cee_setImageWithKey:friendInfo.head_img_key placeholder:[UIImage imageNamed:@"cee-头像"]];
    cell.nameLabel.text = friendInfo.nickname ?: @"无名氏"; //friendInfo.username;
    cell.detailLabel.text = friendInfo.comment;
    [cell.followButton removeTarget:nil
                             action:NULL
                   forControlEvents:UIControlEventAllEvents];
    [cell.followButton addTarget:self
                          action:@selector(followPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
