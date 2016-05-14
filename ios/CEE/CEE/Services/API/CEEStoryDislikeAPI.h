//
//  CEEStoryDislikeAPI.h
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

@interface CEEStoryDislikeAPI : CEEBaseAPI

- (AnyPromise *)dislikeStoryWithID:(NSNumber *)storyID;

@end
