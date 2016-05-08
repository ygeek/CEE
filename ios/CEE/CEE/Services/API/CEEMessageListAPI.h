//
//  CEEMessageListAPI.h
//  CEE
//
//  Created by Meng on 16/5/8.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEMessage.h"


@interface CEEMessageResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONMessage> * messages;
@end


@interface CEEMessageListAPI : CEEBaseAPI

- (AnyPromise *)fetchMessagesFromTimestamp:(NSNumber *)timestamp;

@end
