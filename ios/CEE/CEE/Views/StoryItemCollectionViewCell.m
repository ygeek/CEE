//
//  StoryItemCollectionViewCell.m
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "StoryItemCollectionViewCell.h"
#import "CEEStory.h"
#import "UIImageView+Utils.h"

@implementation StoryItemCollectionViewCell

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

- (void)commonInit {
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.backgroundColor = [UIColor whiteColor];
    // self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 10;
    self.iconView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.iconView.layer.shadowOpacity = 0.7;
    self.iconView.layer.shadowOffset = CGSizeMake(3, 3);
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.mas_equalTo(92);
        make.height.mas_equalTo(71);
    }];
}

- (void)loadItem:(CEEJSONItem *)item {
    self.item = item;
    [self.iconView cee_setImageWithKey:item.content[@"icon"]];
}

- (void)setSelected:(BOOL)selected {
    [self.superview bringSubviewToFront:self];
    [self layoutIfNeeded];
    if (selected) {
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(100);
        }];
    } else {
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(92);
            make.height.mas_equalTo(71);
        }];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
