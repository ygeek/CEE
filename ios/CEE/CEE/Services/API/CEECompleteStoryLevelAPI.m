//
//  CEECompleteStoryLevelAPI.m
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEECompleteStoryLevelAPI.h"

@implementation CEECompleteStoryLevelResponse
@end


@implementation CEECompleteStoryLevelAPI

- (AnyPromise *)completeStoryID:(NSNumber *)storyID withLevelID:(NSNumber *)levelID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/story/%@/level/%@/complete/",
                      storyID,
                      levelID];
    return [self promisePOST:url withParams:nil].then(^(CEECompleteStoryLevelResponse *response) {
        return response.awards;
    });
}

- (Class)responseSuccessClass {
    return [CEECompleteStoryLevelResponse class];
}

@end
