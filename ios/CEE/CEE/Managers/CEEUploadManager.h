//
//  CEEUploadManager.h
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import PromiseKit;

#import <UIKit/UIKit.h>

@interface CEEUploadManager : NSObject

+ (instancetype)manager;

- (AnyPromise *)uploadData:(NSData *)data;

- (AnyPromise *)uploadPNG:(UIImage *)image;

- (AnyPromise *)uploadJPEG:(UIImage *)image;

@end
