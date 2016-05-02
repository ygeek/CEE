//
//  StoryTableViewCell.m
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import SDWebImage;

#import "StoryTableViewCell.h"
#import "StoryTableViewCellMenuView.h"
#import "AppearanceConstants.h"
#import "CEEStory.h"
#import "CEEDownloadURLAPI.h"


@interface StoryTableViewCell ()
@property (nonatomic, strong) UIImageView * photoView;
@property (nonatomic, copy) NSString * currentID;
@end


@implementation StoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kCEEThemeYellowColor;
        self.photoView = [[UIImageView alloc] init];
        self.photoView.backgroundColor = kCEEBackgroundGrayColor;
        [self.contentView addSubview:self.photoView];
        [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];

    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.photoView sd_cancelCurrentImageLoad];
}

- (void)loadStory:(CEEJSONStory *)story {
    NSString *currentID = [[NSUUID UUID] UUIDString];
    self.currentID = currentID;
    [[CEEDownloadURLAPI api] requestURLWithKey:story.image_keys.firstObject].then(^(NSString * url) {
        if ([self.currentID isEqualToString:currentID]) {
            [self.photoView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!image) {
                    return;
                }
                [UIView transitionWithView:self.photoView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.photoView.image = image;
                                } completion:nil];
            }];
        }
    });
}

@end
