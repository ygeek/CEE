//
//  CEEDatabase.h
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CEEUserProfile.h"

@interface CEEDatabase : NSObject

+ (instancetype)db;

- (void)saveAuthToken:(NSString *)authToken username:(NSString *)username platform:(NSString *)platform;

- (void)clearAuthToken;

- (NSString *)loadAuthToken;

- (NSString *)loadUsername;

- (NSString *)loadPlatform;

- (BOOL)splashShowed;

- (void)setSplashShowed:(BOOL)showed;

@end
