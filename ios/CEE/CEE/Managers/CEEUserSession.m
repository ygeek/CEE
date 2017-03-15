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

#import <AddressBook/AddressBook.h>

#import "CEEUserSession.h"
#import "CEEDatabase.h"
#import "CEEAPIClient.h"
#import "CEEFetchUserProfileAPI.h"
#import "CEEFriendListAPI.h"
#import "CEEFollowFriendAPI.h"
#import "CEEDeviceTokenAPI.h"

#import "CEECheckFriendsAPI.h"
#import "CEECheckWeiboFriendsAPI.h"
#import "CEENotificationNames.h"
#import "CEESDKManager.h"


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
                                  self.username = nil;
                                  self.userProfile = nil;
                                  self.authorizationFailed = NO;
                                  [[CEEAPIClient client].requestSerializer clearAuthorizationHeader];
                              }
                          }];
    }
    return self;
}

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = [deviceToken copy];
    if (deviceToken && deviceToken.length > 0 &&
        self.authToken && self.authToken.length > 0) {
        [[CEEDeviceTokenAPI api] uploadDeviceToken:deviceToken installationId:self.installationId]
        .then(^(NSString * msg) {
            NSLog(@"upload device token %@: %@", deviceToken, msg);
        }).catch(^(NSError *error) {
            NSLog(@"upload device token error: %@", error);
        });
    }
}

- (void)setInstallationId:(NSString *)installationId {
    _installationId = [installationId copy];
    if (self.deviceToken && self.deviceToken.length > 0 &&
        self.authToken && self.authToken.length > 0) {
        [[CEEDeviceTokenAPI api] uploadDeviceToken:self.deviceToken installationId:installationId]
        .then(^(NSString * msg) {
            NSLog(@"upload device token %@: %@", self.deviceToken, msg);
        }).catch(^(NSError *error) {
            NSLog(@"upload device token error: %@", error);
        });
    }
}

- (void)load {
    NSString * authToken = [[CEEDatabase db] loadAuthToken];
    NSString * username = [[CEEDatabase db] loadUsername];
    NSString * platform = [[CEEDatabase db] loadPlatform];
    [self loggedInWithAuth:authToken username:username platform:platform];
}

- (AnyPromise *)loggedInWithAuth:(NSString *)auth username:(NSString *)username platform:(NSString *)platform {
    NSLog(@"auth token: %@", auth);
    [[CEEDatabase db] saveAuthToken:auth username:username platform:platform];
    self.authToken = auth;
    self.username = username;
    if (auth && auth.length > 0) {
        [[CEEAPIClient client].requestSerializer setValue:[NSString stringWithFormat:@"Token %@", auth]
                                       forHTTPHeaderField:@"Authorization"];
        
        if (auth && auth.length > 0 &&
            self.deviceToken && self.deviceToken.length > 0) {
            [[CEEDeviceTokenAPI api] uploadDeviceToken:self.deviceToken installationId:self.installationId]
            .then(^(NSString * msg) {
                NSLog(@"upload device token: %@", msg);
            }).catch(^(NSError *error) {
                NSLog(@"upload device token error: %@", error);
            });
        }
        
        return [self loadUserProfile];
        /*
        .then(^{
            return [self addAddressBookFriends];
        }).then(^(NSNumber * addCount){
            if (addCount.integerValue > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCEEFriendsUpdatedNotificationName
                                                                    object:self
                                                                  userInfo:nil];
            }
        });
         */
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
    }).always(^{
        self.isFetchingUserProfile = NO;
    });
}

- (AnyPromise *)loadFriends {
    return [[CEEFriendListAPI api] fetchFriendList].then(^(NSArray *friends){
        self.friends = friends;
        return friends;
    });
}

- (void)onUnauthorized {
    self.authorizationFailed = YES;
}

- (AnyPromise *)checkAddressBookFriends {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                resolve([self checkFriendsFromAddressBook:addressBook]);
            });
        }];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        return [self checkFriendsFromAddressBook:addressBook];
    } else {
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
            resolve([NSError errorWithDomain:kCEEErrorDomain
                                        code:-1
                                    userInfo:@{NSLocalizedDescriptionKey: @"没有获取通讯录权限"}]);
        }];
    }
}

- (AnyPromise *)checkFriendsFromAddressBook:(ABAddressBookRef)addressBook {
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSMutableArray * mobiles = [NSMutableArray array];
    for ( int i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++) {
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            if ([personPhone hasPrefix:@"+86"]) {
                personPhone = [personPhone substringFromIndex:3];
            }
            personPhone = [[personPhone componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
            NSLog(@"phone: %@", personPhone);
            [mobiles addObject:personPhone];
        }
    }
    
    return [[CEECheckFriendsAPI api] checkMobiles:mobiles];
}

- (AnyPromise *)checkWeiboFriends {
    return [[CEESDKManager sharedInstance] requestWeiboFriends]
    .then(^(NSDictionary * friendsData) {
        return [[CEECheckWeiboFriendsAPI api] checkWeiboFriends:@[]];
    });
}

- (AnyPromise *)addWeiboFriends {
    return [[CEESDKManager sharedInstance] requestWeiboFriends]
    .then(^(NSDictionary * friendsData) {
        return [[CEEAddWeiboFriendsAPI api] addWeiboFriends:@[]];
    });
}

- (AnyPromise *)followFriend:(NSNumber *)uid {
    return [[CEEFollowFriendAPI api] followFriendWithID:uid];
}

@end
