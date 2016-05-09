//
//  SDKManager.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import SVProgressHUD;

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <SMS_SDK/SMSSDK.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "SDKManager.h"


@implementation SDKManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SDKManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // TODO: init something
    }
    return self;
}

- (void)setup {
    [self setupAVOS];
    [self setupShareSDK];
    [self setupSMSSDK];
}

- (void)setupAVOS {
    [AVOSCloudCrashReporting enable];
    
    [AVOSCloud setApplicationId:@"zbamEfqUbNTXNwLKw8LiTPK0-gzGzoHsz"
                      clientKey:@"nWuVXVcpDSr4Eu3DHJqqSDyY"];
    
    [AVOSCloud registerForRemoteNotification];
}

- (void)setupShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1193bccdc759e"
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:
     ^(SSDKPlatformType platformType) {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:
     ^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
         switch (platformType) {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

- (void)setupSMSSDK {
    [SMSSDK registerApp:@"11e838894b027" withSecret:@"8822a23e91a7e140c41c26c7a7662b6f"];
}

- (void)loginQQ {
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSString * uid = user.uid;
            NSString * nickname = user.nickname;
            SSDKCredential * credential = user.credential;
            NSString * token = user.credential.token;
            NSString * icon = user.icon;
            SSDKGender * gender = user.gender;
            // TODO (zhangmeng): upload user icon
            // TODO (zhangmeng): login with user id & token
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)loginWeixin {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSString * uid = user.uid;
            NSString * nickname = user.nickname;
            SSDKCredential * credential = user.credential;
            NSString * token = user.credential.token;
            NSString * icon = user.icon;
            SSDKGender * gender = user.gender;
            // TODO (zhangmeng): upload user icon
            // TODO (zhangmeng): login with user id & token
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)loginWeibo {
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSString * uid = user.uid;
            NSString * nickname = user.nickname;
            SSDKCredential * credential = user.credential;
            NSString * token = user.credential.token;
            NSString * icon = user.icon;
            SSDKGender * gender = user.gender;
            // TODO (zhangmeng): upload user icon
            // TODO (zhangmeng): login with user id & token
        } else {
            NSLog(@"%@", error);
        }
    }];
}

@end
