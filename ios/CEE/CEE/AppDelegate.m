//
//  AppDelegate.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import AVFoundation;
@import AVKit;

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

#import <UMengSocialCOM/UMSocial.h>

#import "AppDelegate.h"
#import "CEESDKManager.h"
#import "CEEAppearanceManager.h"
#import "RootViewController.h"
#import "CEEUtils.h"
#import "CEEUserSession.h"
#import "CEEImageManager.h"
#import "CEEMapManager.h"
#import "CEEMessagesManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[CEESDKManager sharedInstance] setup];
    [CEEAppearanceManager setup];
    [CEEImageManager manager];
    [[CEEUserSession session] load];
    [[CEEMapManager manager] startMonitoringLocationChanges];
    [[CEEMessagesManager manager] fetchMessages];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    self.window.rootViewController = [[RootViewController alloc] init];
    
    [self.window makeKeyAndVisible];
   
    [CEEUtils printAllFontNames];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[CEEMapManager manager] stopMonitoringLocationChanges];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[CEEMapManager manager] startMonitoringLocationChanges];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"save installation to leancloud succeed!");
        } else {
            NSLog(@"save installation to leancloud error: %@", error);
        }
    }];
    [CEEUserSession session].deviceToken = currentInstallation.deviceToken;
    [CEEUserSession session].installationId = currentInstallation.installationId;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([self.window.rootViewController.presentedViewController isKindOfClass: [AVPlayerViewController class]]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self handleURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
    return [self handleURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [self handleURL:url];
}

- (BOOL)handleURL:(NSURL *)url {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == NO) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

@end
