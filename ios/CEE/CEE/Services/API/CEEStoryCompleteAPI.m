//
//  CEEStoryCompleteAPI.m
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEStoryCompleteAPI.h"


@implementation CEEStoryCompleteResponse
@end


@implementation CEEStoryCompleteAPI

- (AnyPromise *)completeStoryID:(NSNumber *)storyID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/story/%@/complete/", storyID];
    return [self promisePOST:url withParams:nil].then(^(CEEStoryCompleteResponse * response) {
        return response.awards;
    });
}

- (Class)responseSuccessClass {
    return [CEEStoryCompleteResponse class];
}

@end
