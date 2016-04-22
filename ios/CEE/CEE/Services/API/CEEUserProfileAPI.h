//
//  CEEUserProfileAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEBaseAPI.h"

@interface CEEUserProfileRequest: JSONModel
@property (nonatomic, strong) NSString<Optional> * nickname;
@property (nonatomic, strong) NSString<Optional> * head_img_key;
@property (nonatomic, strong) NSString<Optional> * sex;
@property (nonatomic, assign) NSNumber<Optional> * birthday;
@property (nonatomic, strong) NSString<Optional> * mobile;
@property (nonatomic, strong) NSString<Optional> * location;
@end


@interface CEEUserProfileSuccessResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEEUserProfileErrorResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEEUserProfileAPI : CEEBaseAPI

- (RACSignal *)saveUserProfile:(CEEUserProfileRequest *)request;

@end
