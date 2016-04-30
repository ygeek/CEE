//
//  CEEUploadTokenAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

@interface CEEUploadTokenResponse: CEEBaseResponse
@property (nonatomic, strong) NSString * upload_token;
@end


@interface CEEUploadTokenAPI : CEEBaseAPI

- (AnyPromise *)requestUploadToken;

@end
