//
//  CEELocationManager.h
//  CEE
//
//  Created by Meng on 16/4/21.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import PromiseKit;
@import UIKit;


#define CEE_LOCATION_ERROR_DOMAIN @"CEE_LOCATION_ERROR_DOMAIN"


@class TLCity;


@interface CEELocationManager : NSObject

+ (instancetype)manager;

- (AnyPromise *)getLocation;

- (TLCity *)getCityWithName:(NSString *)cityName;

@end
