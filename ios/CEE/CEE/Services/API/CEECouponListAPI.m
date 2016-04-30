//
//  CEECouponListAPI.m
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEECouponListAPI.h"

@implementation CEECouponListResponse

@end


@implementation CEECouponListAPI

- (AnyPromise *)fetchCouponList {
    return [self promiseGET:@"/api/v1/coupon/" withParams:nil].then(^(CEECouponListResponse *response){
        return response.coupons;
    });
}

- (Class)responseSuccessClass {
    return [CEECouponListResponse class];
}

@end
