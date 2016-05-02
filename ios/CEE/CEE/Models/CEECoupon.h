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


@protocol CEEJSONCoupon <NSObject>
@end


@interface CEEJSONCoupon : JSONModel
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * image_key;
@property (nonatomic, strong) NSDictionary * desc;
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSNumber * consumed;
@end
