//
//  StoryItemCollectionViewCell.h
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONItem;

@interface StoryItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * iconView;

@property (nonatomic, strong) CEEJSONItem * item;

- (void)loadItem:(CEEJSONItem *)item;

@end
