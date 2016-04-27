//
//  HUDBaseView.h
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString * const HUDDidReceiveTouchEventNotification;
extern NSString * const HUDDidTouchDownInsideNotification;

@class HUDBaseView;


@protocol HUDViewDelegate <NSObject>

- (void)HUDOverlayViewTouched:(HUDBaseView *)view;

@end


@interface HUDBaseView : UIView
@property (nonatomic, weak) id<HUDViewDelegate> delegate;
@property (nonatomic, strong) UIControl * overlayView;
@property (nonatomic, strong) UIView * hudView;
@property (nonatomic, assign) CGFloat overlayAlpha;
- (void)show;
- (void)dismiss;
- (void)updateViewHierachy;
- (void)updateData;
- (UIView *)genHUDView;
- (void)makeHUDConstraints;
- (void)commonInit;
@end
