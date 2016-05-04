//
//  CEEMedalListAPI.h
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

#import "CEEMedal.h"

@interface CEEMedalListResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONMedal> * medals;
@end


@interface CEEMedalListAPI : CEEBaseAPI

- (AnyPromise *)fetchMedals;

@end
