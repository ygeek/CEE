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
#import "HTTPStatusCodes.h"
#import "CEEUserSession.h"
#import "CEENotificationNames.h"


@implementation CEEBaseResponse
@end


@implementation CEEBaseAPI

+ (instancetype)api {
    return [[self alloc] init];
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
    }).catch(^(NSError *error) {
        return [self processHttpError:error];
    });
}

- (AnyPromise *)promiseGET:(NSString *)url withReqeust:(JSONModel *)request {
    return [self promiseGET:url withParams:request.toDictionary];
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
    }).catch(^(NSError *error) {
        return [self processHttpError:error];
    });
}

- (AnyPromise *)promisePOST:(NSString *)url withRequest:(JSONModel *)request {
    return [self promisePOST:url withParams:request.toDictionary];
}

- (Class)responseSuccessClass {
    return [CEEBaseResponse class];
}

- (BOOL)checkResponseSuccess:(CEEBaseResponse *)response {
    return response.code == 0;
}

- (id)responseWithObject:(id)responseObject {
    NSError * jsonError = nil;
    
    // 1. convert to Base Response to check code
    CEEBaseResponse * baseResponse = [[CEEBaseResponse alloc] initWithDictionary:responseObject
                                                                           error:&jsonError];
    if (jsonError) {
        return [self packJSONError:jsonError errorObject:responseObject];
    }
    
    // 2. check code -> if error existed
    if (![self checkResponseSuccess:baseResponse]) {
        // 3. error existed
        return [NSError errorWithDomain:CEE_API_ERROR_DOMAIN
                                   code:baseResponse.code
                               userInfo:@{NSLocalizedDescriptionKey: baseResponse.msg ?: @"未知错误"}];
    } else {
        // 4. error not existed
        id successResponse = [[self.responseSuccessClass alloc] initWithDictionary:responseObject
                                                                             error:&jsonError];
        if (jsonError) {
            return [self packJSONError:jsonError errorObject:responseObject];
        } else {
            return successResponse;
        }
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

- (NSError *)processHttpError:(NSError *)error {
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCEENetworkErrorNotificationName
                                                            object:self
                                                          userInfo:@{CEE_ERROR_KEY: error}];
        return error;
    }
    NSHTTPURLResponse * response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    NSInteger statusCode = response.statusCode;
    NSMutableDictionary * userInfo = [[error userInfo] mutableCopy];
    switch (statusCode) {
        case kHTTPStatusCodeUnauthorized:
            [[CEEUserSession session] onUnauthorized];
            userInfo[NSLocalizedDescriptionKey] = @"登录失效，请重新登录。";
            error = [NSError errorWithDomain:error.domain
                                        code:error.code
                                    userInfo:userInfo];
            break;
        default:
            break;
    }
    return error;
}

@end
