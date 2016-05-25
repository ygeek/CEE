//
//  CEEAddWeiboFriendsAPI.m
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEECheckWeiboFriendsAPI.h"


@implementation CEECheckWeiboFriendsRequest

@end


@implementation CEECheckWeiboFriendsResponse

@end


@implementation CEECheckWeiboFriendsAPI

- (AnyPromise *)checkWeiboFriends:(NSArray<NSString *> *)uids {
    CEECheckWeiboFriendsRequest * request = [[CEECheckWeiboFriendsRequest alloc] init];
    request.uids = [uids componentsJoinedByString:@","];
    return [self promisePOST:@"/api/v1/user/checkweibofriends/" withRequest:request].then(^(CEECheckWeiboFriendsResponse * response) {
        return response.friends;
    });
}

- (Class)responseSuccessClass {
    return [CEECheckWeiboFriendsResponse class];
}

@end


@implementation CEEAddWeiboFriendsRequest

@end


@implementation CEEAddWeiboFriendsResponse

@end


@implementation CEEAddWeiboFriendsAPI

- (AnyPromise *)addWeiboFriends:(NSArray<NSString *> *)uids {
    CEEAddWeiboFriendsRequest * request = [[CEEAddWeiboFriendsRequest alloc] init];
    request.uids = [uids componentsJoinedByString:@","];
    return [self promisePOST:@"/api/v1/user/addweibofriends/" withRequest:request].then(^(CEEAddWeiboFriendsResponse * response) {
        return response.num;
    });
}

- (Class)responseSuccessClass {
    return [CEEAddWeiboFriendsResponse class];
}

@end