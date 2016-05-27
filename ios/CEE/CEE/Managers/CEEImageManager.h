//
//  CEEImageManager.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import UIKit;
@import PromiseKit;

@interface CEEImageManager : NSObject

+ (instancetype)manager;

- (NSString *)imageCacheKeyForKey:(NSString *)key;

- (AnyPromise *)queryImageForKey:(NSString *)key;

- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

- (AnyPromise *)downloadImageForKey:(NSString *)key;

- (AnyPromise *)downloadImageForURL:(NSString *)url;

- (AnyPromise *)downloadHeadForUsername:(NSString *)username withURL:(NSString *)url;

- (UIImage *)checkHeadForUsername:(NSString *)username;

- (NSString *)headImagePathForUsername:(NSString *)username;

@end
