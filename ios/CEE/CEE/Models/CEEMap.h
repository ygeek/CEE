//
//  CEEMap.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol CEEJSONMap <NSObject>
@end


@interface CEEJSONMap : JSONModel
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSString * image_key;
@property (nonatomic, strong) NSString * icon_key;
@property (nonatomic, strong) NSString * summary_image_key;
@property (nonatomic, strong) NSString * city;
@end
