//
//  CEEFetchUserProfileAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"


@interface CEEFetchUserProfileSuccessResponse : CEEBaseResponse
@property (nonatomic, strong) NSDictionary * profile;
@end


@interface CEEFetchUserProfileErrorResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEEFetchUserProfileAPI : CEEBaseAPI

- (RACSignal *)fetchUserProfile;

@end
