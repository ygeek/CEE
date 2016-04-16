//
//  CouponScrollView.m
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CouponScrollView.h"

@interface CouponScrollView () <UIScrollViewDelegate>
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSMutableArray * views;
@property (nonatomic, assign) CGFloat preContentOffsetY;
@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, assign) CouponScrollDirection scrollDirection;
@end


@implementation CouponScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = self.pagingEnabled;
    [self addSubview:self.scrollView];
}

#pragma mark - Public Methods

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    _pagingEnabled = pagingEnabled;
    self.scrollView.pagingEnabled = pagingEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.scrollView.scrollEnabled = scrollEnabled;
}

- (void)reloadData {
    for (UIView * view in self.views) {
        [view removeFromSuperview];
    }
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds) / self.dataSource.numberOfVisibleViews;
    self.viewSize = CGSizeMake(viewWidth, viewHeight);
    
    self.scrollView.contentSize = CGSizeMake(viewWidth, [self totalHeight]);
    
    self.views = [NSMutableArray array];
    
    int beginIndex = -ceil(self.dataSource.numberOfVisibleViews / 2.0f);
    int endIndex = ceil(self.dataSource.numberOfVisibleViews / 2.0f);
    _currentIndex = 0;
    
    self.scrollView.contentOffset = CGPointMake(0, [self totalHeight] / 2 - CGRectGetHeight(self.bounds) / 2);
    
    CGFloat currentCenterY = self.currentCenter.y;
    
    for (int i = beginIndex; i <= endIndex; i++) {
        UIView * view = [self.dataSource viewAtIndex:i reusingView:nil];
        view.center = [self centerForViewAtIndex:i];
        view.tag = i;
        [self.views addObject:view];
        [self.scrollView addSubview:view];
        CGFloat progress = (view.center.y - currentCenterY) / CGRectGetHeight(self.bounds) * self.dataSource.numberOfVisibleViews;
        [self.delegate updateView:view
                     withProgress:progress
                     currentIndex:self.currentIndex
                  scrollDirection:self.scrollDirection];
    }
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    self.dragging = YES;
    [self.scrollView setContentOffset:[self contentOffsetForIndex:index] animated:animated];
}

- (UIView *)viewAtIndex:(NSInteger)index {
    CGPoint center = [self centerForViewAtIndex:index];
    for (UIView *view in self.views) {
        if (fabs(center.y - view.center.y) <= self.viewSize.height / 2.0f) {
            return view;
        }
    }
    return nil;
}

- (NSArray *)allViews {
    return self.views;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentCenterY = [self currentCenter].y;
    CGFloat offset = currentCenterY - self.totalHeight / 2;
    _currentIndex = ceil((offset - self.viewSize.height / 2) / self.viewSize.height);
    
    if (self.scrollView.contentOffset.y > self.preContentOffsetY) {
        self.scrollDirection = CouponScrollDirectionUp;
    } else {
        self.scrollDirection = CouponScrollDirectionDown;
    }
    self.preContentOffsetY = self.scrollView.contentOffset.y;
    
    for (UIView * view in self.views) {
        if ([self viewCanBeQueuedForReuse:view]) {
            NSInteger indexNeeded;
            NSInteger indexOfViewToReuse = (NSInteger)view.tag;
            if (indexOfViewToReuse < self.currentIndex) {
                indexNeeded = indexOfViewToReuse + self.dataSource.numberOfVisibleViews + 2;
            } else {
                indexNeeded = indexOfViewToReuse - (self.dataSource.numberOfVisibleViews + 2);
            }
            
            if (labs(indexNeeded) <= floorf(self.dataSource.numberOfViews / 2.0f)) {
                [view removeFromSuperview];
                UIView * viewNeeded = [self.dataSource viewAtIndex:indexNeeded reusingView:view];
                viewNeeded.center = [self centerForViewAtIndex:indexNeeded];
                [self.scrollView addSubview:viewNeeded];
                viewNeeded.tag = indexNeeded;
            }
        }
        
        CGFloat progress = (view.center.y - currentCenterY) / CGRectGetHeight(self.bounds) * self.dataSource.numberOfVisibleViews;
        [self.delegate updateView:view
                     withProgress:progress
                     currentIndex:self.currentIndex
                  scrollDirection:self.scrollDirection];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.dragging = NO;
    if (!self.pagingEnabled && !decelerate) {
        [self.scrollView setContentOffset:[self contentOffsetForIndex:self.currentIndex] animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.pagingEnabled) {
        [self.scrollView setContentOffset:[self contentOffsetForIndex:self.currentIndex] animated:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.maxScrollDistance <= 0) {
        return;
    }
    CGFloat targetY = targetContentOffset->y;
    CGFloat currentY = [self contentOffsetForIndex:self.currentIndex].y;
    if (fabs(targetY - currentY) <= self.viewSize.height / 2) {
        return;
    } else {
        NSInteger distance = self.maxScrollDistance - 1;
        NSInteger currentIndex = [self currentIndex];
        NSInteger targetIndex = self.scrollDirection == CouponScrollDirectionUp ? currentIndex + distance : currentIndex - distance;
        targetContentOffset->y = [self contentOffsetForIndex:targetIndex].y;
    }
}

#pragma mark - Helper Methods

- (CGFloat)totalHeight {
    return self.viewSize.height * self.dataSource.numberOfViews;
}

- (CGPoint)currentCenter {
    CGFloat x = self.scrollView.contentOffset.x + CGRectGetWidth(self.bounds) / 2.0f;
    CGFloat y = self.scrollView.contentOffset.y + CGRectGetHeight(self.bounds) / 2.0f;
    return CGPointMake(x, y);
}

- (CGPoint)contentOffsetForIndex:(NSInteger)index {
    CGFloat y = self.totalHeight / 2 + index * self.viewSize.height - CGRectGetHeight(self.bounds) / 2;
    return CGPointMake(0, y);
}

- (CGPoint)centerForViewAtIndex:(NSInteger)index {
    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = self.totalHeight / 2 + index * self.viewSize.height;
    return CGPointMake(x, y);
}

- (BOOL)viewCanBeQueuedForReuse:(UIView *)view {
    CGFloat distanceToCenter = [self currentCenter].y - view.center.y;
    CGFloat threshold = ceil(self.dataSource.numberOfVisibleViews / 2.0f) * self.viewSize.height
                        + self.viewSize.height / 2.0f;
    if (self.scrollDirection == CouponScrollDirectionUp) {
        if (distanceToCenter < 0){
            return NO;
        }
    } else {
        if (distanceToCenter > 0) {
            return NO;
        }
    }
    if (fabs(distanceToCenter) > threshold) {
        return YES;
    }
    return NO;
}

@end
