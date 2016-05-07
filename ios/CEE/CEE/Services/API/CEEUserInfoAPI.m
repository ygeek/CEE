//
//  CEEUserInfoAPI.m
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEUserInfoAPI.h"

@implementation CEEUserInfoResponse

@end


@implementation CEEUserInfoAPI

- (AnyPromise *)fetchUserInfo {
    return [self promiseGET:@"/api/v1/user/info/" withParams:nil].then(^(CEEUserInfoResponse * response) {
        return response.userInfo;
    });
}

- (Class)responseSuccessClass {
    return [CEEUserInfoResponse class];
}

@end
