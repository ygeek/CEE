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
#import "CEENotificationNames.h"
#import "HUDNetworkErrorViewController.h"
#import "HUDTaskCompletedViewController.h"
#import "HUDCouponAcquiringViewController.h"
#import "HUDNewMapViewController.h"
#import "CEEMessagesManager.h"
#import "CEEDatabase.h"
#import "IntroViewController.h"
#import "CEELoginAwardsAPI.h"


@interface RootViewController ()
@property (nonatomic, assign) BOOL isAppeared;
@property (nonatomic, assign) BOOL isPresentingLogin;
@property (nonatomic, assign) BOOL isPresentingUserProfile;

@property (nonatomic, strong) NSMutableArray * presentHUDQueue;
@property (nonatomic, strong) UIViewController * presentedHUD;

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
    
    self.tabBar.clipsToBounds = NO;
    
    self.tabBar.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
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
        item.itemHeight = 55;
        item.imagePositionAdjustment = UIOffsetMake(0, 3);
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
    }
    items[0].title = _T(@"drawer");
    [items[0] setFinishedSelectedImage:[UIImage imageNamed:@"抽屉_active"] withFinishedUnselectedImage:[UIImage imageNamed:@"抽屉"]];
    items[1].title = _T(@"world");
    [items[1] setFinishedSelectedImage:[UIImage imageNamed:@"世界_active"] withFinishedUnselectedImage:[UIImage imageNamed:@"世界"]];
    items[2].title = _T(@"story");
    [items[2] setFinishedSelectedImage:[UIImage imageNamed:@"故事_active"] withFinishedUnselectedImage:[UIImage imageNamed:@"故事"]];
    items[3].title = _T(@"message");
    [items[3] setFinishedSelectedImage:[UIImage imageNamed:@"消息_active"] withFinishedUnselectedImage:[UIImage imageNamed:@"消息"]];
    
    self.isAppeared = NO;
    self.isPresentingLogin = NO;
    
    self.presentHUDQueue = [NSMutableArray array];
    
    RAC(items[3], badgeValue) = [RACObserve([CEEMessagesManager manager], unreadCount) map:^id(NSNumber *unreadCount) {
        return unreadCount.integerValue > 0 ? unreadCount.stringValue : nil;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkErrorNotification:)
                                                 name:kCEENetworkErrorNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storyCompleteNotification:)
                                                 name:kCEEStoryCompleteNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(couponAcquiringNotification:)
                                                 name:kCEECouponAcquiringNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HUDPresentNotification:)
                                                 name:kCEEHUDPresentNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HUDDismissNotification:)
                                                 name:kCEEHUDDismissNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foundNewMapNotification:)
                                                 name:kCEEFoundNewMapNotificationName
                                               object:nil];
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
        
        @weakify(self)
        [[RACSignal combineLatest:@[tokenSignal, profileSignal]
                           reduce:
          ^id(NSString * token, CEEJSONUserProfile * profile) {
              return @(token && profile);
          }] subscribeNext:^(NSNumber * loginCompleted) {
              @strongify(self)
              if (loginCompleted.boolValue) {
                  [self fetchLoginAwards];
              }
          }];
        
        if (![[CEEDatabase db] splashShowed]) {
            [[CEEDatabase db] setSplashShowed:YES];
            IntroViewController * introVC = [[IntroViewController alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCEEHUDPresentNotificationName
                                                                object:self
                                                              userInfo:@{kCEEHUDKey: introVC}];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchLoginAwards {
    [[CEELoginAwardsAPI api] fetchLoginAwards].then(^(NSArray<CEEJSONAward *> *awards) {
        
        for (CEEJSONAward * award in awards) {
            if ([award.type isEqualToString:@"coin"]) {
                HUDTaskCompletedViewController * vc = [[HUDTaskCompletedViewController alloc] init];
                [vc loadAwards:@[award] andImageKey:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kCEEHUDPresentNotificationName
                                                                    object:self
                                                                  userInfo:@{kCEEHUDKey: vc}];
            }
        }
    }).catch(^(NSError *error) {
        NSLog(@"fetch login awards error: %@", error);
    });
}

- (void)networkErrorNotification:(NSNotification *)notification {
    HUDNetworkErrorViewController * vc = [[HUDNetworkErrorViewController alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEHUDPresentNotificationName
                                                        object:self
                                                      userInfo:@{kCEEHUDKey: vc}];
}

- (void)storyCompleteNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEDismissStoryCoverNOtificationName object:self];
    
    HUDTaskCompletedViewController * vc = [[HUDTaskCompletedViewController alloc] init];
    NSArray * awards = notification.userInfo[kCEEStoryCompleteAwardsKey];
    CEEJSONStory * story = notification.userInfo[kCEEStoryCompleteStoryKey];
    [vc loadAwards:awards andImageKey:story.hud_image_key];
    vc.story = story;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEHUDPresentNotificationName
                                                        object:self
                                                      userInfo:@{kCEEHUDKey: vc}];
}

- (void)couponAcquiringNotification:(NSNotification *)notification {
    HUDCouponAcquiringViewController * couponHUD = [[HUDCouponAcquiringViewController alloc] init];
    [couponHUD loadCoupon:notification.userInfo[kCEECouponAwardsKey]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEHUDPresentNotificationName
                                                        object:self
                                                      userInfo:@{kCEEHUDKey: couponHUD}];
}

- (void)foundNewMapNotification:(NSNotification *)notification {
    CEEJSONMap * map = notification.userInfo[kCEENewMapKey];
    HUDNewMapViewController * vc = [[HUDNewMapViewController alloc] init];
    [vc loadMap:map];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEHUDPresentNotificationName
                                                        object:self
                                                      userInfo:@{kCEEHUDKey: vc}];
}

- (void)HUDPresentNotification:(NSNotification *)notification {
    UIViewController * vc = notification.userInfo[kCEEHUDKey];
    if (self.presentedHUD) {
        [self.presentHUDQueue addObject:vc];
    } else {
        UIViewController * rootVC = self.presentedViewController ?: self;
        [rootVC presentViewController:vc animated:YES completion:nil];
        self.presentedHUD = vc;
    }
}

- (void)HUDDismissNotification:(NSNotification *)notification {
    self.presentedHUD = nil;
    UIViewController * vc = notification.userInfo[kCEEHUDKey];
    [vc dismissViewControllerAnimated:YES completion:^{
        if (self.presentHUDQueue.count > 0) {
            UIViewController * next = [self.presentHUDQueue firstObject];
            [self.presentHUDQueue removeObjectAtIndex:0];
            UIViewController * rootVC = self.presentedViewController ?: self;
            [rootVC presentViewController:next animated:YES completion:nil];
        }
    }];
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
        self.isPresentingLogin = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
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
        self.isPresentingUserProfile = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
