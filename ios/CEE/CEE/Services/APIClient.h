//
//  APIClient.h
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface APIClient : AFHTTPSessionManager

+ (instancetype)client;

@end
