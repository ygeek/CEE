//
//  CEEUtils.m
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "CEEUtils.h"

@implementation CEEUtils

+ (void)printAllFontNames {
    NSArray* familyNames = [UIFont familyNames];
    for (NSString * familyName in familyNames) {
        NSArray * fontNames = [UIFont fontNamesForFamilyName:familyName];
        for (NSString * fontName in fontNames) {
            printf("\tFont: %s \n", [fontName UTF8String]);
        }
    }
}

@end
