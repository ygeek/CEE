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


@implementation CEERegisterResponse
@end


@implementation CEERegisterAPI

- (AnyPromise *)registerWithMobile:(NSString *)mobile password:(NSString *)password {
    CEERegisterRequest * request = [[CEERegisterRequest alloc] init];
    request.username = mobile;
    request.password = password;
    request.mobile = mobile;
    return [self promisePOST:@"/api/v1/register/" withRequest:request].then(^(CEERegisterResponse * response) {
        return response.auth;
    });
}

- (Class)responseSuccessClass {
    return [CEERegisterResponse class];
}

@end
