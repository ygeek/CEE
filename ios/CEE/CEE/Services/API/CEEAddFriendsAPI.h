//
//  CEEAddFriendsAPI.h
//  CEE
//
//  Created by Meng on 16/5/9.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"


@interface CEEAddFriendsRequest : JSONModel
@property (nonatomic, strong) NSString * mobiles;
@end


@interface CEEAddFriendsResponse : CEEBaseResponse
@property (nonatomic, strong) NSNumber * num;
@end


@interface CEEAddFriendsAPI : CEEBaseAPI

- (AnyPromise *)addMobiles:(NSArray<NSString *> *)mobiles;

@end
