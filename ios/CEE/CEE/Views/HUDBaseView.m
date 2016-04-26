//
//  HUDBaseView.m
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDBaseView.h"

NSString * const HUDDidReceiveTouchEventNotification = @"HUDDidReceiveTouchEventNotification";
NSString * const HUDDidTouchDownInsideNotification = @"HUDDidTouchDownInsideNotification";


@implementation HUDBaseView

- (UIControl *)overlayView {
    if (!_overlayView) {
        CGRect windowBounds = [[[[UIApplication sharedApplication] delegate] window] bounds];
        _overlayView = [[UIControl alloc] initWithFrame:windowBounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
        _overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _overlayView;
}

- (UIView *)hudView {
    if (!_hudView) {
        _hudView = [self genHUDView];
    }
    return _hudView;
}

- (UIView *)genHUDView {
    return nil;
}

- (void)makeHUDConstraints {
    
}

- (void)updateViewHierachy {
    self.userInteractionEnabled = NO;
    
    if (!self.overlayView.superview) {
        NSEnumerator * frontToBackWindows = UIApplication.sharedApplication.windows.reverseObjectEnumerator;
        for (UIWindow * window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if (!self.superview) {
        [self.overlayView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.overlayView);
        }];
    }
   
    if (!self.hudView.superview) {
        [self addSubview:self.hudView];
        [self makeHUDConstraints];
    }
}

#pragma mark - Event handling

- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent*)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:HUDDidReceiveTouchEventNotification
                                                        object:self
                                                      userInfo:nil];
    
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchLocation = [touch locationInView:self];
    
    if(CGRectContainsPoint(self.hudView.frame, touchLocation)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HUDDidTouchDownInsideNotification
                                                            object:self
                                                          userInfo:nil];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HUDOverlayViewTouched:)]) {
        [self.delegate HUDOverlayViewTouched:self];
    }
}

#pragma mark - Public Methods

- (void)show {
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateViewHierachy];
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             strongSelf.overlayView.alpha = 1.0;
                         }
                         completion:nil];
    }];
}

- (void)dismiss {
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             strongSelf.overlayView.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [strongSelf.overlayView removeFromSuperview];
                             [strongSelf removeFromSuperview];
                         }];
    }];
}

@end
