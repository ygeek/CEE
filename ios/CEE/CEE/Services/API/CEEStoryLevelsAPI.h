//
//  CEEStoryLevelsAPI.h
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEStory.h"


@interface CEEStoryLevelsResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONLevel> * levels;
@end


@interface CEEStoryLevelsAPI : CEEBaseAPI

- (AnyPromise *)fetchLevelsWithStoryID:(NSNumber *)storyID;

@end
