//
//  CEEAnchor.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CEEJSONAnchor <NSObject>
@end

@interface CEEJSONAnchor : JSONModel
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * dx;
@property (nonatomic, strong) NSNumber * dy;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSNumber * ref_id;
@property (nonatomic, strong) NSNumber * completed;
@end
