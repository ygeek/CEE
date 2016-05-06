//
//  CEELocationManager.h
//  CEE
//
//  Created by Meng on 16/4/21.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import PromiseKit;
@import UIKit;

#import "CEEMap.h"
#import "CEEAnchor.h"


#define CEE_LOCATION_ERROR_DOMAIN       @"CEE_LOCATION_ERROR_DOMAIN"
#define CEEFoundNewMapNotificationName  @"CEE_FOUND_NEW_MAP"
#define CEENewMapKey                    @"CEE_NEW_MAP"


@class TLCity;


@interface CEELocationManager : NSObject

+ (instancetype)manager;

- (AnyPromise *)getLocation;

- (TLCity *)getCityWithName:(NSString *)cityName;

- (AnyPromise *)queryNearestMap;

- (AnyPromise *)fetchNearestMap;

- (AnyPromise *)loadAcquiredMaps;

- (void)startMonitoringLocationChanges;

- (void)stopMonitoringLocationChanges;

- (BOOL)openNavigationAppToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@property (nonatomic, strong) CEEJSONMap * currentMap;
@property (nonatomic, strong) NSArray<CEEJSONAnchor *> * currentAnchors;
@property (nonatomic, strong) CEEJSONMap * nearestMap;
@property (nonatomic, strong) NSMutableArray<CEEJSONMap *> * acquiredMaps;

@end
