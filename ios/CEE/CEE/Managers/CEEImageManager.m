//
//  CEEImageManager.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import SDWebImage;

#import "CEEImageManager.h"
#import "ServerConfig.h"
#import "CEEDownloadURLAPI.h"

@implementation CEEImageManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CEEImageManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    SDWebImageManager.sharedManager.cacheKeyFilter = ^(NSURL * url) {
        url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
        return [url absoluteString];
    };
}

- (NSString *)imageCacheKeyForKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@%@", [[ServerConfig config] qiniuBucketDomain], key];
}

- (RACSignal *)privateDownloadURLForKey:(NSString *)key {
    return [[[[CEEDownloadURLAPI alloc] init] requestURLWithKey:key] map:^(CEEDownloadURLSuccessResponse * response) {
        return response.private_url;
    }];
}

- (RACSignal *)queryImageForKey:(NSString *)key {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:[self imageCacheKeyForKey:key] done:^(UIImage *image, SDImageCacheType cacheType) {
            [subscriber sendNext:image];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    [[SDImageCache sharedImageCache] storeImage:image forKey:[self imageCacheKeyForKey:key]];
}

@end
