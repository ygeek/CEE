//
//  CEEStoryLikeAPI.m
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEStoryLikeAPI.h"

@implementation CEEStoryLikeAPI

- (AnyPromise *)likeStoryWithID:(NSNumber *)storyID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/story/%@/like/", storyID];
    return [self promisePOST:url withParams:nil];
}

@end
