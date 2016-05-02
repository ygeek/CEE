//
//  AcquiredMapCollectionViewCell.h
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONMap;

@interface AcquiredMapCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;

- (void)loadMap:(CEEJSONMap *)map;
@end
