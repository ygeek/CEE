//
//  CEEFriendListAPI.m
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEFriendListAPI.h"


@implementation CEEFriendListResponse
@end


@implementation CEEFriendListAPI

- (AnyPromise *)fetchFriendList {
    return [self promiseGET:@"/api/v1/user/friends/" withParams:nil].then(^(CEEFriendListResponse * response) {
        return response.friends;
    });
}

- (Class)responseSuccessClass {
    return [CEEFriendListResponse class];
}

@end
