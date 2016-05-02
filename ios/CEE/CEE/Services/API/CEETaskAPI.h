//
//  CEETaskAPI.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

#import "CEETask.h"


@interface CEETaskResponse : CEEBaseResponse
@property (nonatomic, strong) CEEJSONTask * task;
@end


@interface CEETaskAPI : CEEBaseAPI

- (AnyPromise *)fetchTaskWithID:(NSNumber *)taskID;

@end
