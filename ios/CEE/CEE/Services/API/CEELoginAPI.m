//
//  CEELoginAPI.m
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEELoginAPI.h"

@implementation CEELoginRequest
@end


@implementation CEELoginSuccessResponse
@end


@implementation CEELoginErrorResponse
@end


@implementation CEELoginAPI

- (AnyPromise *)loginWithUsername:(NSString *)username password:(NSString *)password {
    CEELoginRequest * request = [[CEELoginRequest alloc] init];
    request.username = username;
    request.password = password;
    return [self promisePOST:@"/api/v1/login/" withRequest:request];
}

- (Class)responseSuccessClass {
    return [CEELoginSuccessResponse class];
}

- (Class)responseErrorClass {
    return [CEELoginErrorResponse class];
}

@end
