//
//  CEELocationManager.m
//  CEE
//
//  Created by Meng on 16/4/21.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import CoreLocation;
@import MapKit;

#import <PromiseKit/PromiseKit.h>

#import "CEELocationManager.h"
#import "TLCity.h"
#import "CEENearestMapAPI.h"
#import "CEEImageManager.h"
#import "CEEAnchorsAPI.h"
#import "CEEAcquiredMapsAPI.h"

@interface CEELocationManager ()
@property (nonatomic, strong) NSMutableArray<TLCity *> * cities;
@property (nonatomic, strong) NSTimer * locatingTimer;
@end


@implementation CEELocationManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CEELocationManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cities = [[NSMutableArray alloc] init];
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
        for (NSDictionary *groupDic in array) {
            for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
                TLCity *city = [[TLCity alloc] init];
                city.cityID = [dic objectForKey:@"city_key"];
                city.cityName = [dic objectForKey:@"city_name"];
                city.shortName = [dic objectForKey:@"short_name"];
                city.pinyin = [dic objectForKey:@"pinyin"];
                city.initials = [dic objectForKey:@"initials"];
                [self.cities addObject:city];
            }
        }
    }
    return self;
}

- (AnyPromise *)getLocation {
    return [CLLocationManager promise].then(^(CLLocation * location) {
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        return [geocoder reverseGeocode:location];
    });
}

- (TLCity *)getCityWithName:(NSString *)cityName {
    for (TLCity * city in self.cities) {
        if ([city.cityName isEqualToString:cityName]) {
            return city;
        }
    }
    return nil;
}

- (AnyPromise *)queryNearestMap {
    return [CLLocationManager promise]
    .then(^(CLLocation * location) {
        return [[CEENearestMapAPI api] queryNearestMapWithLongitude:location.coordinate.longitude
                                                           latitude:location.coordinate.latitude];
    });
}

- (AnyPromise *)fetchNearestMap {
    return [self queryNearestMap]
    .then(^(CEEJSONMap * map) {
        return [[CEEImageManager manager] downloadImageForKey:map.image_key].then(^(UIImage *image) {
            return map;
        });
    }).then(^(CEEJSONMap * map) {
        return [[CEEAnchorsAPI api] fetchAnchorsWithMapID:map.id]
        .then(^(NSArray<CEEJSONAnchor *> *anchors) {
            self.currentMap = map;
            self.currentAnchors = anchors;
            return PMKManifold(map, anchors);
        });
    });
}

- (AnyPromise *)loadAcquiredMaps {
    return [[CEEAcquiredMapsAPI api] fetchAcquiredMaps]
    .then(^(NSArray<CEEJSONMap *> * maps) {
        self.acquiredMaps = [maps mutableCopy];
        return maps;
    });
}

- (BOOL)checkIfNewMap:(CEEJSONMap *)map {
    for (CEEJSONMap * oldMap in self.acquiredMaps) {
        if ([oldMap.id isEqualToNumber:map.id]) {
            return NO;
        }
    }
    return YES;
}

- (void)startMonitoringLocationChanges {
    if (self.locatingTimer) {
        [self stopMonitoringLocationChanges];
    }
    self.locatingTimer = [NSTimer scheduledTimerWithTimeInterval:300
                                                          target:self
                                                        selector:@selector(updateLocationFired:)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)stopMonitoringLocationChanges {
    [self.locatingTimer invalidate];
    self.locatingTimer = nil;
}

- (void)updateLocationFired:(NSTimer *)timer {
    [self queryNearestMap].then(^(CEEJSONMap * map) {
        NSLog(@"nearest map: %@", map.name);
        self.nearestMap = map;
        if (!self.acquiredMaps) {
            [self loadAcquiredMaps].then(^{
                return [self checkIfNewMap:map];
            }).then(^(NSNumber * isNewMap) {
                if (isNewMap.boolValue) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:CEEFoundNewMapNotificationName
                                                                        object:self
                                                                      userInfo:@{CEENewMapKey: map}];
                }
            });
        } else {
            if ([self checkIfNewMap:map]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:CEEFoundNewMapNotificationName
                                                                    object:self
                                                                  userInfo:@{CEENewMapKey: map}];
            }
        }
    }).catch(^(NSError *error) {
        NSLog(@"query nearest map failed: %@", error);
    });
}

@end
