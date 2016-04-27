//
//  CEEAppearanceManager.m
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import SVProgressHUD;


#import "CEEAppearanceManager.h"
#import "AppearanceConstants.h"

@implementation CEEAppearanceManager

+ (void)setup {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kCEETextBlackColor,
                                                           NSFontAttributeName: [UIFont fontWithName:kCEEFontNameBold size:16]}];
    [[UIBarButtonItem appearance] setTintColor:kCEETextBlackColor];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}

@end
