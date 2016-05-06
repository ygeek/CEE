//
//  StoryEmptyViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import ReactiveCocoa;
@import Masonry;
@import SVProgressHUD;


#import "StoryEmptyViewController.h"
#import "CEENotificationNames.h"
#import "StoryLevelsRootViewController.h"
#import "StoryItemsViewController.h"


@interface StoryEmptyViewController ()
@property (nonatomic, strong) UIImageView * imageView;
@end


@implementation StoryEmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    RAC(self, imageView.image) = [RACObserve(self, image) doNext:^(UIImage *image) {
        if (image.size.width > [UIScreen mainScreen].bounds.size.width ||
            image.size.height > [UIScreen mainScreen].bounds.size.height) {
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            self.imageView.contentMode = UIViewContentModeCenter;
        }
    }];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backPressed:)];
    backItem.tintColor = UIColor.whiteColor;
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem * archiveItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"归档"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(archivePressed:)];
    archiveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = archiveItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEventNotification:)
                                                 name:kCEEEventNotificationName
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)archivePressed:(id)sender {
    StoryLevelsRootViewController * levelsRoot = (StoryLevelsRootViewController *)(self.navigationController);
    StoryItemsViewController * itemsVC = [[StoryItemsViewController alloc] init];
    itemsVC.completedLevels = levelsRoot.completedLevels;
    itemsVC.items = levelsRoot.items;
    UINavigationController * navVC = [[UINavigationController alloc] initWithRootViewController:itemsVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)handleEventNotification:(NSNotification *)notification {
    NSString * eventName = notification.userInfo[kCEEEventNameKey];
    if ([eventName isEqualToString:self.requiredEvent]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            StoryLevelsRootViewController * levelsRoot = (StoryLevelsRootViewController *)(self.navigationController);
            [levelsRoot nextLevel];
        }];
    } else {
        [SVProgressHUD showInfoWithStatus:@"什么都没发生"];
    }
}

@end
