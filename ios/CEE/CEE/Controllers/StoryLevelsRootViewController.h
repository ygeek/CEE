//
//  StoryLevelsRootViewController.h
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONStory;
@class CEEJSONLevel;
@class CEEJSONItem;

@interface StoryLevelsRootViewController : UINavigationController
@property (nonatomic, strong) CEEJSONStory * story;
@property (nonatomic, strong) NSArray<CEEJSONLevel *> * levels;
@property (nonatomic, strong) NSArray<CEEJSONItem *> * items;

- (void)nextLevel;

- (NSArray<CEEJSONLevel *> *)completedLevels;

@end
