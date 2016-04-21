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

@interface CEELocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) RACSignal * currentSignal;
@property (nonatomic, strong) id<RACSubscriber> currentSubscriber;
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
