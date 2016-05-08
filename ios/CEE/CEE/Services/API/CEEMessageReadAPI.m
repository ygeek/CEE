//
//  CEEMessageReadAPI.m
//  CEE
//
//  Created by Meng on 16/5/8.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEMessageReadAPI.h"


@implementation CEEMessageReadAPI

- (AnyPromise *)markReadWithMessageID:(NSNumber *)messageID {
    NSString * url = [NSString stringWithFormat:@"/api/v1/message/%@/read/", messageID];
    return [self promisePOST:url withParams:nil];
}

@end
