//
//  CEECompletedMapCountAPI.m
//  CEE
//
//  Created by Meng on 16/5/13.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEECompletedMapCountAPI.h"


@implementation CEECompletedMapCountResponse

@end


@implementation CEECompletedMapCountAPI

- (AnyPromise *)fetchCompletedMapCount {
    return [self promiseGET:@"/api/v1/map/completed/count/" withParams:nil]
    .then(^(CEECompletedMapCountResponse * response) {
        return response.count;
    });
}

- (Class)responseSuccessClass {
    return [CEECompletedMapCountResponse class];
}

@end
