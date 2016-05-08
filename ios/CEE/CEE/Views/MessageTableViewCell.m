//
//  MessageTableViewCell.m
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "MessageTableViewCell.h"
#import "AppearanceConstants.h"

@interface MessageTableViewCell ()
@end


@implementation MessageTableViewCell

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

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    self.bodyView = [[UIView alloc] init];
    self.bodyView.backgroundColor = kCEEYellowColor;
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.tintColor = kCEETextBlackColor;
    
    self.textContainer = [[UIView alloc] init];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.dateLabel.textColor = kCEETextBlackColor;
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.messageLabel.textColor = kCEETextBlackColor;
    self.messageLabel.numberOfLines = 2;
    
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconView];
    [self.textContainer addSubview:self.dateLabel];
    [self.textContainer addSubview:self.messageLabel];
    [self.bodyView addSubview:self.textContainer];
    
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bodyView.mas_centerY);
        make.left.equalTo(self.bodyView.mas_left).offset(20);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.textContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(9);
        make.right.equalTo(self.bodyView.mas_right).offset(-20);
        make.centerY.equalTo(self.bodyView.mas_centerY);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textContainer.mas_top);
        make.left.equalTo(self.textContainer.mas_left);
        make.right.equalTo(self.textContainer.mas_right);
        make.height.mas_equalTo(15);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(8);
        make.left.equalTo(self.textContainer.mas_left);
        make.right.equalTo(self.textContainer.mas_right);
        make.bottom.equalTo(self.textContainer.mas_bottom);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
