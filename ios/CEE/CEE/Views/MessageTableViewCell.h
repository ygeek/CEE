//
//  MessageTableViewCell.h
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView * bodyView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UIView * textContainer;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UILabel * messageLabel;
@end
