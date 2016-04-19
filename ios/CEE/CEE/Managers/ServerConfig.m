//
//  ServerConfig.m
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "ServerConfig.h"

@implementation ServerConfig

+ (instancetype)config {
    static dispatch_once_t onceToken;
    static ServerConfig * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)serverAddress {
#if DEBUG
    return @"http://127.0.0.1:8000";
#else
    return @"http://101.201.48.167";
#endif
}

@end
