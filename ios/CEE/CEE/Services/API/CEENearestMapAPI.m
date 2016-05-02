//
//  CEENearestMapAPI.m
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEENearestMapAPI.h"

@implementation CEENearestMapResponse
@end


@implementation CEENearestMapAPI

- (AnyPromise *)queryNearestMapWithLongitude:(CGFloat)longitude latitude:(CGFloat)latitude {
    NSString * url = [NSString stringWithFormat:@"/api/v1/map/nearest/%f,%f/", longitude, latitude];
    return [self promiseGET:url withParams:nil].then(^(CEENearestMapResponse * response) {
        return response.map;
    });
}

- (Class)responseSuccessClass {
    return [CEENearestMapResponse class];
}

@end
