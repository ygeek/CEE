//
//  CEEMapCompleteAPI.m
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEMapCompleteAPI.h"


@implementation CEEMapCompleteResponse

@end


@implementation CEEMapCompleteAPI

- (AnyPromise *)completeMapWithID:(NSNumber *)mapID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/map/%@/complete/", mapID];
    return [self promisePOST:url withParams:nil].then(^(CEEMapCompleteResponse * response) {
        return response.awards;
    });
}

- (AnyPromise *)completeMapWithStoryID:(NSNumber *)storyID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/story/%@/complete-map/", storyID];
    return [self promisePOST:url withParams:nil].then(^(CEEMapCompleteResponse * response) {
        return response.awards;
    });
}

- (Class)responseSuccessClass {
    return [CEEMapCompleteResponse class];
}

@end
