//
//  CEEAcquiredMapsAPI.m
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEAcquiredMapsAPI.h"

@implementation CEEAcquiredMapsResponse

@end


@implementation CEEAcquiredMapsAPI

- (AnyPromise *)fetchAcquiredMaps {
    return [self promiseGET:@"/api/v1/map/acquired/" withParams:nil]
    .then(^(CEEAcquiredMapsResponse * response) {
        return response.maps;
    });
}

- (Class)responseSuccessClass {
    return [CEEAcquiredMapsResponse class];
}

@end
