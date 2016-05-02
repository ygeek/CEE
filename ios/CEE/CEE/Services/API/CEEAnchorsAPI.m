//
//  CEEAnchorsAPI.m
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEAnchorsAPI.h"


@implementation CEEAnchorsResponse
@end


@implementation CEEAnchorsAPI

- (AnyPromise *)fetchAnchorsWithMapID:(NSNumber *)mapID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/map/%@/anchor/", mapID];
    return [self promiseGET:url withParams:nil].then(^(CEEAnchorsResponse * response) {
        return response.anchors;
    });
}

- (Class)responseSuccessClass {
    return [CEEAnchorsResponse class];
}

@end
