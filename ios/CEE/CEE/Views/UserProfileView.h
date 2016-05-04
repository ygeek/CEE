//
//  UserProfileView.h
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileView : UICollectionReusableView
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UILabel * nicknameLabel;
@property (nonatomic, strong) UILabel * coinLabel;
@property (nonatomic, strong) UILabel * coinTitleLabel;
@property (nonatomic, strong) UILabel * friendsLabel;
@property (nonatomic, strong) UILabel * friendsTitleLabel;
@end
