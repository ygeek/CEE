//
//  HUDBaseViewController.h
//  CEE
//
//  Created by Meng on 16/4/28.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEETask.h"

@interface HUDTaskCompletedViewController : UIViewController

- (void)loadAwards:(NSArray<CEEJSONAward *> *)awards andImageKey:(NSString *)imageKey;

@end
