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


@implementation CEEDownloadURLResponse
@end


@implementation CEEDownloadURLAPI

- (AnyPromise *)requestURLWithKey:(NSString *)key {
    NSString * url = [NSString stringWithFormat:@"/api/v1/downloadurl/%@/", key];
    return [self promiseGET:url withParams:nil].then(^(CEEDownloadURLResponse * response) {
        return response.private_url;
    });
}

- (Class)responseSuccessClass {
    return [CEEDownloadURLResponse class];
}

@end
