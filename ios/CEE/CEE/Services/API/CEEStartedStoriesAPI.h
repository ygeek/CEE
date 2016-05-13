//
//  CEEStartedStoriesAPI.h
//  CEE
//
//  Created by Meng on 16/5/13.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEStory.h"


@interface CEEStartedStoriesResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONStory> * stories;
@end


@interface CEEStartedStoriesAPI : CEEBaseAPI

- (AnyPromise *)fetchStartedStories;

@end
