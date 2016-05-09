//
//  ProgressBatteryView.h
//  CEE
//
//  Created by Meng on 16/5/9.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBatteryView : UIView
@property (nonatomic, strong) UIImageView * frameView;
@property (nonatomic, strong) NSArray<UIImageView *> * lineViews;
@property (nonatomic, assign) CGFloat progress;
@end
