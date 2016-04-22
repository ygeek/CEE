//
//  CEEUserProfileAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEESaveUserProfileAPI.h"

@implementation CEESaveUserProfileRequest
@end


@implementation CEESaveUserProfileSuccessResponse
@end


@implementation CEESaveUserProfileErrorResponse
@end


@implementation CEESaveUserProfileAPI

- (RACSignal *)saveUserProfile:(CEESaveUserProfileRequest *)request {
    return [self POST:@"/api/v1/userprofile/" withRequest:request];
}

- (Class)responseSuccessClass {
    return [CEESaveUserProfileSuccessResponse class];
}

- (Class)responseErrorClass {
    return [CEESaveUserProfileErrorResponse class];
}

@end
