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
#import "CEEStoryItemsAPI.h"
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
    return PMKJoin(@[[self downloadLevelsWithStoryID:storyID],
                     [self downloadItemsWithStoryID:storyID]]);
}

- (AnyPromise *)downloadLevelsWithStoryID:(NSNumber *)storyID {
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

- (AnyPromise *)downloadItemsWithStoryID:(NSNumber *)storyID {
    return [[CEEStoryItemsAPI api] fetchItemsWithStoryID:storyID]
    .then(^(NSArray<CEEJSONItem *> * items) {
        NSMutableArray * downloadPromises = [NSMutableArray array];
        for (CEEJSONItem * item in items) {
            NSString * imgKey = [item.content objectForKey:@"icon"];
            if (imgKey) {
                [downloadPromises addObject:[[CEEImageManager manager] downloadImageForKey:imgKey]];
            }
        }
        return PMKJoin(downloadPromises).then(^{
            return items;
        });
    });
}

@end
