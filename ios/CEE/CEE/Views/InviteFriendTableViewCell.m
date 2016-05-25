//
//  InviteFriendTableViewCell.m
//  CEE
//
//  Created by Meng on 16/5/25.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "InviteFriendTableViewCell.h"
#import "AppearanceConstants.h"

@implementation InviteFriendTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    self.nameLabel.textColor = kCEETextLightBlackColor;
    [self.contentView addSubview:self.nameLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.detailLabel.textColor = kCEETextLightBlackColor;
    [self.contentView addSubview:self.detailLabel];
    
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.followButton.backgroundColor = [UIColor whiteColor];
    self.followButton.layer.borderWidth = 1.0;
    self.followButton.layer.borderColor = kCEEYellowColor.CGColor;
    [self.followButton setTitleColor:kCEEYellowColor forState:UIControlStateNormal];
    [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.contentView addSubview:self.followButton];
    
    self.iconView.layer.cornerRadius = 20;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(20);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(2);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(20);
        make.top.equalTo(self.contentView.mas_centerY).offset(-2);
    }];
    
    self.followButton.layer.cornerRadius = 15;
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
}

@end
