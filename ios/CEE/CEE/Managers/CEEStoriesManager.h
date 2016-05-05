//
//  CEEStoriesManager.h
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import PromiseKit;

#import <Foundation/Foundation.h>

@interface CEEStoriesManager : NSObject

+ (instancetype)manager;

- (AnyPromise *)downloadStoryWithID:(NSNumber *)storyID;

@end
