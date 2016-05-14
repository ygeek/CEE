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

#import "CEEMapManager.h"
#import "TLCity.h"
#import "CEENearestMapAPI.h"
#import "CEEImageManager.h"
#import "CEEAnchorsAPI.h"
#import "CEEAcquiredMapsAPI.h"
#import "CEEMessagesManager.h"
#import "CEEUserSession.h"

@interface CEEMapManager ()
@property (nonatomic, strong) NSMutableArray<TLCity *> * cities;
@property (nonatomic, strong) NSTimer * locatingTimer;
@end


@implementation CEEMapManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CEEMapManager * instance = nil;
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

- (AnyPromise *)fetchMapData:(CEEJSONMap *)map {
    return [[CEEImageManager manager] downloadImageForKey:map.image_key]
    .then(^(UIImage *image) {
        return map;
    }).then(^(CEEJSONMap * map) {
        return [[CEEAnchorsAPI api] fetchAnchorsWithMapID:map.id];
    }).then(^(NSArray<CEEJSONAnchor *> *anchors) {
        self.currentMap = map;
        self.currentAnchors = anchors;
        return PMKManifold(map, anchors);
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

- (BOOL)openNavigationAppToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    if ([self openGaodeNavigationToLatitude:latitude longitude:longitude]) {
        return YES;
    }
    if ([self openBaiduNavigationToLatitude:latitude longitude:longitude]) {
        return YES;
    }
    if ([self openGoogleNavigationToLatitude:latitude longitude:longitude]) {
        return YES;
    }
    if ([self openAppleNavigationToLatitude:latitude longitude:longitude]) {
        return YES;
    }
    return NO;
}

- (BOOL)openAppleNavigationToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    return [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (BOOL)openBaiduNavigationToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",
                            coordinate.latitude,
                            coordinate.longitude]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (BOOL)openGaodeNavigationToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",
                            @"城市彩蛋",
                            @"cee://",
                            coordinate.latitude,
                            coordinate.longitude]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (BOOL)openGoogleNavigationToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",
                            @"城市彩蛋",
                            @"cee://",
                            latitude,
                            longitude]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)updateLocationFired:(NSTimer *)timer {
    if (![CEEUserSession session].authToken) {
        return;
    }
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
                [self.acquiredMaps addObject:map];
                [[NSNotificationCenter defaultCenter] postNotificationName:CEEFoundNewMapNotificationName
                                                                    object:self
                                                                  userInfo:@{CEENewMapKey: map}];
                [[CEEMessagesManager manager] notifyNewMap:map];
            }
        }
    }).catch(^(NSError *error) {
        NSLog(@"query nearest map failed: %@", error);
    });
}

@end
