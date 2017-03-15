//
//  CEEImageManager.m
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import SDWebImage;

#import "CEEImageManager.h"
#import "CEEServerConfig.h"
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
    return [NSString stringWithFormat:@"%@%@", [[CEEServerConfig config] qiniuBucketDomain], key];
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

- (AnyPromise *)downloadImageForKey:(NSString *)key {
    return [[CEEDownloadURLAPI api] requestURLWithKey:key]
    .then(^(NSString *url) {
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
                                                            options:SDWebImageRetryFailed
                                                           progress:
             ^(NSInteger receivedSize, NSInteger expectedSize) {
                 NSLog(@"download image %@: %ld/%ld", key, (long)receivedSize, (long)expectedSize);
             } completed:
             ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                 resolve(image ?: error);
             }];
        }];
    });
}

- (AnyPromise *)downloadImageForURL:(NSString *)url {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
                                                        options:SDWebImageRetryFailed
                                                       progress:
         ^(NSInteger receivedSize, NSInteger expectedSize) {
             NSLog(@"download image %@: %ld/%ld", url, (long)receivedSize, (long)expectedSize);
         } completed:
         ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             resolve(image ?: error);
         }];
    }];
}

- (AnyPromise *)downloadHeadForUsername:(NSString *)username withURL:(NSString *)url {
    return [self downloadImageForURL:url].thenInBackground(^(UIImage * image) {
        NSString *filePath = [self headImagePathForUsername:username];
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        return image;
    });
}

- (UIImage *)checkHeadForUsername:(NSString *)username {
    NSString * filePath = [self headImagePathForUsername:username];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [UIImage imageWithContentsOfFile:filePath];
    } else {
        return nil;
    }
}

- (NSString *)headImagePathForUsername:(NSString *)username {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", username]];
}

@end
