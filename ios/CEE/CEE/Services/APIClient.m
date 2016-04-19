//
//  APIClient.m
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "APIClient.h"
#import "ServerConfig.h"
#import "JSONResponseSerializer.h"

@implementation APIClient

+ (instancetype)client {
    static dispatch_once_t onceToken;
    static APIClient * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:[ServerConfig config].serverAddress]];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [JSONResponseSerializer serializer];
    }
    return self;
}

@end
