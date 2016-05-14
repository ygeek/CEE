//
//  CEEStoryCompleteAPI.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEETask.h"
#import "CEEAward.h"


@interface CEEStoryCompleteResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONAward> * awards;
@end


@interface CEEStoryCompleteAPI : CEEBaseAPI

- (AnyPromise *)completeStoryID:(NSNumber *)storyID;

@end
