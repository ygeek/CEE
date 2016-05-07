//
//  CEEStoryDetailAPI.m
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEStoryDetailAPI.h"


@implementation CEEStoryDetailResponse

@end


@implementation CEEStoryDetailAPI

- (AnyPromise *)fetchDetailWithStoryID:(NSNumber *)storyID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/story/%@/", storyID];
    return [self promiseGET:url withParams:nil].then(^(CEEStoryDetailResponse * response) {
        return response.story;
    });
}

- (Class)responseSuccessClass {
    return [CEEStoryDetailResponse class];
}

@end
