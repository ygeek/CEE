//
//  CEEImageManager.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import ReactiveCocoa;

#import <Foundation/Foundation.h>

@interface CEEImageManager : NSObject

+ (instancetype)manager;

- (RACSignal *)privateDownloadURLForKey:(NSString *)key;

- (NSString *)imageCacheKeyForKey:(NSString *)key;

- (RACSignal *)queryImageForKey:(NSString *)key;

- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

@end
