//
//  CEESearchFriendAPI.m
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEESearchFriendAPI.h"

@implementation CEESearchFriendsRequest

@end


@implementation CEESearchFriendsResponse

@end


@implementation CEESearchFriendAPI

- (AnyPromise *)queryFriends:(NSString *)query {
    CEESearchFriendsRequest * request = [[CEESearchFriendsRequest alloc] init];
    request.query = query;
    return [self promisePOST:@"/api/v1/user/searchfriends/" withRequest:request]
    .then(^(CEESearchFriendsResponse * response) {
        return response.friends;
    });
}

- (Class)responseSuccessClass {
    return [CEESearchFriendsResponse class];
}

@end
