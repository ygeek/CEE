//
//  CEEMessagesManager.h
//  CEE
//
//  Created by Meng on 16/5/8.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>


#import "CEEMessage.h"


@interface CEEMessagesManager : NSObject

+ (instancetype)manager;

- (AnyPromise *)loadLocalMessages;

- (AnyPromise *)fetchMessages;

- (AnyPromise *)markReadWithMessageID:(NSNumber *)messageID;

@property (nonatomic, strong) NSMutableArray<CEEJSONMessage *> * messages;

@property (nonatomic, assign) NSInteger unreadCount;

@end
