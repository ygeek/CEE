//
//  CEEUserInfoAPI.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"
#import "CEEUserInfo.h"

@interface CEEUserInfoResponse : CEEBaseResponse
@property (nonatomic, strong) CEEJSONUserInfo * userInfo;
@end


@interface CEEUserInfoAPI : CEEBaseAPI

- (AnyPromise *)fetchUserInfo;

@end
