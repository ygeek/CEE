//
//  UserFriendTableViewCell.m
//  CEE
//
//  Created by Meng on 16/5/7.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "UserFriendTableViewCell.h"
#import "AppearanceConstants.h"
#import "UIImageView+Utils.h"


@implementation UserFriendTableViewCell

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
    self.headView = [[UIImageView alloc] init];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = 46;
    self.headView.image = [UIImage imageNamed:@"cee-头像"];
    [self.contentView addSubview:self.headView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:19];
    self.nameLabel.textColor = hexColor(0xb4b4b4);
    self.nameLabel.text = @"null";
    [self.contentView addSubview:self.nameLabel];
    
    self.coinLabel = [[UILabel alloc] init];
    self.coinLabel.textAlignment = NSTextAlignmentRight;
    self.coinLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:19];
    self.coinLabel.textColor = kCEETextBlackColor;
    self.coinLabel.text = @"0";
    [self.contentView addSubview:self.coinLabel];
    
    self.coinTitleLabel = [[UILabel alloc] init];
    self.coinTitleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.coinTitleLabel.textColor = hexColor(0xb4b4b4);
    self.coinTitleLabel.text = @"金币";
    [self.contentView addSubview:self.coinTitleLabel];
    
    self.eggsLabel = [[UILabel alloc] init];
    self.eggsLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:12];
    self.eggsLabel.textColor = kCEETextBlackColor;
    self.eggsLabel.text = @"0";
    [self.contentView addSubview:self.eggsLabel];
    
    self.eggsTitleLabel = [[UILabel alloc] init];
    self.eggsTitleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.eggsTitleLabel.textColor = hexColor(0xb4b4b4);
    self.eggsTitleLabel.text = @"彩蛋";
    [self.contentView addSubview:self.eggsTitleLabel];
    
    self.medalsLabel = [[UILabel alloc] init];
    self.medalsLabel.font = [UIFont fontWithName:kGoboldFontNameRegular size:12];
    self.medalsLabel.textColor = kCEETextBlackColor;
    self.medalsLabel.text = @"0";
    [self.contentView addSubview:self.medalsLabel];
    
    self.medalsTitleLabel = [[UILabel alloc] init];
    self.medalsTitleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:12];
    self.medalsTitleLabel.textColor = hexColor(0xb4b4b4);
    self.medalsTitleLabel.text = @"徽章";
    [self.contentView addSubview:self.medalsTitleLabel];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(37);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(92);
        make.height.mas_equalTo(92);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.left.equalTo(self.headView.mas_right).offset(38);
        make.height.mas_equalTo(20);
    }];
    
    [self.eggsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.headView.mas_right).offset(166);
        make.height.mas_equalTo(12);
    }];
    
    [self.eggsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-44);
        make.height.mas_equalTo(11);
    }];
    
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.coinTitleLabel.mas_left).offset(-6);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(22);
        make.height.mas_equalTo(19);
    }];
    
    [self.coinTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel.mas_right);
        make.bottom.equalTo(self.coinLabel.mas_bottom);
        make.height.mas_equalTo(12);
    }];
    
    [self.medalsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.eggsTitleLabel.mas_right);
        make.bottom.equalTo(self.coinLabel.mas_bottom);
        make.height.mas_equalTo(12);
    }];
    
    [self.medalsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.medalsTitleLabel.mas_bottom);
        make.left.equalTo(self.eggsLabel.mas_left);
        make.height.mas_equalTo(12);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadFriendInfo:(CEEJSONFriendInfo *)friendInfo {
    self.nameLabel.text = friendInfo.nickname;
    self.coinLabel.text = friendInfo.coin.stringValue;
    self.medalsLabel.text = friendInfo.medals.stringValue;
    [self.headView cee_setImageWithKey:friendInfo.head_img_key
                           placeholder:[UIImage imageNamed:@"cee-头像"]];
    // TODO: replace with real data
    self.eggsLabel.text = @"16";
}

@end
