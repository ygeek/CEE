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

- (AnyPromise *)promiseGET:(NSString *)url withParams:(NSDictionary *)params {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        [[CEEAPIClient client] GET:url
                        parameters:params
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               resolve(responseObject);
                           }
                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               resolve(error);
                           }];
    }].then(^(id responseObject) {
        return [self responseWithObject:responseObject];
    });
}

- (AnyPromise *)promiseGET:(NSString *)url withReqeust:(JSONModel *)request {
    return [self promiseGET:url withParams:request.toDictionary];
}

- (RACSignal *)POST:(NSString *)url withParams:(NSDictionary *)params {
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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
    }] catch:^RACSignal *(NSError * error) {
        NSMutableDictionary * userInfo = [error.userInfo mutableCopy];
        userInfo[NSLocalizedDescriptionKey] = @"网络错误";
        return [RACSignal error:[NSError errorWithDomain:error.domain code:error.code userInfo: userInfo]];
    }] flattenMap:^RACStream *(id responseObject) {
        return [self responseSignalWithObject:responseObject];
    }];
}

- (RACSignal *)POST:(NSString *)url withRequest:(JSONModel *)request {
    return [self POST:url withParams:request.toDictionary];
}

- (AnyPromise *)promisePOST:(NSString *)url withParams:(NSDictionary *)params {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        [[CEEAPIClient client] POST:url
                         parameters:params
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                resolve(responseObject);
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                resolve(error);
                            }];
    }].then(^(id responseObject) {
        return [self responseWithObject:responseObject];
    });
}

- (AnyPromise *)promisePOST:(NSString *)url withRequest:(JSONModel *)request {
    return [self promisePOST:url withParams:request.toDictionary];
}

- (Class)responseSuccessClass {
    return nil;
}

- (Class)responseErrorClass {
    return nil;
}

- (id)responseWithObject:(id)responseObject {
    NSError * jsonError = nil;
    CEEBaseResponse * baseResponse = [[CEEBaseResponse alloc] initWithDictionary:responseObject
                                                                           error:&jsonError];
    if (jsonError) {
        return [self packJSONError:jsonError errorObject:responseObject];
    }
    
    if (baseResponse.code != 0) {
        if (self.responseErrorClass != nil) {
            id errorResponse = [[self.responseErrorClass alloc] initWithDictionary:responseObject
                                                                             error:&jsonError];
            if (jsonError) {
                return [self packJSONError:jsonError errorObject:responseObject];
            } else {
                NSDictionary * userInfo = @{CEE_ERROR_KEY: errorResponse,
                                            NSLocalizedDescriptionKey: [self errorMessageForResponse: errorResponse]};
                return [NSError errorWithDomain:CEE_API_ERROR_DOMAIN
                                           code:baseResponse.code
                                       userInfo:userInfo];
            }
        } else {
            NSDictionary * userInfo = @{CEE_ERROR_KEY: responseObject,
                                        NSLocalizedDescriptionKey: @"操作失败"};
            return [NSError errorWithDomain:CEE_API_ERROR_DOMAIN
                                       code:baseResponse.code
                                   userInfo:userInfo];
        }
    } else {
        if (self.responseSuccessClass != nil) {
            id successResponse = [[self.responseSuccessClass alloc] initWithDictionary:responseObject
                                                                                 error:&jsonError];
            if (jsonError) {
                return [self packJSONError:jsonError errorObject:responseObject];
            } else {
                return successResponse;
            }
        } else {
            return responseObject;
        }
    }
}


- (RACSignal *)responseSignalWithObject:(id)responseObject {
    id response = [self responseWithObject:responseObject];
    if ([response isKindOfClass:[NSError class]]) {
        return [RACSignal error:response];
    } else {
        return [RACSignal return:response];
    }
}

- (NSError *)packJSONError:(NSError *)jsonError errorObject:(id)object {
    NSMutableDictionary * userInfo = [jsonError.userInfo mutableCopy];
    userInfo[CEE_ERROR_KEY] = object;
    userInfo[NSLocalizedDescriptionKey] = @"服务器出错啦";
    return [NSError errorWithDomain:jsonError.domain
                               code:jsonError.code
                           userInfo:userInfo];
}

- (NSString *)errorMessageForResponse:(id)response {
    return @"未知错误";
}

@end
