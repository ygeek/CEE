//
//  CouponCard.h
//  CEE
//
//  Created by Meng on 16/4/26.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCard : UIView
@property (nonatomic, strong) UIImageView * photoView;

@property (nonatomic, strong) UIImageView * titleImageView;
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) UIImageView * locationIcon;
@property (nonatomic, strong) UILabel * locationLabel;
@property (nonatomic, strong) UILabel * entriesTitleLabe;
@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) UILabel * notesLabel;

@end
