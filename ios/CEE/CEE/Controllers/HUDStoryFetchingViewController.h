//
//  HUDStoryFetchingViewController.h
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONStory;

@interface HUDStoryFetchingViewController : UIViewController

- (void)loadStory:(CEEJSONStory *)story;

@end
