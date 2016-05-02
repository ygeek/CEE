//
//  CEECouponConsumeAPI.m
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEECouponConsumeAPI.h"


@implementation CEECouponConsumeRequest
@end


@implementation CEECouponConsumeAPI

- (AnyPromise *)consumeUUID:(NSString *)uuid withCode:(NSString *)code {
    CEECouponConsumeRequest * request = [[CEECouponConsumeRequest alloc] init];
    request.code = code;
    NSString * url = [NSString stringWithFormat:@"/api/v1/coupon/%@/consume/", uuid];
    return [self promisePOST:url withRequest:request].then(^(CEEBaseResponse *response) {
        return response.msg;
    });
}

@end
