//
//  CEEBaseAPI.m
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import AFNetworking;

#import "CEEBaseAPI.h"
#import "CEEAPIClient.h"


@implementation CEEBaseResponse
@end


@implementation CEEBaseAPI

- (RACSignal *)GET:(NSString *)url withParams:(NSDictionary *)params {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask =
        [[CEEAPIClient client] GET:url
                        parameters:params
                          progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              [subscriber sendNext:responseObject];
                              [subscriber sendCompleted];
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              [subscriber sendError:error];
                          }];
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] flattenMap:^RACStream *(id responseObject) {
        return [self responseSignalWithObject:responseObject];
    }];
}

- (RACSignal *)GET:(NSString *)url withRequest:(JSONModel *)request {
    return [self GET:url withParams:request.toDictionary];
}

- (RACSignal *)POST:(NSString *)url withParams:(NSDictionary *)params {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionTask * dataTask =
        [[CEEAPIClient client] POST:url
                         parameters:params
                           progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               [subscriber sendNext:responseObject];
                               [subscriber sendCompleted];
                           }
                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               [subscriber sendError:error];
                           }];
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] flattenMap:^RACStream *(id responseObject) {
        return [self responseSignalWithObject:responseObject];
    }];
}

- (RACSignal *)POST:(NSString *)url withRequest:(JSONModel *)request {
    return [self POST:url withParams:request.toDictionary];
}

- (Class)responseSuccessClass {
    return nil;
}

- (Class)responseErrorClass {
    return nil;
}

- (RACSignal *)responseSignalWithObject:(id)responseObject {
    NSError * jsonError = nil;
    CEEBaseResponse * baseResponse = [[CEEBaseResponse alloc] initWithDictionary:responseObject error:&jsonError];
    if (jsonError) {
        return [RACSignal error:[self packJSONError:jsonError errorObject:responseObject]];
    }
    
    if (baseResponse.code != 0) {
        if (self.responseErrorClass != nil) {
            id errorResponse = [[self.responseErrorClass alloc] initWithDictionary:responseObject error:&jsonError];
            if (jsonError) {
                return [RACSignal error:[self packJSONError:jsonError errorObject:responseObject]];
            } else {
                return [RACSignal error:[NSError errorWithDomain:CEE_API_ERROR_DOMAIN
                                                            code:baseResponse.code
                                                        userInfo:@{CEE_ERROR_KEY: errorResponse}]];
            }
        } else {
            return [RACSignal error:[NSError errorWithDomain:CEE_API_ERROR_DOMAIN
                                                        code:baseResponse.code
                                                    userInfo:@{CEE_ERROR_KEY: responseObject}]];
        }
    } else {
        if (self.responseSuccessClass != nil) {
            id successResponse = [[self.responseSuccessClass alloc] initWithDictionary:responseObject error:&jsonError];
            if (jsonError) {
                return [RACSignal error:[self packJSONError:jsonError errorObject:responseObject]];
            } else {
                return [RACSignal return:successResponse];
            }
        } else {
            return [RACSignal return:responseObject];
        }
    }
}

- (NSError *)packJSONError:(NSError *)jsonError errorObject:(id)object {
    NSMutableDictionary * userInfo = [jsonError.userInfo mutableCopy];
    userInfo[CEE_ERROR_KEY] = object;
    return [NSError errorWithDomain:jsonError.domain
                               code:jsonError.code
                           userInfo:userInfo];
}

@end
