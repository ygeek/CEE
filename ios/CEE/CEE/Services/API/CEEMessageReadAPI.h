//
//  CEEMessageReadAPI.h
//  CEE
//
//  Created by Meng on 16/5/8.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"


@interface CEEMessageReadAPI : CEEBaseAPI

- (AnyPromise *)markReadWithMessageID:(NSNumber *)messageID;

@end
