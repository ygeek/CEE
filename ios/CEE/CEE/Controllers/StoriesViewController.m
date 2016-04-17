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
#import "UIImage+Utils.h"

@interface StoriesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@end


@implementation StoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 250.0 + 1.0 / [UIScreen mainScreen].scale;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[StoryTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([StoryTableViewCell class])];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem
        = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(23, 23)]
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

@end
