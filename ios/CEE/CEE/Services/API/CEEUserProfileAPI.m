//
//  CEEUserProfileAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEUserProfileAPI.h"

@implementation CEEUserProfileRequest
@end


@implementation CEEUserProfileSuccessResponse
@end


@implementation CEEUserProfileErrorResponse
@end


@implementation CEEUserProfileAPI

- (RACSignal *)saveUserProfile:(CEEUserProfileRequest *)request {
    return [self POST:@"/api/v1/userprofile/" withRequest:request];
}

- (Class)responseSuccessClass {
    return [CEEUserProfileSuccessResponse class];
}

- (Class)responseErrorClass {
    return [CEEUserProfileErrorResponse class];
}

@end
