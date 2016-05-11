//
//  CEEMessagesManager.m
//  CEE
//
//  Created by Meng on 16/5/8.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Realm;
@import Realm_JSON;

#import "CEEMessagesManager.h"
#import "CEEUserSession.h"
#import "CEEMessageListAPI.h"
#import "CEEMessageReadAPI.h"
#import "CEENotificationNames.h"


@implementation CEEMessagesManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CEEMessagesManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storyCompletedNotification:)
                                                     name:kCEEStoryCompleteNotificationName
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mapCompletedNotification:)
                                                     name:kCEEMapCompleteNotificationName
                                                   object:nil];
    }
    return self;
}

- (AnyPromise *)loadLocalMessages {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            RLMResults * results = [[CEEMessage objectsWhere:@"username == %@", [CEEUserSession session].userProfile.username] sortedResultsUsingProperty:@"timestamp" ascending:NO];
            NSMutableArray<CEEJSONMessage *> * messages = [NSMutableArray array];
            for (CEEMessage * rlmMessage in results) {
                NSError * error = nil;
                CEEJSONMessage * jsonMessage =
                [[CEEJSONMessage alloc] initWithDictionary:[rlmMessage JSONDictionary]
                                                     error:&error];
                if (error) {
                    NSLog(@"Load Message error: %@", error);
                }
                [messages addObject:jsonMessage];
            }
            resolve(messages);
        });
    }];
}

- (AnyPromise *)fetchMessages {
    NSNumber * timestamp = [[CEEMessage objectsWhere:@"username == %@ && is_local != YES",
                             [CEEUserSession session].userProfile.username]
                            maxOfProperty:@"timestamp"] ?: @(0);
    return [[CEEMessageListAPI api] fetchMessagesFromTimestamp:timestamp]
    .thenInBackground(^(NSArray<CEEJSONMessage *> * messages) {
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (CEEJSONMessage * jsonMessage in messages) {
            CEEMessage * rlmMessage = [CEEMessage createOrUpdateInRealm:realm
                                                     withJSONDictionary:jsonMessage.toDictionary];
            rlmMessage.username = [CEEUserSession session].userProfile.username;
        }
        [realm commitWriteTransaction];
    }).then(^{
        return [self loadLocalMessages];
    }).then(^(NSMutableArray<CEEJSONMessage *> * messages) {
        self.messages = messages;
        self.unreadCount = [[messages valueForKeyPath:@"@sum.unread"] integerValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCEEMessagesUpdatedNotificationName
                                                            object:self
                                                          userInfo:nil];
        
        return messages;
    });
}

- (AnyPromise *)markReadWithMessageID:(NSNumber *)messageID {
    for (CEEJSONMessage * jsonMsg in self.messages) {
        if ([jsonMsg.id isEqualToNumber:messageID]) {
            jsonMsg.unread = @(NO);
        }
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    CEEMessage * message = [CEEMessage objectForPrimaryKey:messageID];
    message.unread = @(NO);
    [realm commitWriteTransaction];
    
    self.unreadCount = [[self.messages valueForKeyPath:@"@sum.unread"] integerValue];
    
    if (messageID.integerValue < 0) {
        return [AnyPromise promiseWithValue:nil];
    } else {
        return [[CEEMessageReadAPI api] markReadWithMessageID:messageID];
    }
}

- (void)notifyNewMap:(CEEJSONMap *)map {
    for (CEEJSONMessage * msg in self.messages) {
        if ([msg.map_id isEqualToNumber:map.id]) {
            return;
        }
    }
    
    CEEJSONMessage * msg = [[CEEJSONMessage alloc] init];
    msg.id = @([[[CEEMessage allObjects] minOfProperty:@"id"] integerValue] - 1);
    msg.type = @"attention";
    msg.timestamp = @((NSInteger)[[NSDate date] timeIntervalSince1970]);
    msg.text = [NSString stringWithFormat:@"发现在您周边的城市彩蛋《%@》，马上开始体验吧！", map.name];
    msg.unread = @(YES);
    msg.map_id = map.id;
    msg.is_local = @(YES);
    
    [self.messages addObject:msg];
    
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    CEEMessage * message = [CEEMessage createOrUpdateInRealm:realm
                                           withJSONDictionary:msg.toDictionary];
    message.username = [CEEUserSession session].userProfile.username;
    [realm commitWriteTransaction];
    
    self.unreadCount = [[self.messages valueForKeyPath:@"@sum.unread"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEMessagesUpdatedNotificationName
                                                        object:self
                                                      userInfo:nil];
}

- (void)completeMapWithID:(NSNumber *)mapID {
    NSMutableArray * existingJSON = [NSMutableArray array];
    for (CEEJSONMessage * msg in self.messages) {
        if ([msg.map_id isEqualToNumber:mapID]) {
            [existingJSON addObject:msg];
        }
    }
    [self.messages removeObjectsInArray:existingJSON];
    
    RLMResults * existing = [CEEMessage objectsWhere:@"map_id == %@", mapID];
    if (existing && existing.count > 0) {
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:existing];
        [realm commitWriteTransaction];
    }
    
    self.unreadCount = [[self.messages valueForKeyPath:@"@sum.unread"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEMessagesUpdatedNotificationName
                                                        object:self
                                                      userInfo:nil];
}

- (void)notifyRunningStory:(CEEJSONStory *)story {
    for (CEEJSONMessage * msg in self.messages) {
        if ([msg.story_id isEqualToNumber:story.id]) {
            return;
        }
    }
    
    CEEJSONMessage * msg = [[CEEJSONMessage alloc] init];
    msg.id = @([[[CEEMessage allObjects] minOfProperty:@"id"] integerValue] - 1);
    msg.type = @"story";
    msg.timestamp = @((NSInteger)[[NSDate date] timeIntervalSince1970]);
    msg.text = [NSString stringWithFormat:@"《%@》任务正在进行中...", story.name];
    msg.unread = @(YES);
    msg.story_id = story.id;
    msg.is_local = @(YES);
    
    [self.messages addObject:msg];
    
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    CEEMessage * message = [CEEMessage createOrUpdateInRealm:realm
                                           withJSONDictionary:msg.toDictionary];
    message.username = [CEEUserSession session].userProfile.username;
    [realm commitWriteTransaction];
    
    self.unreadCount = [[self.messages valueForKeyPath:@"@sum.unread"] integerValue];

    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEMessagesUpdatedNotificationName
                                                        object:self
                                                      userInfo:nil];
}

- (void)completeStoryWithID:(NSNumber *)storyID {
    NSMutableArray * existingJSON = [NSMutableArray array];
    for (CEEJSONMessage * msg in self.messages) {
        if ([msg.story_id isEqualToNumber:storyID]) {
            [existingJSON addObject:msg];
        }
    }
    [self.messages removeObjectsInArray:existingJSON];
    
    RLMResults * existing = [CEEMessage objectsWhere:@"story_id == %@", storyID];
    
    if (existing && existing.count > 0 ) {
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:existing];
        [realm commitWriteTransaction];
    }
    
    self.unreadCount = [[self.messages valueForKeyPath:@"@sum.unread"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCEEMessagesUpdatedNotificationName
                                                        object:self
                                                      userInfo:nil];
}

- (void)storyCompletedNotification:(NSNotification *)notification {
    CEEJSONStory * story = notification.userInfo[kCEEStoryCompleteStoryKey];
    [self completeStoryWithID:story.id];
}

- (void)mapCompletedNotification:(NSNotification *)notification {
    CEEJSONMap * map = notification.userInfo[kCEEMapCompleteMapKey];
    [self completeMapWithID:map.id];
}

@end
