//
//  StoryItemsViewController.h
//  CEE
//
//  Created by Meng on 16/5/5.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEEStory.h"

@interface StoryItemsViewController : UIViewController
@property (nonatomic, strong) NSArray<CEEJSONLevel *> * completedLevels;
@property (nonatomic, strong) NSArray<CEEJSONItem *> * items;
@end
