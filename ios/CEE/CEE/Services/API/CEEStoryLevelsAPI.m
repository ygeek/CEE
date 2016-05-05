//
//  CEEStoryLevelsAPI.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEStoryLevelsAPI.h"


@implementation CEEStoryLevelsResponse
@end


@implementation CEEStoryLevelsAPI

- (AnyPromise *)fetchLevelsWithStoryID:(NSNumber *)storyID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/story/%@/level/", storyID];
    return [self promiseGET:url withParams:nil].then(^(CEEStoryLevelsResponse * response) {
        return response.levels;
    });
}

- (Class)responseSuccessClass {
    return [CEEStoryLevelsResponse class];
}

@end
