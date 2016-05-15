//
//  CEEUserInfo.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "CEEMedal.h"

@interface CEEJSONUserInfo : JSONModel
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * coin;
@property (nonatomic, strong) NSArray<CEEJSONMedal> * medals;
@property (nonatomic, strong) NSString<Optional> * head_img_key;
@property (nonatomic, strong) NSNumber * friend_num;
@property (nonatomic, strong) NSNumber * finish_maps;
@end
