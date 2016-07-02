//
//  CEETask.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface CEEJSONOption : JSONModel
@property (nonatomic, strong) NSNumber * order;
@property (nonatomic, strong) NSString * desc;
@end


@protocol CEEJSONOption <NSObject>
@end


@interface CEEJSONChoice : JSONModel
@property (nonatomic, strong) NSNumber * order;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * image_key;
@property (nonatomic, strong) NSNumber * answer;
@property (nonatomic, strong) NSString * answer_message;
@property (nonatomic, strong) NSString * answer_next;
@property (nonatomic, strong) NSString * answer_image_key;
@property (nonatomic, strong) NSArray<CEEJSONOption> * options;
@end


@protocol CEEJSONChoice <NSObject>
@end


@interface CEEJSONTask : JSONModel
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString<Optional> * detail_location;
@property (nonatomic, strong) NSString<Optional> * phone;
@property (nonatomic, strong) NSArray<CEEJSONChoice> * choices;
@property (nonatomic, strong) NSNumber * completed;
@end
