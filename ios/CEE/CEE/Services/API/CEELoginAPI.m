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


@implementation CEELoginResponse
@end


@implementation CEELoginAPI

- (AnyPromise *)loginWithUsername:(NSString *)username password:(NSString *)password {
    CEELoginRequest * request = [[CEELoginRequest alloc] init];
    request.username = username;
    request.password = password;
    return [self promisePOST:@"/api/v1/login/" withRequest:request].then(^(CEELoginResponse *response) {
        return response.auth;
    });
}

- (Class)responseSuccessClass {
    return [CEELoginResponse class];
}

@end
