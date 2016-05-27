//
//  JSONValueTransformer+NSDate.h
//  CEE
//
//  Created by Meng on 16/5/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>

@interface JSONValueTransformer (NSDate)

- (NSDate *)NSDateFromNSString:(NSString*)string;

- (NSString *)JSONObjectFromNSDate:(NSDate *)date;

@end
