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


@class TLCity;


@interface CEEMapManager : NSObject

+ (instancetype)manager;

- (AnyPromise *)getLocation;

- (TLCity *)getCityWithName:(NSString *)cityName;

- (void)startMonitoringLocationChanges;

- (void)stopMonitoringLocationChanges;

- (BOOL)openNavigationAppToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

#pragma mark - Nearest Map

- (AnyPromise *)queryNearestMap;

- (AnyPromise *)fetchNearestMap;

@property (nonatomic, strong) CEEJSONMap * nearestMap;

#pragma mark - Acquired Maps

- (AnyPromise *)loadAcquiredMaps;

- (AnyPromise *)fetchMapData:(CEEJSONMap *)map;

@property (nonatomic, strong) NSMutableArray<CEEJSONMap *> * acquiredMaps;

#pragma mark - Current Map

@property (nonatomic, strong) CEEJSONMap * currentMap;
@property (nonatomic, strong) NSArray<CEEJSONAnchor *> * currentAnchors;

@end
