//
//  CEEAddFriendsAPI.m
//  CEE
//
//  Created by Meng on 16/5/9.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEECheckFriendsAPI.h"


@implementation CEECheckFriendsRequest

@end


@implementation CEECheckFriendsResponse

@end


@implementation CEECheckFriendsAPI

- (AnyPromise *)checkMobiles:(NSArray<NSString *> *)mobiles {
    CEECheckFriendsRequest * request = [[CEECheckFriendsRequest alloc] init];
    request.mobiles = [mobiles componentsJoinedByString:@","];
    return [self promisePOST:@"/api/v1/user/checkfriends/" withRequest:request].then(^(CEECheckFriendsResponse * response) {
        return response.friends;
    });
}

- (Class)responseSuccessClass {
    return [CEECheckFriendsResponse class];
}

@end
