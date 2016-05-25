//
//  CEESearchFriendAPI.h
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEFriendInfo.h"

@interface CEESearchFriendsRequest : JSONModel
@property (nonatomic, strong) NSString * query;
@end


@interface CEESearchFriendsResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONFriendInfo> * friends;
@end


@interface CEESearchFriendAPI : CEEBaseAPI

- (AnyPromise *)queryFriends:(NSString *)query;

@end
