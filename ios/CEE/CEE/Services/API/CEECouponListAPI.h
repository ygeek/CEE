//
//  CEECouponListAPI.h
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEECoupon.h"


@interface CEECouponListResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEECoupon *> * coupons;
@end


@interface CEECouponListAPI : CEEBaseAPI

- (AnyPromise *)fetchCouponList;

@end
