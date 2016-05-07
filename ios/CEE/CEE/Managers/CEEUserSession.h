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


@interface CEEUserSession : NSObject

+ (instancetype)session;

@property (nonatomic, copy) NSString * authToken;
@property (nonatomic, strong) CEEJSONUserProfile * userProfile;
@property (nonatomic, strong) NSArray<CEEJSONFriendInfo *> * friends;
@property (nonatomic, assign) BOOL isFetchingUserProfile;
@property (nonatomic, assign) BOOL authorizationFailed;

- (void)load;

- (AnyPromise *)loggedInWithAuth:(NSString *)auth;

- (AnyPromise *)loadUserProfile;

- (AnyPromise *)loadFriends;

- (void)onUnauthorized;

@end
