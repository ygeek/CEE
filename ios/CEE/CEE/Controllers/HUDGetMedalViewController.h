//
//  HUDGetMedalViewController.h
//  CEE
//
//  Created by Meng on 16/5/14.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONAward;

@interface HUDGetMedalViewController : UIViewController

- (void)loadAward:(CEEJSONAward *)award;

@end
