//
//  CEELoginAwardAPI.h
//  CEE
//
//  Created by Meng on 16/7/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEAward.h"



@interface CEELoginAwardsResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONAward> * awards;
@end


@interface CEELoginAwardsAPI : CEEBaseAPI

- (AnyPromise *)fetchLoginAwards;

@end
