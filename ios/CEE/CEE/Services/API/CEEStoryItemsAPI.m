//
//  CEEStoryItemsAPI.m
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEStoryItemsAPI.h"

@implementation CEEStoryItemsResponse

@end


@implementation CEEStoryItemsAPI

- (AnyPromise *)fetchItemsWithStoryID:(NSNumber *)storyID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/story/%@/item/", storyID];
    return [self promiseGET:url withParams:nil].then(^(CEEStoryItemsResponse * response) {
        return response.items;
    });
}

- (Class)responseSuccessClass {
    return [CEEStoryItemsResponse class];
}

@end
