//
//  CEEDatabase.m
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEDatabase.h"


NSString * const kAuthTokenKey = @"AUTH_TOKEN";


@implementation CEEDatabase

+ (instancetype)db {
    static dispatch_once_t onceToken;
    static CEEDatabase * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)saveAuthToken:(NSString *)authToken {
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:kAuthTokenKey];
}

- (NSString *)loadAuthToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAuthTokenKey];
}

@end
