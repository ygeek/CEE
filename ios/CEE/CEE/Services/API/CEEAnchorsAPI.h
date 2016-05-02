//
//  CEEAnchorsAPI.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEAnchor.h"

@interface CEEAnchorsResponse : CEEBaseResponse
@property (nonatomic, strong) NSArray<CEEJSONAnchor> * anchors;
@end


@interface CEEAnchorsAPI : CEEBaseAPI

- (AnyPromise *)fetchAnchorsWithMapID:(NSNumber *)mapID;

@end
