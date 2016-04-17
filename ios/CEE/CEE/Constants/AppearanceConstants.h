//
//  AppearanceConstants.h
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCEEFontNameExtraLight @"SourceHanSansCN-ExtraLight"
#define kCEEFontNameLight      @"SourceHanSansCN-Light"
#define kCEEFontNameMedium     @"SourceHanSansCN-Medium"
#define kCEEFontNameRegular    @"SourceHanSansCN-Regular"
#define kCEEFontNameNormal     @"SourceHanSansCN-Normal"
#define kCEEFontNameBold       @"SourceHanSansCN-Bold"
#define kCEEFontNameHeavy      @"SourceHanSansCN-Heavy"
#define kGoboldFontNameRegular @"Gobold"


UIColor* hexColor(NSUInteger hex);
UIColor* rgbColor(NSUInteger r, NSUInteger g, NSUInteger b);
UIColor* rgbaColor(NSUInteger r, NSUInteger g, NSUInteger b, NSUInteger a);

#define kCEEThemeYellowColor           hexColor(0xf1e535)
#define kCEETextBlackColor             hexColor(0x040000)
#define kCEETabBarUnselectedTitleColor hexColor(0xffffff)
#define kCEETabBarSelectedTitleColor   hexColor(0xf1e535)
#define kCEETabBarBadgeBackgroundColor hexColor(0xf1e535)
#define kCEEStoryMenuTextColor         hexColor(0x333333)
#define kCEETagBackgroundColor         rgbColor(201, 201, 201);