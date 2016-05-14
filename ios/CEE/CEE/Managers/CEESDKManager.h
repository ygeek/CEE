//
//  SDKManager.h
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>


@interface CEESDKManager : NSObject

+ (instancetype)sharedInstance;

- (void)setup;

- (AnyPromise *)loginQQInViewController:(UIViewController *)vc;

- (AnyPromise *)loginWeixinInViewController:(UIViewController *)vc;

- (AnyPromise *)loginWeiboInViewController:(UIViewController *)vc;

- (AnyPromise *)requestWeiboFriends;

@end
