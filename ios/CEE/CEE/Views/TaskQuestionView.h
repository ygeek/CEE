//
//  TaskQuestionView.h
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskQuestionView : UIView
@property (nonatomic, strong) UIImageView * closeButtonBG;
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UIImageView * photoView;
@property (nonatomic, strong) NSTextAttachment * locationAttachment;
@property (nonatomic, strong) UILabel * locationLabel;
@property (nonatomic, strong) UILabel * questionLabel;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> * optionButtons;

@property (nonatomic, assign) NSUInteger selectedIndex;

- (void)loadOptions:(NSArray<NSString *> *)options;
- (void)setLocation:(NSString *)location;
@end
