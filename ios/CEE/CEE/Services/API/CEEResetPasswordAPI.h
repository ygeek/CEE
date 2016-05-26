//
//  CEEResetPasswordAPI.h
//  CEE
//
//  Created by Meng on 16/5/26.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>

#import "CEEBaseAPI.h"

@interface CEEResetPasswordRequest : JSONModel
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * code;
@end


@interface CEEResetPasswordResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * auth;
@end


@interface CEEResetPasswordAPI : CEEBaseAPI

- (AnyPromise *)resetUsername:(NSString *)username password:(NSString *)password code:(NSString *)code;

@end
