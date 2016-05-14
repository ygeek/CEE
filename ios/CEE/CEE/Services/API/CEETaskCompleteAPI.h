//
//  CEETaskCompleteAPI.h
//  CEE
//
//  Created by Meng on 16/5/3.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEETask.h"
#import "CEEAward.h"


@interface CEETaskCompleteResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * image_key;
@property (nonatomic, strong) NSArray<CEEJSONAward> * awards;
@end


@interface CEETaskCompleteAPI : CEEBaseAPI

- (AnyPromise *)completeTaskWithID:(NSNumber *)taskID;

@end
