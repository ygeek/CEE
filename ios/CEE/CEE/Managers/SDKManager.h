//
//  SDKManager.h
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKManager : NSObject

+ (instancetype)sharedInstance;

- (void)setup;

- (void)loginQQ;

- (void)loginWeixin;

- (void)loginWeibo;

- (void)addAddressBookFriends;

@end
