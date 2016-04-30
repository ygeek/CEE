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

- (void)saveAuthToken:(NSString *)authToken;

- (void)clearAuthToken;

- (NSString *)loadAuthToken;

@end
