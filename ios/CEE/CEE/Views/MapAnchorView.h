//
//  MapAnchorView.h
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CEEJSONAnchor;


typedef enum : NSUInteger {
    MapAnchorTypeStory,
    MapAnchorTypeStoryFinished,
    MapAnchorTypeTask,
    MapAnchorTypeTaskFinished,
} MapAnchorType;


extern NSString * const kAnchorTypeNameStory;
extern NSString * const kAnchorTypeNameTask;


@interface MapAnchorView : UIControl
@property (nonatomic, assign) MapAnchorType anchorType;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) CEEJSONAnchor * anchor;
@end
