//
//  StoryLevelsRootViewController.h
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONLevel;

@interface StoryLevelsRootViewController : UINavigationController

@property (nonatomic, strong) NSArray<CEEJSONLevel *> * levels;

- (void)nextLevel;

@end
