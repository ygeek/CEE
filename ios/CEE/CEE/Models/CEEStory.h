//
//  CEEJSONStory.h
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "CEECity.h"

@interface CEEJSONStory : JSONModel
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSNumber * time;
@property (nonatomic, strong) NSNumber * good;
@property (nonatomic, strong) NSNumber * distance;
@property (nonatomic, strong) NSNumber * coin;
@property (nonatomic, strong) NSArray<NSString *> * image_keys;
@property (nonatomic, strong) NSString * tour_img_key;
@end
