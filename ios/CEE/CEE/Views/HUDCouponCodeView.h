//
//  HUDCouponCodeView.h
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "HUDBaseView.h"


@protocol HUDCouponCodeViewDelegate <NSObject>

- (void)couponCodeChanged:(NSString *)code;

@end


@interface HUDCouponCodeView : UIView
@property (nonatomic, weak) id<HUDCouponCodeViewDelegate> delegate;
@property (nonatomic) UIKeyboardType keyboardType;
@end
