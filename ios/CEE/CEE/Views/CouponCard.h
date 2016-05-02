//
//  CouponCard.h
//  CEE
//
//  Created by Meng on 16/4/26.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import OAStackView;

#import <UIKit/UIKit.h>

#import "CEECoupon.h"

@class CouponCard;


@protocol CouponCardDelegate <NSObject>

- (void)couponCard:(CouponCard *)card consumeCoupon:(CEEJSONCoupon *)coupon;

@end


@interface CouponCard : UIView
@property (nonatomic, strong) UIImageView * photoView;

@property (nonatomic, strong) UIView * titleContainer;
@property (nonatomic, strong) UIView * titleBorderView;
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) UIView * page1;
@property (nonatomic, strong) UIView * page2;

@property (nonatomic, strong) NSTextAttachment * locationAttachment;
@property (nonatomic, strong) UILabel * locationLabel;

@property (nonatomic, strong) OAStackView * entryTitleLabelsContainer;
@property (nonatomic, strong) NSMutableArray<UILabel *> * entryTitleLabels;

@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) UILabel * noteLabel;

@property (nonatomic, strong) UILabel * contentTitleLabel;
@property (nonatomic, strong) OAStackView * entryContentLabelsContainer;
@property (nonatomic, strong) NSMutableArray<UILabel *> * entryContentLabels;

@property (nonatomic, strong) UIView * shadowView;

@property (nonatomic, weak) id<CouponCardDelegate> delegate;

@property (nonatomic, strong) CEEJSONCoupon * coupon;
- (void)loadCoupon:(CEEJSONCoupon *)coupon;

@end
