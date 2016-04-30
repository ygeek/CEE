//
//  CEEStoryListAPI.m
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEStoryListAPI.h"

@implementation CEEStoryListResponse

@end


@implementation CEEStoryListAPI

- (AnyPromise *)fetchStoriesWithCityKey:(NSString *)cityKey {
    NSString * url = [NSString stringWithFormat:@"/api/v1/city/%@/story/", cityKey];
    return [self promiseGET:url withParams:nil].then(^(CEEStoryListResponse *response) {
        return response.storys;
    });
}

- (Class)responseSuccessClass {
    return [CEEStoryListResponse class];
}

@end
