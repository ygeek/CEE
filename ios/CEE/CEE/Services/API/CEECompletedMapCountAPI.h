//
//  CEECompletedMapCountAPI.h
//  CEE
//
//  Created by Meng on 16/5/13.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"


@interface CEECompletedMapCountResponse : CEEBaseResponse
@property (nonatomic, strong) NSNumber * count;
@end


@interface CEECompletedMapCountAPI : CEEBaseAPI

- (AnyPromise *)fetchCompletedMapCount;

@end
