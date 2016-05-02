//
//  CEENearestMapAPI.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEMap.h"


@interface CEENearestMapResponse : CEEBaseResponse
@property (nonatomic, strong) CEEJSONMap * map;
@end


@interface CEENearestMapAPI : CEEBaseAPI

- (AnyPromise *)queryNearestMapWithLongitude:(CGFloat)longitude latitude:(CGFloat)latitude;

@end
