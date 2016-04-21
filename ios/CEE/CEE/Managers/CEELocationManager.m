//
//  CEELocationManager.m
//  CEE
//
//  Created by Meng on 16/4/21.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import CoreLocation;
@import MapKit;

#import "CEELocationManager.h"
#import "TLCity.h"

@interface CEELocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) RACSignal * currentSignal;
@property (nonatomic, strong) id<RACSubscriber> currentSubscriber;
@property (nonatomic, strong) NSMutableArray<TLCity *> * cities;
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
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startMonitoringSignificantLocationChanges];
        
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

- (RACSignal *)getLocations {
    if (!self.currentSignal) {
        @weakify(self)
        self.currentSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            self.currentSubscriber = subscriber;
            [self.locationManager startUpdatingLocation];
            return nil;
        }] replay];
    }
    return self.currentSignal;
}

- (TLCity *)getCityWithName:(NSString *)cityName {
    for (TLCity * city in self.cities) {
        if ([city.cityName isEqualToString:cityName]) {
            return city;
        }
    }
    return nil;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count == 0) {
        return;
    }
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray<CLPlacemark *> * placemarks, NSError * error) {
        if (placemarks.count == 0 && error == nil) {
            [self.currentSubscriber sendError:[NSError errorWithDomain:CEE_LOCATION_ERROR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey: @"未获取有效位置"}]];
        } else if (error) {
            [self.currentSubscriber sendError:error];
        } else {
            [self.currentSubscriber sendNext:placemarks];
            [self.currentSubscriber sendCompleted];
            self.currentSubscriber = nil;
            self.currentSignal = nil;
        }
    }];
    [self.locationManager stopUpdatingLocation];
}


@end
