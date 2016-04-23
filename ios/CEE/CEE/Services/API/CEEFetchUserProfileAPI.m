//
//  CEEFetchUserProfileAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEFetchUserProfileAPI.h"

@implementation CEEFetchUserProfileSuccessResponse
@end


@implementation CEEFetchUserProfileErrorResponse
@end


@implementation CEEFetchUserProfileAPI

- (AnyPromise *)fetchUserProfile {
    return [self promiseGET:@"/api/v1/userprofile/" withParams:nil];
}

- (Class)responseSuccessClass {
    return [CEEFetchUserProfileSuccessResponse class];
}

- (Class)responseErrorClass {
    return [CEEFetchUserProfileErrorResponse class];
}

@end
