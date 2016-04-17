//
//  StoryTableViewCell.m
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "StoryTableViewCell.h"
#import "StoryTableViewCellMenuView.h"


@interface StoryTableViewCell ()
@property (nonatomic, strong) UIImageView * photoView;
@end


@implementation StoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.photoView = [[UIImageView alloc] init];
        self.photoView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.photoView];
        [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView)
                .insets(UIEdgeInsetsMake(0, 0, 1.0 / [UIScreen mainScreen].scale, 0));
        }];

    }
    return self;
}

@end
