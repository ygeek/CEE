//
//  ViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "RootViewController.h"
#import "UtilsMacros.h"
#import "AppearanceConstants.h"
#import "DrawerViewController.h"
#import "WorldViewController.h"
#import "StoriesViewController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    DrawerViewController * drawerVC = [[DrawerViewController alloc] init];
    
    WorldViewController * worldVC = [[WorldViewController alloc] init];
    
    StoriesViewController * storyVC = [[StoriesViewController alloc] init];
    
    MessageViewController * messageVC = [[MessageViewController alloc] init];
    
    [self.tabBar setFrame:CGRectMake(CGRectGetMinX(self.tabBar.frame),
                                     CGRectGetMinY(self.tabBar.frame),
                                     CGRectGetWidth(self.tabBar.frame),
                                     49)];
    
    self.tabBar.translucent = YES;
    
    self.tabBar.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    [self setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:drawerVC],
                               [[UINavigationController alloc] initWithRootViewController:worldVC],
                               [[UINavigationController alloc] initWithRootViewController:storyVC],
                               [[UINavigationController alloc] initWithRootViewController:messageVC]]];
    
    NSArray<RDVTabBarItem *> * items = self.tabBar.items;
    for (RDVTabBarItem * item in items) {
        item.selectedTitleAttributes = @{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:9],
                                         NSForegroundColorAttributeName: kCEETabBarSelectedTitleColor};
        item.unselectedTitleAttributes = @{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:9],
                                           NSForegroundColorAttributeName: UIColor.whiteColor};
        item.badgeBackgroundColor = kCEETabBarBadgeBackgroundColor;
        item.badgeTextColor = kCEETextBlackColor;
        item.badgeTextFont = [UIFont fontWithName:kCEEFontNameRegular size:6];
    }
    items[0].title = _T(@"drawer");
    items[1].title = _T(@"world");
    items[2].title = _T(@"story");
    items[3].title = _T(@"message");
    
    messageVC.view.backgroundColor = [UIColor blueColor];
    storyVC.view.backgroundColor = [UIColor greenColor];
    drawerVC.view.backgroundColor = [UIColor redColor];
    worldVC.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC]
                       animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
