//
//  CEEUploadTokenAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEUploadTokenAPI.h"

@implementation CEEUploadTokenSuccessResponse
@end


@implementation CEEUploadTokenErrorResponse
@end


@implementation CEEUploadTokenAPI

- (RACSignal *)requestUploadToken {
    return [self GET:@"/api/v1/uploadtoken/" withParams:nil];
}

- (Class)responseSuccessClass {
    return [CEEUploadTokenSuccessResponse class];
}

- (Class)responseErrorClass {
    return [CEEUploadTokenErrorResponse class];
}

@end
