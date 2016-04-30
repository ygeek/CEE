//
//  CEEUploadManager.m
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Qiniu;

#import "CEEUploadManager.h"
#import "UIImage+Utils.h"
#import "CEEUploadTokenAPI.h"

@implementation CEEUploadManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CEEUploadManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (AnyPromise *)uploadData:(NSData *)data {
    return [[CEEUploadTokenAPI api] requestUploadToken]
    .then(^(NSString * uploadToken) {
        return [self uploadData:data withToken:uploadToken];
    });
}

- (AnyPromise *)uploadPNG:(UIImage *)image {
    return [self uploadData:UIImagePNGRepresentation(image)];
}

- (AnyPromise *)uploadJPEG:(UIImage *)image {
    return [self uploadData:UIImageJPEGRepresentation(image, 0.8)];
}

- (AnyPromise *)uploadData:(NSData *)data withToken:(NSString *)uploadToken {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        QNUploadManager * upManager = [[QNUploadManager alloc] init];
        [upManager putData:data
                       key:nil
                     token:uploadToken
                  complete:
        ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.error) {
                resolve(info.error);
            } else {
                resolve(resp[@"key"]);
            }
        } option:nil];
    }];
}

@end
