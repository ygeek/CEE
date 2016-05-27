//
//  CEEUserSession.h
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import PromiseKit;

#import <Foundation/Foundation.h>

#import "CEEUserProfile.h"
#import "CEEFriendInfo.h"

#define kCEEPlatformMobile @"mobile"
#define kCEEPlatformWeibo  @"weibo"
#define kCEEPlatformWeixin @"weixin"
#define kCEEPlatformQQ     @"qq"


@interface CEEUserSession : NSObject

+ (instancetype)session;

@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * authToken;
@property (nonatomic, strong) CEEJSONUserProfile * userProfile;
@property (nonatomic, strong) NSArray<CEEJSONFriendInfo *> * friends;
@property (nonatomic, strong) NSString * deviceToken;
@property (nonatomic, strong) NSString * installationId;
@property (nonatomic, assign) BOOL isFetchingUserProfile;
@property (nonatomic, assign) BOOL authorizationFailed;
@property (nonatomic, strong) NSMutableArray<CEEJSONFriendInfo *> * mobileFriends;
@property (nonatomic, strong) NSMutableArray<CEEJSONFriendInfo *> * weiboFriends;

- (void)load;

- (AnyPromise *)loggedInWithAuth:(NSString *)auth username:(NSString *)username platform:(NSString *)platform;

- (AnyPromise *)loadUserProfile;

- (AnyPromise *)loadFriends;

- (void)onUnauthorized;

- (AnyPromise *)checkAddressBookFriends;

- (AnyPromise *)checkWeiboFriends;

- (AnyPromise *)addWeiboFriends;

- (AnyPromise *)followFriend:(NSNumber *)uid;

@end
