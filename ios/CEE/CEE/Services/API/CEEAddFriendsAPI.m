//
//  CEEAddFriendsAPI.m
//  CEE
//
//  Created by Meng on 16/5/9.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEAddFriendsAPI.h"


@implementation CEEAddFriendsRequest

@end


@implementation CEEAddFriendsResponse

@end


@implementation CEEAddFriendsAPI

- (AnyPromise *)addMobiles:(NSArray<NSString *> *)mobiles {
    CEEAddFriendsRequest * request = [[CEEAddFriendsRequest alloc] init];
    request.mobiles = [mobiles componentsJoinedByString:@","];
    return [self promisePOST:@"/api/v1/user/addfriends/" withRequest:request].then(^(CEEAddFriendsResponse * response) {
        return response.num;
    });
}

- (Class)responseSuccessClass {
    return [CEEAddFriendsResponse class];
}

@end
