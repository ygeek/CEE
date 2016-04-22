//
//  CEEUploadTokenAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

@interface CEEUploadTokenSuccessResponse: CEEBaseResponse
@property (nonatomic, strong) NSString * upload_token;
@end


@interface CEEUploadTokenErrorResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEEUploadTokenAPI : CEEBaseAPI

- (RACSignal *)requestUploadToken;

@end
