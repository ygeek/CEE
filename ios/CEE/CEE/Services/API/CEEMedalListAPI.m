//
//  CEEMedalListAPI.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEMedalListAPI.h"


@implementation CEEMedalListResponse

@end


@implementation CEEMedalListAPI

- (AnyPromise *)fetchMedals {
    return [self promiseGET:@"/api/v1/user/medals/" withParams:nil].then(^(CEEMedalListResponse *response) {
        return response.medals;
    });
}

- (AnyPromise *)fetchFriendMedals:(NSNumber *)friendId {
    NSString * url = [NSString stringWithFormat:@"/api/v1/user/medals/%@/", friendId];
    return [self promiseGET:url withParams:nil].then(^(CEEMedalListResponse *response) {
        return response.medals;
    });
}

- (Class)responseSuccessClass {
    return [CEEMedalListResponse class];
}

@end
