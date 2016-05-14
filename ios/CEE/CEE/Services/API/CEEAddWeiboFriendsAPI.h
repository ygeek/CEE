//
//  CEEAddWeiboFriendsAPI.h
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

@interface CEEAddWeiboFriendsRequest : JSONModel
@property (nonatomic, strong) NSString * uids;
@end


@interface CEEAddWeiboFriendsResponse: CEEBaseResponse
@property (nonatomic, strong) NSNumber * num;
@end


@interface CEEAddWeiboFriendsAPI : CEEBaseAPI

- (AnyPromise *)addWeiboFriends:(NSArray<NSString *> *)uids;

@end
