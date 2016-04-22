//
//  CEEUserSession.m
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Realm;
@import Realm_JSON;

#import "CEEUserSession.h"
#import "CEEDatabase.h"
#import "CEEAPIClient.h"
#import "CEEFetchUserProfileAPI.h"


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
        _isFetchingUserProfile = NO;
    }
    return self;
}

- (void)load {
    NSString * authToken = [[CEEDatabase db] loadAuthToken];
    [[self loggedInWithAuth:authToken] subscribeNext:^(CEEFetchUserProfileSuccessResponse *response){
        
    }];
}

- (RACSignal *)loggedInWithAuth:(NSString *)auth {
    [[CEEDatabase db] saveAuthToken:auth];
    self.authToken = auth;
    if (auth && auth.length > 0) {
        [[CEEAPIClient client].requestSerializer setValue:[NSString stringWithFormat:@"Token %@", auth]
                                       forHTTPHeaderField:@"Authorization"];

        return [self loadUserProfile];
    }
    return [RACSignal empty];
}

- (RACSignal *)loadUserProfile {
    self.isFetchingUserProfile = YES;
    RLMResults * result = [CEEUserProfile objectsWhere:@"token == %@", self.authToken];
    if (result.count > 0) {
        CEEUserProfile * userProfileModel = result.firstObject;
        NSError * error = nil;
        self.userProfile = [[CEEJSONUserProfile alloc] initWithDictionary:[userProfileModel JSONDictionary]
                                                                    error:&error];
        if (error) {
            NSLog(@"Load User Profile Error: %@", error);
        }
    }
    
    return [[[[[CEEFetchUserProfileAPI alloc] init] fetchUserProfile] doNext:^(CEEFetchUserProfileSuccessResponse * response){
        self.userProfile = response.profile;
        self.isFetchingUserProfile = NO;
    }] doError:^(NSError *error) {
        self.isFetchingUserProfile = NO;
    }];
}

@end
