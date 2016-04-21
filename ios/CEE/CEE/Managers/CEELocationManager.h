//
//  CEELocationManager.h
//  CEE
//
//  Created by Meng on 16/4/21.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@import ReactiveCocoa;

#define CEE_LOCATION_ERROR_DOMAIN @"CEE_LOCATION_ERROR_DOMAIN"


@interface CEELocationManager : NSObject

+ (instancetype)manager;

- (RACSignal *)getLocations;

@end
