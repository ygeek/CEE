//
//  MemoryItemView.h
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MemoryItemType) {
    MemoryItemTypeVideo,
    MemoryItemTypeDialog,
};

@class CEEJSONLevel;


@interface MemoryItemView : UIView
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * nameLabel;

- (void)loadLevel:(CEEJSONLevel *)level;

@end
