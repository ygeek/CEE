//
//  CEECouponConsumeAPI.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"


@interface CEECouponConsumeRequest : JSONModel
@property (nonatomic, strong) NSString * code;
@end


@interface CEECouponConsumeAPI : CEEBaseAPI

- (AnyPromise *)consumeUUID:(NSString *)uuid withCode:(NSString *)code;

@end
