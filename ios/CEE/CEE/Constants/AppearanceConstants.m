//
//  AppearanceConstants.m
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "AppearanceConstants.h"


UIColor * hexColor(NSUInteger rgbValue) {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0x00FF00) >>  8) / 255.0
                            blue:((rgbValue & 0x0000FF) >>  0) / 255.0
                           alpha:1.0];
}

UIColor * rgbColor(NSUInteger r, NSUInteger g, NSUInteger b) {
    return rgbaColor(r, g, b, 255);
}


UIColor * rgbaColor(NSUInteger r, NSUInteger g, NSUInteger b, NSUInteger a) {
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:a / 255.0];
}

CGFloat verticalScale() {
    CGFloat height = UIScreen.mainScreen.bounds.size.height;
    if (height <= 480) return 0.7;
    if (height <= 568) return 0.8;
    return 1.0;
}