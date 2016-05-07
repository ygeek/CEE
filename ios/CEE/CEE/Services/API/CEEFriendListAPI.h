//
//  CEEFriendListAPI.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

#import "CEEFriendInfo.h"

@interface CEEFriendListResponse : CEEBaseResponse
@property (nonatomic, strong) NSNumber * num;
@property (nonatomic, strong) NSArray<CEEJSONFriendInfo> * friends;
@end


@interface CEEFriendListAPI : CEEBaseAPI

- (AnyPromise *)fetchFriendList;

@end
