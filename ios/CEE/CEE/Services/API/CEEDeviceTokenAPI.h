//
//  CEEDeviceTokenAPI.h
//  CEE
//
//  Created by Meng on 16/5/13.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"


@interface CEEDeviceTokenRequest : JSONModel
@property (nonatomic, strong) NSString * device_token;
@property (nonatomic, strong) NSString * installation_id;
@end


@interface CEEDeviceTokenAPI : CEEBaseAPI

- (AnyPromise *)uploadDeviceToken:(NSString *)deviceToken installationId:(NSString *)installationId;

@end
