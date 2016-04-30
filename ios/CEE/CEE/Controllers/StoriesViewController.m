//
//  StoryViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import RDVTabBarController;

#import "StoriesViewController.h"
#import "StoryCoverViewController.h"
#import "StoryTableViewCell.h"
#import "StoryTableViewCellMenuView.h"
#import "RefreshingPanel.h"
#import "UIImage+Utils.h"
#import "AppearanceConstants.h"
#import "HUDCouponAcquiringViewController.h"
#import "HUDStoryCompletedViewController.h"
#import "HUDStoryFetchingViewController.h"

@interface StoriesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) RefreshingPanel * refreshingPanel;
@end


@implementation StoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = kCEEBackgroundGrayColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 250.0 + 1.0 / [UIScreen mainScreen].scale;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[StoryTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([StoryTableViewCell class])];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.refreshingPanel = [[RefreshingPanel alloc]
                            initWithFrame:CGRectMake(0,
                                                     -[RefreshingPanel defaultHeight],
                                                     [UIScreen mainScreen].bounds.size.width,
                                                     [RefreshingPanel defaultHeight])];
    [self.tableView addSubview:self.refreshingPanel];
    
    self.navigationItem.rightBarButtonItem
        = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"弹窗个人主页_发光"]
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
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)menuPressed:(id)sender {
    /*
    CouponAcquiringViewController * vc = [[CouponAcquiringViewController alloc] init];
    [self.rdv_tabBarController presentViewController:vc animated:YES completion:nil];
     */
    
    /*
    HUDStoryCompletedViewController * vc = [[HUDStoryCompletedViewController alloc] init];
    [self.rdv_tabBarController presentViewController:vc animated:YES completion:nil];
     */
    
    HUDStoryFetchingViewController * vc = [[HUDStoryFetchingViewController alloc] init];
    [self.rdv_tabBarController presentViewController:vc animated:YES completion:nil];
}

- (void)refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        }];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO (zhangmeng): read from real data source
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StoryTableViewCell class])
                                                                     forIndexPath:indexPath];
    
    StoryTableViewCellMenuView *menuView = [[StoryTableViewCellMenuView alloc] initWithFrame:CGRectMake(0, 0, 148, self.tableView.rowHeight)];
    cell.rightMenuView = menuView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StoryCoverViewController * storyCoverVC = [[StoryCoverViewController alloc] init];
    [self.navigationController pushViewController:storyCoverVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -[RefreshingPanel defaultHeight] - 10.0f) {
        CGPoint contentOffset = scrollView.contentOffset;
        self.tableView.contentInset = UIEdgeInsetsMake([RefreshingPanel defaultHeight], 0, 49, 0);
        self.tableView.contentOffset = contentOffset;
        [self refresh];
    }
}

@end
