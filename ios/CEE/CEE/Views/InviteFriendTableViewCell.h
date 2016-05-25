//
//  InviteFriendTableViewCell.h
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONFriendInfo;

@interface InviteFriendTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UIButton * followButton;
@property (nonatomic, strong) CEEJSONFriendInfo * friendInfo;
@end
