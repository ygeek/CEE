//
//  ServerConfig.h
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEEServerConfig : NSObject

+ (instancetype)config;

- (NSString *)serverAddress;

- (NSString *)qiniuBucketDomain;

@end
