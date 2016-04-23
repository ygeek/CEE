//
//  CEERegisterAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEERegisterAPI.h"

@implementation CEERegisterRequest
@end


@implementation CEERegisterSuccessResponse
@end


@implementation CEERegisterErrorResponse
@end


@implementation CEERegisterAPI

- (AnyPromise *)registerWithMobile:(NSString *)mobile password:(NSString *)password {
    CEERegisterRequest * request = [[CEERegisterRequest alloc] init];
    request.username = mobile;
    request.password = password;
    request.mobile = mobile;
    return [self promisePOST:@"/api/v1/register/" withRequest:request];
}

- (Class)responseSuccessClass {
    return [CEERegisterSuccessResponse class];
}

- (Class)responseErrorClass {
    return [CEERegisterErrorResponse class];
}

@end
