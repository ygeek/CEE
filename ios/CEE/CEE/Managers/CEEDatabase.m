//
//  CEEDatabase.m
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEDatabase.h"


NSString * const kAuthTokenKey = @"AUTH_TOKEN";
NSString * const kUsernameKey = @"USERNAME";
NSString * const kPlatformKey = @"PLATFORM";
NSString * const kSplashShowedKey = @"SPLASH_SHOWED";


@implementation CEEDatabase

+ (instancetype)db {
    static dispatch_once_t onceToken;
    static CEEDatabase * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)saveAuthToken:(NSString *)authToken username:(NSString *)username platform:(NSString *)platform {
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:kAuthTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUsernameKey];
    [[NSUserDefaults standardUserDefaults] setObject:platform forKey:kPlatformKey];
}

- (void)clearAuthToken {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kAuthTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUsernameKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPlatformKey];
}

- (NSString *)loadAuthToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAuthTokenKey];
}

- (NSString *)loadUsername {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUsernameKey];
}

- (NSString *)loadPlatform {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPlatformKey];
}

- (BOOL)splashShowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSplashShowedKey];
}

- (void)setSplashShowed:(BOOL)showed {
    [[NSUserDefaults standardUserDefaults] setBool:showed forKey:kSplashShowedKey];
}

@end
