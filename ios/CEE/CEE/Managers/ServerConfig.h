//
//  ServerConfig.h
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConfig : NSObject

+ (instancetype)config;

- (NSString *)serverAddress;

@end
