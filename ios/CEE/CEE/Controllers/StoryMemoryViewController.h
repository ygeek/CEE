//
//  StoryMemoryViewController.h
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONLevel;

@interface StoryMemoryViewController : UIViewController
@property (nonatomic, strong) NSArray<CEEJSONLevel *> * levels;
@end
