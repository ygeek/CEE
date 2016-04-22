//
//  CEEUserProfile.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//


@import Realm;
@import JSONModel;


@interface CEEUserProfile : RLMObject
@property NSString * token;
@property NSString * username;
@property NSString * nickname;
@property NSString * head_img_key;
@property NSString * sex;
@property NSDate * birthday;
@property NSString * mobile;
@property NSString * location;
@end



@interface CEEJSONUserProfile : JSONModel
@property NSString * token;
@property NSString * username;
@property NSString * nickname;
@property NSString * head_img_key;
@property NSString * sex;
@property NSDate * birthday;
@property NSString * mobile;
@property NSString * location;
@end