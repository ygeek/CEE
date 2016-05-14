//
//  CEEAward.h
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface CEEJSONAward : JSONModel
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSDictionary * detail;
@end


@protocol CEEJSONAward <NSObject>
@end
