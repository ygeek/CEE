//
//  JSONValueTransformer+NSDate.m
//  CEE
//
//  Created by Meng on 16/5/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "JSONValueTransformer+NSDate.h"

#define APIDateFormat @"yyyy-MM-dd"

@implementation JSONValueTransformer (NSDate)

- (NSDate *)NSDateFromNSString:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:APIDateFormat];
    return [formatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:APIDateFormat];
    return [formatter stringFromDate:date];
}

@end
