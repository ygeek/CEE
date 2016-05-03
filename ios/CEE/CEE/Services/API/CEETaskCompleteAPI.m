//
//  CEETaskCompleteAPI.m
//  CEE
//
//  Created by Meng on 16/5/3.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEETaskCompleteAPI.h"


@implementation CEETaskCompleteResponse
@end


@implementation CEETaskCompleteAPI

- (AnyPromise *)completeTaskWithID:(NSNumber *)taskID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/task/%@/complete/", taskID];
    return [self promisePOST:url withParams:nil].then(^(CEETaskCompleteResponse *response) {
        return PMKManifold(response.awards, response.image_key);
    });
}

- (Class)responseSuccessClass {
    return [CEETaskCompleteResponse class];
}

@end
