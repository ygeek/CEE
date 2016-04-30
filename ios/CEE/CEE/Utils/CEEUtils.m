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

+ (BOOL)isValidPassword:(NSString *)password {
    if ( [password length]<6 || [password length]>32 ) return NO;  // too long or too short
    NSRange rang;
    rang = [password rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    if ( !rang.length ) return NO;  // no lower case letter
    rang = [password rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    if ( !rang.length ) return NO;  // no upper case letter
    rang = [password rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )  return NO;  // no number;
    return YES;
}

@end
