//
//  StoryTagView.m
//  CEE
//
//  Created by Meng on 16/4/17.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "StoryTagView.h"
#import "AppearanceConstants.h"

@implementation StoryTagView

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
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.backgroundColor = kCEETagBackgroundColor;
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont fontWithName:kCEEFontNameRegular size:9];
    self.textColor = kCEETextBlackColor;
}

- (void)setTagText:(NSString *)tagText {
    NSAttributedString* attributedString
        = [[NSAttributedString alloc]
           initWithString:[NSString stringWithFormat:@" %@", tagText]
               attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:9],
                            NSForegroundColorAttributeName: kCEETextBlackColor,
                            NSKernAttributeName: @(5),
                            }];
    self.attributedText = attributedString;
}

@end
