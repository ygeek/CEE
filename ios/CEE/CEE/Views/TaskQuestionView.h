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
@property (nonatomic, copy) dispatch_block_t locationBlock;

- (void)loadOptions:(NSArray<NSString *> *)options;
- (void)setLocation:(NSString *)location withBlock:(dispatch_block_t)block;
@end
