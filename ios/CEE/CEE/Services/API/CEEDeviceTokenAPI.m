//
//  CEEDeviceTokenAPI.m
//  CEE
//
//  Created by Meng on 16/5/13.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEDeviceTokenAPI.h"


@implementation CEEDeviceTokenRequest
@end


@implementation CEEDeviceTokenAPI

- (AnyPromise *)uploadDeviceToken:(NSString *)deviceToken installationId:(NSString *)installationId {
    CEEDeviceTokenRequest * request = [[CEEDeviceTokenRequest alloc] init];
    request.device_token = deviceToken;
    request.installation_id = installationId;
    return [self promisePOST:@"/api/v1/devicetoken/" withRequest:request].then(^(CEEBaseResponse * response) {
        return response.msg;
    });
}

@end
