//
//  HUDBaseViewController.h
//  CEE
//
//  Created by Meng on 16/4/28.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEETask.h"
#import "CEEAward.h"

@class CEEJSONStory;

@interface HUDTaskCompletedViewController : UIViewController

@property (nonatomic, strong) CEEJSONStory * story;

- (void)loadAwards:(NSArray<CEEJSONAward *> *)awards andImageKey:(NSString *)imageKey;

@end
