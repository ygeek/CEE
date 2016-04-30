//
//  CEEStoryListAPI.h
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEStory.h"


@interface CEEStoryListResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONStory *> * storys;
@end


@interface CEEStoryListAPI : CEEBaseAPI

- (AnyPromise *)fetchStoriesWithCityKey:(NSString *)cityKey;

@end
