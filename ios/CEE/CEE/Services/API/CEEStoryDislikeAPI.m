//
//  CEEStoryDislikeAPI.m
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEStoryDislikeAPI.h"

@implementation CEEStoryDislikeAPI

- (AnyPromise *)dislikeStoryWithID:(NSNumber *)storyID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/story/%@/dislike/", storyID];
    return [self promisePOST:url withParams:nil];
}

@end
