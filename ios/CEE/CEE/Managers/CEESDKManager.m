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

#import <UMengSocialCOM/UMSocial.h>
#import <UMengSocialCOM/UMSocialWechatHandler.h>
#import <UMengSocialCOM/UMSocialQQHandler.h>
#import <UMengSocialCOM/UMSocialSinaSSOHandler.h>


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <SMS_SDK/SMSSDK.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"



#import "CEESDKManager.h"

#import "CEELoginThirdPartyAPI.h"


@implementation CEESDKManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CEESDKManager * instance = nil;
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
    [self setupUMeng];
}

- (void)setupAVOS {
    [AVOSCloudCrashReporting enable];
    
    [AVOSCloud setApplicationId:@"jqkXh6wD9aecX74oeOVz9CtN-gzGzoHsz"
                      clientKey:@"wflBBpW9pcnMkPXf5Xjuk510"];
    
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
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2021128999"
                                           appSecret:@"50aa01e44d915a2379a9b4836b7f3473"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx6d9b7471e7a25729"
                                       appSecret:@"9f28abd749e52d37b736501ca7246304"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105325484"
                                      appKey:@"KdMa9TCSESYNVEXk"
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

- (void)setupUMeng {
    [UMSocialData setAppKey:@"57351fd4e0f55a603c0021a6"];
    
    [UMSocialWechatHandler setWXAppId:@"wx6d9b7471e7a25729" appSecret:@"50aa01e44d915a2379a9b4836b7f3473" url:@"http://www.umeng.com/social"];
    
    [UMSocialQQHandler setQQWithAppId:@"1105325484" appKey:@"KdMa9TCSESYNVEXk" url:@"http://www.umeng.com/social"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2021128999" secret:@"50aa01e44d915a2379a9b4836b7f3473" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

- (AnyPromise *)_loginPlatform:(SSDKPlatformType)platformType {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [ShareSDK getUserInfo:platformType onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                resolve(user);
            } else {
                resolve(error);
            }
        }];
    }];
}

- (AnyPromise *)loginPlatform:(SSDKPlatformType)platform {
    SSDKPlatformType platformType = platform;
    NSString * platformName = nil;
    
    switch (platformType) {
        case SSDKPlatformTypeQQ:
            platformName = kCEEPlatformQQ;
            break;
        case SSDKPlatformTypeSinaWeibo:
            platformName = kCEEPlatformWeibo;
            break;
        case SSDKPlatformTypeWechat:
            platformName = kCEEPlatformWeixin;
            break;
        default:
            break;
    }
    
    return [self _loginPlatform:platformType].then(^(SSDKUser * user) {
        NSString * uid = user.uid;
        NSString * nickname = user.nickname;
        SSDKCredential * credential = user.credential;
        NSString * token = user.credential.token;
        NSString * icon = user.icon;
        SSDKGender * gender = user.gender;
        
        return [[CEELoginThirdpartyAPI api] loginWithUid:uid
                                                platform:platformName
                                             accessToken:token].then(^(CEEJSONUserInfo * userInfo) {
            
        });
    });
}

- (AnyPromise *)umengLoginViewController:(UIViewController *)vc platformName:(NSString *)platformName {
    NSString * ceePlatform = nil;
    if ([platformName isEqualToString:UMShareToSina]) {
        ceePlatform = kCEEPlatformWeibo;
    } else if ([platformName isEqualToString:UMShareToQQ]) {
        ceePlatform = kCEEPlatformQQ;
    } else if ([platformName isEqualToString:UMShareToWechatSession]) {
        ceePlatform = kCEEPlatformWeixin;
    } else {
        return [AnyPromise promiseWithValue:[NSError errorWithDomain:CEE_API_ERROR_DOMAIN
                                                                code:-1
                                                            userInfo:@{NSLocalizedDescriptionKey: @"不支持的第三方登录"}]];
    }
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(vc,
                                      [UMSocialControllerService defaultControllerService],
                                      YES,
                                      ^(UMSocialResponseEntity * response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                resolve(snsAccount);
            } else {
                resolve([NSError errorWithDomain:CEE_API_ERROR_DOMAIN
                                            code:-2
                                        userInfo:@{NSLocalizedDescriptionKey: response.message}]);
            }
        });
    }].then(^(UMSocialAccountEntity * snsAccount) {
        NSLog(@"username is %@, uid is %@, token is %@ url is %@",
              snsAccount.userName,
              snsAccount.usid,
              snsAccount.accessToken,
              snsAccount.iconURL);
        return [[CEELoginThirdpartyAPI api] loginWithUid:snsAccount.usid
                                                platform:ceePlatform
                                             accessToken:snsAccount.accessToken];
    });
}

- (AnyPromise *)loginQQInViewController:(UIViewController *)vc {
    return [self umengLoginViewController:vc platformName:UMShareToQQ];
}

- (AnyPromise *)loginWeixinInViewController:(UIViewController *)vc {
    return [self umengLoginViewController:vc platformName:UMShareToWechatSession];
}

- (AnyPromise *)loginWeiboInViewController:(UIViewController *)vc {
    return [self umengLoginViewController:vc platformName:UMShareToSina];
}

- (AnyPromise *)requestWeiboFriends {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina completion:^(UMSocialResponseEntity *response) {
            NSLog(@"sns friends data: %@", response.data);
            resolve(response.data.allKeys);
        }];
    }];
}

@end
