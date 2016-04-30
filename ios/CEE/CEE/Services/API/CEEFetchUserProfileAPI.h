//
//  CEEFetchUserProfileAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEUserProfile.h"

@interface CEEFetchUserProfileResponse : CEEBaseResponse
@property (nonatomic, strong) CEEJSONUserProfile * profile;
@end


@interface CEEFetchUserProfileAPI : CEEBaseAPI

- (AnyPromise *)fetchUserProfile;

@end
