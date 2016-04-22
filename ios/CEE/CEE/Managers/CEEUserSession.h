//
//  CEEUserSession.h
//  CEE
//
//  Created by Meng on 16/4/20.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEEUserSession : NSObject

+ (instancetype)session;

@property (nonatomic, copy) NSString * authToken;

- (void)loggedInWithAuth:(NSString *)auth;

@end
