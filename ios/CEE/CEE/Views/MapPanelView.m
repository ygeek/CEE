//
//  MapPanelView.m
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import <PromiseKit/PromiseKit.h>

#import "MapPanelView.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"
#import "CEEImageManager.h"

@implementation MapPanelView

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
    self.backgroundColor = kCEEThemeYellowColor;
    
    NSMutableArray<UIButton *> * mapButtons = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(mapPressed:) forControlEvents:UIControlEventTouchUpInside];
        [mapButtons addObject:button];
        
        [self addSubview:button];
    }
    self.mapButtons = mapButtons;
    
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    UIImage * rightArrow = [UIImage imageNamed:@"更多地图箭头"];
    attachment.image = rightArrow;
    UIFont * font = [UIFont fontWithName:kCEEFontNameRegular size:11];
    CGFloat mid = font.descender + font.capHeight;
    attachment.bounds = CGRectIntegral(CGRectMake(4,
                                                  font.descender - rightArrow.size.height / 2 + mid + 2,
                                                  rightArrow.size.width + 4,
                                                  rightArrow.size.height));
    
    NSMutableAttributedString * moreText =
    [[NSMutableAttributedString alloc] initWithString:@"更多地图"
                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:11],
                                                        NSForegroundColorAttributeName: [UIColor blackColor]}];
    [moreText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    self.moreMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreMapButton setAttributedTitle:moreText forState:UIControlStateNormal];
    
    [self addSubview:self.moreMapButton];
    
    [self.mapButtons[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(22 * horizontalScale());
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.mapButtons[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mapButtons[0].mas_right).offset(38 * horizontalScale());
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.mapButtons[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mapButtons[1].mas_right).offset(38 * horizontalScale());
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.moreMapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-23);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(96);
    }];
}

- (void)mapPressed:(id)sender {
    NSInteger index = [self.mapButtons indexOfObject:sender];
    if (index != NSNotFound && index < self.maps.count) {
        [self.delegate mapPressed:self.maps[index]];
    }
}

- (AnyPromise *)loadAcquiredMaps:(NSArray<CEEJSONMap *> *)maps {
    self.maps = maps;
    NSMutableArray * loadPromises = [NSMutableArray array];
    for (NSUInteger i = 0; i < maps.count && i < 3; i++) {
        [loadPromises addObject:[[CEEImageManager manager] downloadImageForKey:maps[i].icon_key]
         .then(^(UIImage *image) {
            [self.mapButtons[i] setImage:image forState:UIControlStateNormal];
        })];
    }
    return PMKJoin(loadPromises);
}

@end
