//
//  CEEStoriesManager.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>

#import "CEEStoriesManager.h"
#import "CEEStoryLevelsAPI.h"
#import "CEEImageManager.h"


@implementation CEEStoriesManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CEEStoriesManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (AnyPromise *)downloadStoryWithID:(NSNumber *)storyID {
    return [[CEEStoryLevelsAPI api] fetchLevelsWithStoryID:storyID]
    .then(^(NSArray<CEEJSONLevel *> * levels) {
        NSMutableArray * downloadPromises = [NSMutableArray array];
        for (CEEJSONLevel * level in levels) {
            NSString * imgKey = [level.content objectForKey:@"img"];
            if (imgKey) {
                [downloadPromises addObject:[[CEEImageManager manager] downloadImageForKey:imgKey]];
            }
        }
        return PMKJoin(downloadPromises).then(^{
            return levels;
        });
    });
}

@end
