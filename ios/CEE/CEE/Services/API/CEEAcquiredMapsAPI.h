//
//  CEEAcquiredMapsAPI.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEMap.h"


@interface CEEAcquiredMapsResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONMap> * maps;
@end


@interface CEEAcquiredMapsAPI : CEEBaseAPI

- (AnyPromise *)fetchAcquiredMaps;

@end
