//
//  SDKManager.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>

#import "SDKManager.h"

@implementation SDKManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SDKManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // TODO: init something
    }
    return self;
}

- (void)setup {
    [self setupAVOS];
}

- (void)setupAVOS {
    [AVOSCloudCrashReporting enable];
    
    [AVOSCloud setApplicationId:@"zbamEfqUbNTXNwLKw8LiTPK0-gzGzoHsz"
                      clientKey:@"nWuVXVcpDSr4Eu3DHJqqSDyY"];
    
}

@end
