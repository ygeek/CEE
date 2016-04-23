//
//  CEELoginAPI.h
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import JSONModel;

#import "CEEBaseAPI.h"


@interface CEELoginRequest: JSONModel
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;
@end


@interface CEELoginSuccessResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * auth;
@end


@interface CEELoginErrorResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEELoginAPI : CEEBaseAPI

- (AnyPromise *)loginWithUsername:(NSString *)username password:(NSString *)password;

@end
