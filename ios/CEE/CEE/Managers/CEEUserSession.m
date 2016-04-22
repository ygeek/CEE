//
//  CEEUserSession.m
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEUserSession.h"
#import "CEEDatabase.h"
#import "CEEAPIClient.h"


@implementation CEEUserSession

+ (instancetype)session {
    static dispatch_once_t onceToken;
    static CEEUserSession * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.authToken = [[CEEDatabase db] loadAuthToken];
    }
    return self;
}

- (void)loggedInWithAuth:(NSString *)auth {
    [[CEEDatabase db] saveAuthToken:auth];
    [CEEUserSession session].authToken = auth;
    [[CEEAPIClient client].requestSerializer setValue:[NSString stringWithFormat:@"Token %@", auth]
                                   forHTTPHeaderField:@"Authorization"];
}

@end
