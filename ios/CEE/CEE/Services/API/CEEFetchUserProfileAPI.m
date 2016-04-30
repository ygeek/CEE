//
//  CEEFetchUserProfileAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEFetchUserProfileAPI.h"

@implementation CEEFetchUserProfileResponse
@end


@implementation CEEFetchUserProfileAPI

- (AnyPromise *)fetchUserProfile {
    return [self promiseGET:@"/api/v1/userprofile/" withParams:nil].then(^(CEEFetchUserProfileResponse * response) {
        return response.profile;
    });
}

- (Class)responseSuccessClass {
    return [CEEFetchUserProfileResponse class];
}

@end
