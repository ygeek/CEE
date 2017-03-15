//
//  CEEMessagesManager.h
//  CEE
//
//  Created by Meng on 16/5/8.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PromiseKit;


#import "CEEMessage.h"
#import "CEEMap.h"
#import "CEEStory.h"


@interface CEEMessagesManager : NSObject

+ (instancetype)manager;

- (AnyPromise *)loadLocalMessages;

- (AnyPromise *)fetchMessages;

- (AnyPromise *)markReadWithMessageID:(NSNumber *)messageID;

- (void)notifyNewMap:(CEEJSONMap *)map;

- (void)completeMapWithID:(NSNumber *)mapID;

- (void)notifyRunningStory:(CEEJSONStory *)story;

- (void)completeStoryWithID:(NSNumber *)storyID;

@property (nonatomic, strong) NSMutableArray<CEEJSONMessage *> * messages;

@property (nonatomic, assign) NSInteger unreadCount;

@end
