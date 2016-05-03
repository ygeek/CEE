//
//  TaskViewController.h
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CEEJSONTask;
@class TaskViewController;


@protocol TaskViewControllerDelegate <NSObject>

- (void)task:(CEEJSONTask *)task completedInController:(TaskViewController *)controller;

- (void)task:(CEEJSONTask *)task failedInController:(TaskViewController *)controller;

@end


@interface TaskViewController : UIViewController
@property (nonatomic, weak) id<TaskViewControllerDelegate> delegate;
@property (nonatomic, strong) CEEJSONTask * task;
@end
