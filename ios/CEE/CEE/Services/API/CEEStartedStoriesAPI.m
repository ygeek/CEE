//
//  CEEStartedStoriesAPI.m
//  CEE
//
//  Created by Meng on 16/5/13.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEStartedStoriesAPI.h"


@implementation CEEStartedStoriesResponse

@end


@implementation CEEStartedStoriesAPI

- (AnyPromise *)fetchStartedStories {
    return [self promiseGET:@"/api/v1/story/started/" withParams:nil].then(^(CEEStartedStoriesResponse * response) {
        return response.stories;
    });
}

- (Class)responseSuccessClass {
    return [CEEStartedStoriesResponse class];
}

@end
