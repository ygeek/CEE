//
//  CEEDownloadURLAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEDownloadURLAPI.h"

@implementation CEEDownloadURLRequest
@end


@implementation CEEDownloadURLSuccessResponse
@end


@implementation CEEDownloadURLErrorResponse
@end


@implementation CEEDownloadURLAPI

- (RACSignal *)requestURLWithKey:(NSString *)key {
    NSString * url = [NSString stringWithFormat:@"/api/v1/downloadurl/%@/", key];
    return [self GET:url withParams:nil];
}

- (Class)responseSuccessClass {
    return [CEEDownloadURLSuccessResponse class];
}

- (Class)responseErrorClass {
    return [CEEDownloadURLErrorResponse class];
}

@end
