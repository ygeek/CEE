//
//  CEECompleteStoryLevelAPI.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEETask.h"


@interface CEECompleteStoryLevelResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONAward> * awards;
@end


@interface CEECompleteStoryLevelAPI : CEEBaseAPI

- (AnyPromise *)completeStoryID:(NSNumber *)storyID withLevelID:(NSNumber *)levelID;

@end
