//
//  CEELoginAwardAPI.m
//  CEE
//
//  Created by Meng on 16/7/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEELoginAwardsAPI.h"


/*
 POST /api/v1/login_awards/
 
 {
    "code": 0,
    "awards": [
        {
            "type": "coin",
            "detail": {
                "amount": 1,
                "desc": "登录送金币"
            }
        }
    ]
 }
 */

@implementation CEELoginAwardsResponse
@end


@implementation CEELoginAwardsAPI

- (AnyPromise *)fetchLoginAwards {
    NSString * url = @"/api/v1/login_awards/";
    
    return [self promisePOST:url withParams:nil].then(^(CEELoginAwardsResponse * response) {
        return response.awards;
    });
}

- (Class)responseSuccessClass {
    return [CEELoginAwardsResponse class];
}

@end
