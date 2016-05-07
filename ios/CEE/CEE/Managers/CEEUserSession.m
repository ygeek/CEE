//
//  CEEUserSession.m
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Realm;
@import Realm_JSON;
@import ReactiveCocoa;

#import "CEEUserSession.h"
#import "CEEDatabase.h"
#import "CEEAPIClient.h"
#import "CEEFetchUserProfileAPI.h"
#import "CEEFriendListAPI.h"


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
        _authorizationFailed = NO;
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, isFetchingUserProfile),
                                   RACObserve(self, authorizationFailed)]
                          reduce:^(NSNumber *isFetchingUserProfile, NSNumber * authorizationFailed) {
                              return @(!(isFetchingUserProfile.boolValue) && authorizationFailed.boolValue);
                          }] subscribeNext:^(NSNumber *shouldRelogin) {
                              @strongify(self)
                              if (shouldRelogin.boolValue) {
                                  [[CEEDatabase db] clearAuthToken];
                                  self.authToken = nil;
                                  self.userProfile = nil;
                                  self.authorizationFailed = NO;
                                  [[CEEAPIClient client].requestSerializer clearAuthorizationHeader];
                              }
                          }];
    }
    return self;
}

- (void)load {
    NSString * authToken = [[CEEDatabase db] loadAuthToken];
    [self loggedInWithAuth:authToken];
}

- (AnyPromise *)loggedInWithAuth:(NSString *)auth {
    [[CEEDatabase db] saveAuthToken:auth];
    self.authToken = auth;
    if (auth && auth.length > 0) {
        [[CEEAPIClient client].requestSerializer setValue:[NSString stringWithFormat:@"Token %@", auth]
                                       forHTTPHeaderField:@"Authorization"];

        return [self loadUserProfile];
    } else {
        [[CEEAPIClient client].requestSerializer clearAuthorizationHeader];
        return [AnyPromise promiseWithValue:nil];
    }
}

- (AnyPromise *)loadUserProfile {
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
    
    return [[[CEEFetchUserProfileAPI alloc] init] fetchUserProfile]
    .then(^(CEEJSONUserProfile * profile) {
        self.userProfile = profile;
        
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [CEEUserProfile createOrUpdateInRealm:realm
                           withJSONDictionary:self.userProfile.toDictionary];
        [realm commitWriteTransaction];
        return self.userProfile;
    }).catch(^(NSError *error) {
        NSLog(@"Fetch User profile Error: %@", error);
    }).finally(^{
        self.isFetchingUserProfile = NO;
    });
}

- (AnyPromise *)loadFriends {
    return [[CEEFriendListAPI api] fetchFriendList].then(^(NSArray *friends){
        self.friends = friends;
    });
}

- (void)onUnauthorized {
    self.authorizationFailed = YES;
}

@end
