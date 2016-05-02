//
//  CEETaskAPI.m
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEETaskAPI.h"


@implementation CEETaskResponse

@end


@implementation CEETaskAPI

- (AnyPromise *)fetchTaskWithID:(NSNumber *)taskID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/task/%@/", taskID];
    return [self promiseGET:url withParams:nil].then(^(CEETaskResponse * response) {
        return response.task;
    });
}

- (Class)responseSuccessClass {
    return [CEETaskResponse class];
}

@end
