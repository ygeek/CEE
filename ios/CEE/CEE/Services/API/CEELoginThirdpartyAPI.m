//
//  CEELoginThirdpartyAPI.m
//  CEE
//
//  Created by Meng on 16/5/12.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEELoginThirdpartyAPI.h"


@implementation CEELoginThirdpartyRequest
@end


@implementation CEELoginThirdpartyResponse
@end


@implementation CEELoginThirdpartyAPI

- (AnyPromise *)loginWithUid:(NSString *)uid platform:(NSString *)platform accessToken:(NSString *)accessToken {
    CEELoginThirdpartyRequest * request = [CEELoginThirdpartyRequest alloc];
    request.uid = uid;
    request.platform = platform;
    request.access_token = accessToken;
    
    return [self promisePOST:@"/api/v1/login/thirdparty/" withRequest:request].then(^(CEELoginThirdpartyResponse * response) {
        return PMKManifold(response.auth, response.username, response.user);
    });
}

- (Class)responseSuccessClass {
    return [CEELoginThirdpartyResponse class];
}

@end
