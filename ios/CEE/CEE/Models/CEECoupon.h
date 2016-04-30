//
//  CEEJSONCoupon.h
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Realm;
@import JSONModel;


@interface CEECoupon : RLMObject
@property NSString * uuid;
@property NSData * coupon;
@property NSNumber<RLMBool> * consumed;
@end


@interface CEEJSONCouponDetail : JSONModel
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDictionary * desc;
@property (nonatomic, strong) NSString * code;
@end


@interface CEEJSONCoupon : JSONModel
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) CEEJSONCouponDetail * coupon;
@property (nonatomic, strong) NSNumber * consumed;
@end
