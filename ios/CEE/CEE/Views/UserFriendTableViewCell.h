//
//  UserFriendTableViewCell.h
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEEFriendInfo.h"


@interface UserFriendTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView * headView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * coinLabel;
@property (nonatomic, strong) UILabel * coinTitleLabel;
@property (nonatomic, strong) UILabel * eggsLabel;
@property (nonatomic, strong) UILabel * eggsTitleLabel;
@property (nonatomic, strong) UILabel * medalsLabel;
@property (nonatomic, strong) UILabel * medalsTitleLabel;

- (void)loadFriendInfo:(CEEJSONFriendInfo *)friendInfo;

@end
