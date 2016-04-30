//
//  CEEUserProfileAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEESaveUserProfileAPI.h"

@implementation CEESaveUserProfileRequest
@end


@implementation CEESaveUserProfileAPI

- (AnyPromise *)saveUserProfile:(CEESaveUserProfileRequest *)request {
    return [self promisePOST:@"/api/v1/userprofile/" withRequest:request];
}

@end
