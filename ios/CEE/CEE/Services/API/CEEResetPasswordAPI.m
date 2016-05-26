//
//  CEEResetPasswordAPI.m
//  CEE
//
//  Created by Meng on 16/5/26.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEResetPasswordAPI.h"

@implementation CEEResetPasswordRequest

@end


@implementation CEEResetPasswordResponse

@end


@implementation CEEResetPasswordAPI

- (AnyPromise *)resetUsername:(NSString *)username password:(NSString *)password code:(NSString *)code {
    CEEResetPasswordRequest * request = [[CEEResetPasswordRequest alloc] init];
    request.username = username;
    request.password = password;
    request.code = code;
    return [self promisePOST:@"/api/v1/resetpassword/" withRequest:request].then(^(CEEResetPasswordResponse * response) {
        return response.auth;
    });
}

- (Class)responseSuccessClass {
    return [CEEResetPasswordResponse class];
}

@end
