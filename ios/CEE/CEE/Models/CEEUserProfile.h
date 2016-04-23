//
//  CEEUserProfile.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString<Optional> * nickname;
@property (nonatomic, strong) NSString<Optional> * head_img_key;
@property (nonatomic, strong) NSString<Optional> * sex;
@property (nonatomic, strong) NSDate<Optional> * birthday;
@property (nonatomic, strong) NSString<Optional> * mobile;
@property (nonatomic, strong) NSString<Optional> * location;
@end