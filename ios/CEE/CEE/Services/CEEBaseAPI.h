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
#import <PromiseKit/AnyPromise.h>

@class AFHTTPSessionManager;


#define CEE_API_ERROR_DOMAIN @"CEE_API_ERROR_DOMAIN"
#define CEE_ERROR_KEY        @"CEE_ERROR_KEY"


@interface CEEBaseResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@end


@interface CEEBaseAPI : NSObject

- (RACSignal *)GET:(NSString *)url withParams:(NSDictionary *)params;
- (RACSignal *)GET:(NSString *)url withRequest:(JSONModel *)request;
- (AnyPromise *)promiseGET:(NSString *)url withParams:(NSDictionary *)params;
- (AnyPromise *)promiseGET:(NSString *)url withReqeust:(JSONModel *)request;

- (RACSignal *)POST:(NSString *)url withParams:(NSDictionary *)params;
- (RACSignal *)POST:(NSString *)url withRequest:(JSONModel *)request;
- (AnyPromise *)promisePOST:(NSString *)url withParams:(NSDictionary *)params;
- (AnyPromise *)promisePOST:(NSString *)url withRequest:(JSONModel *)request;

- (Class)responseSuccessClass;
- (Class)responseErrorClass;

- (NSString *)errorMessageForResponse:(id)response;

@end
