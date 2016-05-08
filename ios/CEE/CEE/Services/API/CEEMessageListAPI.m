//
//  CEEMessageListAPI.m
//  CEE
//
//  Created by Meng on 16/5/8.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEMessageListAPI.h"


@implementation CEEMessageResponse

@end


@implementation CEEMessageListAPI

- (AnyPromise *)fetchMessagesFromTimestamp:(NSNumber *)timestamp {
    NSString * url = [NSString stringWithFormat:@"/api/v1/messages/%ld/", timestamp.integerValue];
    return [self promiseGET:url withParams:nil].then(^(CEEMessageResponse *response) {
        return response.messages;
    });
}

- (Class)responseSuccessClass {
    return [CEEMessageResponse class];
}

@end
