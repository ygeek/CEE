//
//  CEEFollowFriendAPI.h
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"


@interface CEEFollowFriendsRequest : JSONModel
@property (nonatomic, strong) NSNumber * id;
@end


@interface CEEFollowFriendAPI : CEEBaseAPI

- (AnyPromise *)followFriendWithID:(NSNumber *)id;

@end
