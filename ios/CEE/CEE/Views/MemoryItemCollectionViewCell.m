//
//  MemoryItemCollectionViewCell.m
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "MemoryItemCollectionViewCell.h"

@implementation MemoryItemCollectionViewCell

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
    self.itemView = [[MemoryItemView alloc] init];
    [self.contentView addSubview:self.itemView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
