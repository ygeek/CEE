//
//  CEEUploadTokenAPI.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEUploadTokenAPI.h"

@implementation CEEUploadTokenResponse
@end


@implementation CEEUploadTokenAPI

- (AnyPromise *)requestUploadToken {
    return [self promiseGET:@"/api/v1/uploadtoken/" withParams:nil].then(^(CEEUploadTokenResponse * response) {
        return response.upload_token;
    });
}

- (Class)responseSuccessClass {
    return [CEEUploadTokenResponse class];
}

@end
