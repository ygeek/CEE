//
//  CEEMessage.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Realm/Realm.h>


@import JSONModel;


@interface CEEMessage : RLMObject
@property NSNumber<RLMInt> * id;
@property NSString * username;
@property NSString * type;
@property NSNumber<RLMInt> * timestamp;
@property NSString * text;
@property NSNumber<RLMBool> * unread;
@property NSNumber<RLMInt> * story_id;
@property NSNumber<RLMInt> * map_id;
@property NSNumber<RLMInt> * coupon_id;
@property NSNumber<RLMBool> * is_local;
@end


@protocol CEEJSONMessage <NSObject>
@end


@interface CEEJSONMessage : JSONModel
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSNumber * timestamp;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSNumber * unread;
@property (nonatomic, strong) NSNumber<Optional> * story_id;
@property (nonatomic, strong) NSNumber<Optional> * map_id;
@property (nonatomic, strong) NSNumber<Optional> * coupon_id;
@property (nonatomic, strong) NSNumber<Optional> * is_local;
@end
