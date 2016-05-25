//
//  CEEFollowFriendAPI.m
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEFollowFriendAPI.h"


@implementation CEEFollowFriendsRequest
@end


@implementation CEEFollowFriendAPI

- (AnyPromise *)followFriendWithID:(NSNumber *)id {
    CEEFollowFriendsRequest * request = [[CEEFollowFriendsRequest alloc] init];
    request.id = id;
    return [self promisePOST:@"/api/v1/user/followfriend/" withRequest:request]
    .then(^(CEEBaseResponse * response) {
        return response.msg;
    });
}

@end
