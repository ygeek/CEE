//
//  CEEAddFriendsAPI.h
//  CEE
//
//  Created by Meng on 16/5/9.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEFriendInfo.h"


@interface CEECheckFriendsRequest : JSONModel
@property (nonatomic, strong) NSString * mobiles;
@end


@interface CEECheckFriendsResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONFriendInfo> * friends;
@end


@interface CEECheckFriendsAPI : CEEBaseAPI

- (AnyPromise *)checkMobiles:(NSArray<NSString *> *)mobiles;

@end
