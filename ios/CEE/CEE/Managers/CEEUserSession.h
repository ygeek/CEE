//
//  CEEUserSession.h
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CEEUserProfile.h"


@interface CEEUserSession : NSObject

+ (instancetype)session;

@property (nonatomic, copy) NSString * authToken;

@property (nonatomic, strong) CEEJSONUserProfile * userProfile;

- (void)load;

- (void)loggedInWithAuth:(NSString *)auth;

@end
