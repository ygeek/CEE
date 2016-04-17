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


@interface HUDBaseView : UIView
@property (nonatomic, strong) UIControl * overlayView;
@property (nonatomic, strong) CALayer * backgroundLayer;
@property (nonatomic, strong) UIView * hudView;
- (void)show;
- (void)dismiss;
- (void)updateViewHierachy;
- (void)updateMask;
@end
