//
//  CEEDownloadURLAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

@interface CEEDownloadURLRequest: JSONModel
@property (nonatomic, strong) NSString * key;
@end


@interface CEEDownloadURLSuccessResponse: CEEBaseResponse
@property (nonatomic, strong) NSString * private_url;
@end


@interface CEEDownloadURLErrorResponse: CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEEDownloadURLAPI : CEEBaseAPI

- (RACSignal *)requestURLWithKey:(NSString *)key;

@end
