//
//  CEEUserProfileAPI.h
//  CEE
//
//  Created by Meng on 16/4/22.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import ReactiveCocoa;

#import "CEEBaseAPI.h"

@interface CEESaveUserProfileRequest: JSONModel
@property (nonatomic, strong) NSString<Optional> * nickname;
@property (nonatomic, strong) NSString<Optional> * head_img_key;
@property (nonatomic, strong) NSString<Optional> * sex;
@property (nonatomic, assign) NSNumber<Optional> * birthday;
@property (nonatomic, strong) NSString<Optional> * mobile;
@property (nonatomic, strong) NSString<Optional> * location;
@end


@interface CEESaveUserProfileSuccessResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEESaveUserProfileErrorResponse : CEEBaseResponse
@property (nonatomic, strong) NSString * msg;
@end


@interface CEESaveUserProfileAPI : CEEBaseAPI

- (RACSignal *)saveUserProfile:(CEESaveUserProfileRequest *)request;

@end
