//
//  CEEFriendInfo.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "CEEMedal.h"

@protocol CEEJSONFriendInfo <NSObject>
@end

@interface CEEJSONFriendInfo : JSONModel
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString<Optional> * nickname;
@property (nonatomic, strong) NSNumber * coin;
@property (nonatomic, strong) NSNumber * medals;
@property (nonatomic, strong) NSString<Optional> * head_img_key;
@property (nonatomic, strong) NSNumber * finish_maps;
@property (nonatomic, strong) NSString<Optional> * comment;
@end
