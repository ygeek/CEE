//
//  CEERegisterAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import JSONModel;
@import PromiseKit;

#import "CEEBaseAPI.h"


@interface CEERegisterRequest : JSONModel
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString<Optional> * mobile;
@end


@interface CEERegisterResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * auth;
@end


@interface CEERegisterAPI : CEEBaseAPI

- (AnyPromise *)registerWithMobile:(NSString *)mobile
                          password:(NSString *)password;

@end
