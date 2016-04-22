//
//  CEERegisterAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import JSONModel;

#import "CEEBaseAPI.h"


@interface CEERegisterRequest : JSONModel
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString<Optional> * mobile;
@end


@interface CEERegisterSuccessResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * auth;
@end


@interface CEERegisterErrorResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEERegisterAPI : CEEBaseAPI

- (RACSignal *)registerWithMobile:(NSString *)mobile
                         password:(NSString *)password;

@end
