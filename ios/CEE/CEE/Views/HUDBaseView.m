//
//  HUDBaseView.m
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

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
    }
    return _overlayView;
}

- (void)updateViewHierachy {
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
    }
    if (!self.hudView.superview) {
        [self addSubview:self.hudView];
    }
}

- (void)updateMask {
    if (self.backgroundLayer) {
        [self.backgroundLayer removeFromSuperlayer];
        self.backgroundLayer = nil;
    }
    self.backgroundLayer = [CALayer layer];
    self.backgroundLayer.frame = self.bounds;
    self.backgroundLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
    [self.backgroundLayer setNeedsDisplay];
    [self.layer insertSublayer:self.backgroundLayer atIndex:0];
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
}

#pragma mark - Public Methods

- (void)show {
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateViewHierachy];
        [strongSelf updateMask];
        // TODO (zhangmeng): animation
    }];
}

- (void)dismiss {
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // TODO (zhangmeng): animation
        [strongSelf.overlayView removeFromSuperview];
        [strongSelf removeFromSuperview];
    }];
}

@end
