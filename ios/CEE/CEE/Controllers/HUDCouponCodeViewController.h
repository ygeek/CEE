//
//  HUDCouponCodeViewController.h
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HUDCouponCodeViewController;

@protocol HUDCouponCodeViewControllerDelegate <NSObject>

- (void)couponCodeVerified:(HUDCouponCodeViewController *)controller;

@end


@interface HUDCouponCodeViewController : UIViewController
@property (nonatomic, weak) id<HUDCouponCodeViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString * couponUUID;
@end
