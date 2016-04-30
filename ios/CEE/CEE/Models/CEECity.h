//
//  CEECity.h
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CEEJSONCity : JSONModel
@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * initials;
@property (nonatomic, strong) NSString * pinyin;
@property (nonatomic, strong) NSString * short_name;
@end
