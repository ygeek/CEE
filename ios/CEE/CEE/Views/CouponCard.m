//
//  CouponCard.m
//  CEE
//
//  Created by Meng on 16/4/26.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "CouponCard.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"
#import "HUDCouponCodeView.h"


@interface CouponCard () <UIScrollViewDelegate, HUDViewDelegate>
@property (nonatomic, strong) HUDCouponCodeView * codeView;
@end


@implementation CouponCard

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.frame = CGRectMake(0, 0, 334, 212);
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = .3;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = shadowPath.CGPath;
    
    self.photoView = [[UIImageView alloc] init];
    [self addSubview:self.photoView];
    
    self.titleImageView = [[UIImageView alloc] init];
    [self addSubview:self.titleImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"获得优惠券";
    self.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:16];
    [self addSubview:self.titleLabel];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.contentScrollView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPageIndicatorTintColor = hexColor(0x202020);
    self.pageControl.pageIndicatorTintColor = hexColor(0xd1d1d1);
    [self.pageControl addTarget:self
                         action:@selector(pageControlChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
    UIImage * locationIcon = [UIImage imageNamed:@"优惠券弹窗_定位"];
    self.locationAttachment = [[NSTextAttachment alloc] init];
    self.locationAttachment.image = locationIcon;
    UIFont * font = [UIFont fontWithName:kCEEFontNameRegular size:11];
    CGFloat mid = font.descender + font.capHeight;
    self.locationAttachment.bounds = CGRectIntegral(CGRectMake(0,
                                                               font.descender - locationIcon.size.height / 2 + mid + 2,
                                                               locationIcon.size.width,
                                                               locationIcon.size.height));

    self.page1 = [[UIView alloc] init];
    self.page2 = [[UIView alloc] init];
    [self.contentScrollView addSubview:self.page1];
    [self.contentScrollView addSubview:self.page2];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    [self.page1 addSubview:self.locationLabel];
    
    self.entryTitleLabelsContainer = [[OAStackView alloc] init];
    self.entryTitleLabelsContainer.distribution = OAStackViewDistributionFillEqually;
    self.entryTitleLabelsContainer.axis = UILayoutConstraintAxisVertical;
    self.entryTitleLabelsContainer.alignment = OAStackViewAlignmentLeading;
    [self.page1 addSubview:self.entryTitleLabelsContainer];
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(18, 18)]
                     forState:UIControlStateNormal];
    [self.codeButton setTitle:@"商家密钥" forState:UIControlStateNormal];
    [self.codeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.codeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.codeButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:11];
    self.codeButton.backgroundColor = kCEEThemeYellowColor;
    [self.codeButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    self.codeButton.layer.cornerRadius = 11;
    self.codeButton.layer.masksToBounds = YES;
    [self.codeButton addTarget:self action:@selector(codeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.page1 addSubview:self.codeButton];
    
    self.noteLabel = [[UILabel alloc] init];
    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    self.noteLabel.text = @"优惠券已收录到抽屉列表";
    self.noteLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:11];
    self.noteLabel.textColor = kCEETextBlackColor;
    [self.page1 addSubview:self.noteLabel];
    
    self.contentTitleLabel = [[UILabel alloc] init];
    self.contentTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.contentTitleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    self.contentTitleLabel.textColor = kCEETextBlackColor;
    self.contentTitleLabel.text = @"细则";
    [self.page2 addSubview:self.contentTitleLabel];
    
    self.entryContentLabelsContainer = [[OAStackView alloc] init];
    self.entryContentLabelsContainer.axis = UILayoutConstraintAxisVertical;
    self.entryContentLabelsContainer.distribution = OAStackViewDistributionFillProportionally;
    self.entryContentLabelsContainer.alignment = OAStackViewAlignmentCenter;
    [self.page2 addSubview:self.entryContentLabelsContainer];
    
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.maskView];
    
    [self setupLayout];
    
    [self loadFakeData];
}

- (void)setupLayout {
    // Because AutoLayout conflict with View Transform, use frame instead of AutoLayout
    self.photoView.frame = CGRectMake(0, 0, 91, 212);
    
    self.titleImageView.frame = CGRectMake(91, 0, 243, 55);
    
    self.titleLabel.center = self.titleImageView.center;
    
    self.contentScrollView.frame = CGRectMake(91, 55, 243, 212 - 55);
    self.contentScrollView.contentSize = CGSizeMake(486, 157);
    
    self.pageControl.frame = CGRectMake(0, 0, 10, 4);
    self.pageControl.center = CGPointMake(91 + 243 / 2.0, 212 - 8);
    
    self.page1.frame = CGRectMake(0, 0, 243, 157);
    self.page2.frame = CGRectMake(243, 0, 243, 157);
   
    self.locationLabel.center = CGPointMake(243 / 2.0, 8 + 23 / 2.0);
    
    self.codeButton.frame = CGRectMake(0, 0, 115, 22);
    self.codeButton.center = CGPointMake(self.page1.bounds.size.width / 2.0, 156 - 55 + 11);
    
    self.noteLabel.frame = CGRectMake(0, self.page1.bounds.size.height - 18 - 11, self.page1.bounds.size.width, 12);
    
    self.entryTitleLabelsContainer.frame = CGRectMake(15, 8 + 23 + 5, 243 - 15, self.page1.bounds.size.height - 8 - 23 - 5 - (self.page1.bounds.size.height - self.codeButton.frame.origin.y) - 15);
    
    self.contentTitleLabel.frame = CGRectMake(0, 13, self.page2.bounds.size.width, 14);
    
    self.entryContentLabelsContainer.frame = CGRectMake(0, 13 + 14 + 10, self.page2.bounds.size.width, self.page2.bounds.size.height - 13 - 14 - 10 - 16);
    
    self.maskView.frame = self.bounds;
}

- (void)loadEntryTitles:(NSArray<NSString *> *)titles {
    for (UIView * entryView in self.entryTitleLabels) {
        [self.entryTitleLabelsContainer removeArrangedSubview:entryView];
        [entryView removeFromSuperview];
    }
    [self.entryTitleLabels removeAllObjects];
    for (NSString * entry in titles) {
        UILabel * entryView = [[UILabel alloc] init];
        entryView.text = entry;
        entryView.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
        entryView.textColor = kCEETextBlackColor;
        [self.entryTitleLabels addObject:entryView];
        [self.entryTitleLabelsContainer addArrangedSubview:entryView];
    }
}

- (void)loadEntryContents:(NSArray<NSString *> *)contents {
    for (UIView * entryView in self.entryContentLabels) {
        [self.entryContentLabelsContainer removeArrangedSubview:entryView];
        [entryView removeFromSuperview];
    }
    [self.entryContentLabels removeAllObjects];
    for (NSString * entry in contents) {
        UILabel * entryView = [[UILabel alloc] init];
        entryView.text = entry;
        entryView.font = [UIFont fontWithName:kCEEFontNameRegular size:11];
        entryView.textColor = kCEETextBlackColor;
        entryView.numberOfLines = 5;
        entryView.textAlignment = NSTextAlignmentCenter;
        [self.entryContentLabels addObject:entryView];
        [self.entryContentLabelsContainer addArrangedSubview:entryView];
    }
}

- (void)pageControlChanged:(UIPageControl *)pageControl {
    CGRect frame = self.contentScrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [self.contentScrollView scrollRectToVisible:frame animated:YES];
}

- (void)codeButtonPressed:(id)sender {
    if (!self.codeView) {
        self.codeView = [[HUDCouponCodeView alloc] init];
    }
    self.codeView.delegate = self;
    [self.codeView show];
}

#pragma mark - HUDViewDelegate

- (void)HUDOverlayViewTouched:(HUDBaseView *)view {
    [self.codeView dismiss];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.contentScrollView.frame);
    NSUInteger page = floor(self.contentScrollView.contentOffset.x / pageWidth);
    self.pageControl.currentPage = page;
}

- (void)loadFakeData {
    self.photoView.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(91, 212)];
    self.titleImageView.image = [UIImage imageWithColor:kCEEThemeYellowColor size:CGSizeMake(243, 55)];
    
    NSMutableAttributedString * locationString = [[NSAttributedString attributedStringWithAttachment:self.locationAttachment] mutableCopy];
    [locationString appendAttributedString:
     [[NSAttributedString alloc] initWithString:@"万达XX餐厅"
                                     attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:11],
                                                  NSForegroundColorAttributeName: kCEETextBlackColor}]];
    
    self.locationLabel.attributedText = locationString;
    [self.locationLabel sizeToFit];
    self.locationLabel.center = CGPointMake(243 / 2.0, 8 + 23 / 2.0);
    
    [self loadEntryTitles:@[@"GET  现金折扣 八五折", @"GET  附赠小食"]];
    
    [self loadEntryContents:@[@"持本券即可获得付款八五折\n优惠同事可与其他折扣同时使用",
                              @"获得小食一碟\n具体到店酌情而定"]];
}

@end
