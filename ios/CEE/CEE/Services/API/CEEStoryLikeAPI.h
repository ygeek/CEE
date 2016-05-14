//
//  CEEStoryLikeAPI.h
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

@interface CEEStoryLikeAPI : CEEBaseAPI

- (AnyPromise *)likeStoryWithID:(NSNumber *)storyID;

@end
