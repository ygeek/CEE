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
@end


@protocol CEEJSONMessage <NSObject>
@end


@interface CEEJSONMessage : JSONModel
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSNumber * timestamp;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSNumber * unread;
@end
