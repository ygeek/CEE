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
#import "CEEDeviceTokenAPI.h"

#import "CEEAddFriendsAPI.h"
#import "CEEAddWeiboFriendsAPI.h"
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
    NSLog(@"auth token: %@", auth);
    [[CEEDatabase db] saveAuthToken:auth];
    self.authToken = auth;
    if (auth && auth.length > 0) {
        [[CEEAPIClient client].requestSerializer setValue:[NSString stringWithFormat:@"Token %@", auth]
                                       forHTTPHeaderField:@"Authorization"];
        
        [[CEEDeviceTokenAPI api] uploadDeviceToken:self.deviceToken installationId:self.installationId]
        .then(^(NSString * msg) {
            NSLog(@"upload device token: %@", msg);
        }).catch(^(NSError *error) {
            NSLog(@"upload device token error: %@", error);
        });
        
        return [self loadUserProfile].then(^{
            return [self addAddressBookFriends];
        }).then(^(NSNumber * addCount){
            if (addCount.integerValue > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCEEFriendsUpdatedNotificationName
                                                                    object:self
                                                                  userInfo:nil];
            }
        });
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
        return friends;
    });
}

- (void)onUnauthorized {
    self.authorizationFailed = YES;
}

- (AnyPromise *)addAddressBookFriends {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                resolve([self addFriendsFromAddressBook:addressBook]);
            });
        }];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        return [self addFriendsFromAddressBook:addressBook];
    } else {
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
            resolve([NSError errorWithDomain:kCEEErrorDomain
                                        code:-1
                                    userInfo:@{NSLocalizedDescriptionKey: @"没有获取通讯录权限"}]);
        }];
    }
}

- (AnyPromise *)addFriendsFromAddressBook:(ABAddressBookRef)addressBook {
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
    
    return [[CEEAddFriendsAPI api] addMobiles:mobiles];
}

- (AnyPromise *)addWeiboFriends {
    return [[CEESDKManager sharedInstance] requestWeiboFriends]
    .then(^(NSDictionary * friendsData) {
        return [[CEEAddWeiboFriendsAPI api] addWeiboFriends:@[]];
    });
}

@end
