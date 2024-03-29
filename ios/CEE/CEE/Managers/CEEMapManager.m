//
//  CEELocationManager.m
//  CEE
//
//  Created by Meng on 16/4/21.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import CoreLocation;
@import MapKit;

@import PromiseKit;

#import "CEEMapManager.h"
#import "TLCity.h"
#import "CEENearestMapAPI.h"
#import "CEEImageManager.h"
#import "CEEAnchorsAPI.h"
#import "CEEAcquiredMapsAPI.h"
#import "CEEMessagesManager.h"
#import "CEEUserSession.h"
#import "CEENotificationNames.h"

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
        // 保存 Device 的现语言 (英语 法语 ，，，)
        NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                                objectForKey:@"AppleLanguages"];
        // 强制 成 简体中文
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                                  forKey:@"AppleLanguages"];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        return [geocoder reverseGeocode:location].then(^(CLPlacemark * placemark, NSArray<CLPlacemark *> * placemarks) {
            // 还原Device 的语言
            [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
            return PMKManifold(placemark, placemarks);
        });
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
    }).catch(^(NSError *error){
        NSLog(@"location error: %@", error);
        return [[CEENearestMapAPI api] queryNearestMapWithLongitude:116.31
                                                           latitude:38.99];
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
    if ([self openBaiduNavigationToLatitude:latitude longitude:longitude]) {
        return YES;
    }
    if ([self openGaodeNavigationToLatitude:latitude longitude:longitude]) {
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
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (BOOL)openBaiduNavigationToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=walking&coord_type=gcj02",
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEFoundNewMapNotificationName
                                                                        object:self
                                                                      userInfo:@{kCEENewMapKey: map}];
                }
            });
        } else {
            if ([self checkIfNewMap:map]) {
                [self.acquiredMaps addObject:map];
                [[NSNotificationCenter defaultCenter] postNotificationName:kCEEFoundNewMapNotificationName
                                                                    object:self
                                                                  userInfo:@{kCEENewMapKey: map}];
                [[CEEMessagesManager manager] notifyNewMap:map];
            }
        }
    }).catch(^(NSError *error) {
        NSLog(@"query nearest map failed: %@", error);
    });
}

@end
