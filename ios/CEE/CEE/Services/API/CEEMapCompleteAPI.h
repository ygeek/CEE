//
//  CEEMapCompleteAPI.h
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEAward.h"


@interface CEEMapCompleteResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONAward, Optional> * awards;
@end


@interface CEEMapCompleteAPI : CEEBaseAPI

- (AnyPromise *)completeMapWithID:(NSNumber *)mapID;

@end
