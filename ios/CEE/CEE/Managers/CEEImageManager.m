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

- (AnyPromise *)queryImageForKey:(NSString *)key {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:[self imageCacheKeyForKey:key] done:^(UIImage *image, SDImageCacheType cacheType) {
            resolve(image);
        }];
    }];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    [[SDImageCache sharedImageCache] storeImage:image forKey:[self imageCacheKeyForKey:key]];
}

@end
