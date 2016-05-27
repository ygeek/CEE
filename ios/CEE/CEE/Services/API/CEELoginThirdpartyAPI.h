//
//  CEELoginThirdpartyAPI.h
//  CEE
//
//  Created by Meng on 16/5/12.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEUserInfo.h"

#define kCEEPlatformQQ     @"qq"
#define kCEEPlatformWeibo  @"weibo"
#define kCEEPlatformWeixin @"weixin"


@interface CEELoginThirdpartyRequest: JSONModel
@property (nonatomic, strong) NSString * access_token;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * platform;
@end


@interface CEELoginThirdpartyResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * auth;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) CEEJSONUserInfo<Optional> * user;
@end


@interface CEELoginThirdpartyAPI : CEEBaseAPI

- (AnyPromise *)loginWithUid:(NSString *)uid platform:(NSString *)platform accessToken:(NSString *)accessToken;

@end
