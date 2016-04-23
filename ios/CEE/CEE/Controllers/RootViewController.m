//
//  ViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import ReactiveCocoa;

#import "RootViewController.h"
#import "UtilsMacros.h"
#import "AppearanceConstants.h"
#import "DrawerViewController.h"
#import "WorldViewController.h"
#import "StoriesViewController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"
#import "CEEUserSession.h"
#import "FillProfileViewController.h"

@interface RootViewController ()
@property (nonatomic, assign) BOOL isAppeared;
@property (nonatomic, assign) BOOL isPresentingLogin;
@property (nonatomic, assign) BOOL isPresentingUserProfile;
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
    
    self.isAppeared = NO;
    self.isPresentingLogin = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isAppeared) {
        self.isAppeared = YES;
        
        RACSignal * tokenSignal = RACObserve([CEEUserSession session], authToken);
        RACSignal * profileSignal = RACObserve([CEEUserSession session], userProfile);
        RACSignal * isFetchingProfileSignal = RACObserve([CEEUserSession session], isFetchingUserProfile);
        
        [tokenSignal subscribeNext:^(NSString *token) {
            if (token && token.length > 0) {
                [self dismissLogin];
            } else {
                [self presentLogin];
            }
        }];
        
        [[RACSignal combineLatest:@[tokenSignal, profileSignal, isFetchingProfileSignal]
                           reduce:
          ^id(NSString * token, CEEJSONUserProfile * profile, NSNumber *isFetchingProfile){
              return @(token && profile == nil && !isFetchingProfile.boolValue);
          }] subscribeNext:^(NSNumber * shouldFillProfile) {
              if (shouldFillProfile.boolValue) {
                  [self presentUserProfileForm];
              } else {
                  [self dismissUserProfileForm];
              }
          }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentLogin {
    if (!self.isPresentingLogin) {
        self.isPresentingLogin = YES;
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC]
                           animated:YES completion:nil];
    }
}

- (void)dismissLogin {
    if (self.isPresentingLogin) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.isPresentingLogin = NO;
        }];
    }
}

- (void)presentUserProfileForm {
    if (!self.isPresentingUserProfile) {
        self.isPresentingUserProfile = YES;
        FillProfileViewController * vc = [[FillProfileViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)dismissUserProfileForm {
    if (self.isPresentingUserProfile) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.isPresentingUserProfile = NO;
        }];
    }
}

@end
