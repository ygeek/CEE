//
//  CEEStoryItemsAPI.h
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEStory.h"

@interface CEEStoryItemsResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONItem> * items;
@end


@interface CEEStoryItemsAPI : CEEBaseAPI

- (AnyPromise *)fetchItemsWithStoryID:(NSNumber *)storyID;

@end
