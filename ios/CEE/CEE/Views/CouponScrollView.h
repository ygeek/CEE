//
//  CouponScrollView.h
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, CouponScrollDirection) {
    CouponScrollDirectionUp,
    CouponScrollDirectionDown,
};


@protocol CouponScrollViewDelegate <NSObject>
- (void)updateView:(UIView *)view
      withProgress:(CGFloat)progress
      currentIndex:(NSInteger)currentIndex
   scrollDirection:(CouponScrollDirection)direction;
@end


@protocol CouponScrollViewDataSource <NSObject>
- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
- (CGFloat)viewHeightAtIndex:(NSInteger)index;
- (NSInteger)numberOfViews;
- (NSInteger)numberOfVisibleViews;
@end


@interface CouponScrollView : UIView
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, weak) id<CouponScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<CouponScrollViewDelegate> delegate;
@property (nonatomic) BOOL scrollEnabled;
@property (nonatomic) BOOL pagingEnabled;
@property (nonatomic) NSInteger maxScrollDistance;

- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
- (UIView *)viewAtIndex:(NSInteger)index;
- (NSArray *)allViews;
@end
