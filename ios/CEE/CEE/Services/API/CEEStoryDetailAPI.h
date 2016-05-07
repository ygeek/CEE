//
//  CEEStoryDetailAPI.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEStory.h"


@interface CEEStoryDetailResponse : CEEBaseResponse
@property (nonatomic, strong) CEEJSONStory * story;
@end


@interface CEEStoryDetailAPI : CEEBaseAPI

- (AnyPromise *)fetchDetailWithStoryID:(NSNumber *)storyID;

@end
