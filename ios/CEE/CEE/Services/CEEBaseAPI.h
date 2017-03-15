//
//  CEEBaseAPI.h
//  CEE
//
//  Created by Meng on 16/4/19.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import ReactiveCocoa;
@import JSONModel;

#import <Foundation/Foundation.h>
@import PromiseKit;

@class AFHTTPSessionManager;


#define CEE_API_ERROR_DOMAIN @"CEE_API_ERROR_DOMAIN"
#define CEE_ERROR_KEY        @"CEE_ERROR_KEY"


@interface CEEBaseResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> * msg;
@end


@interface CEEBaseAPI : NSObject

+ (instancetype)api;

- (AnyPromise *)promiseGET:(NSString *)url withParams:(NSDictionary *)params;
- (AnyPromise *)promiseGET:(NSString *)url withReqeust:(JSONModel *)request;

- (AnyPromise *)promisePOST:(NSString *)url withParams:(NSDictionary *)params;
- (AnyPromise *)promisePOST:(NSString *)url withRequest:(JSONModel *)request;

- (BOOL)checkResponseSuccess:(CEEBaseResponse *)response;

- (Class)responseSuccessClass;

- (NSError *)processHttpError:(NSError *)error;

@end
