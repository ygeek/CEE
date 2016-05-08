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


@implementation CEEMessagesManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CEEMessagesManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
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
    NSNumber * timestamp = [[CEEMessage objectsWhere:@"username == %@",
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
    
    return [[CEEMessageReadAPI api] markReadWithMessageID:messageID];
}

@end
