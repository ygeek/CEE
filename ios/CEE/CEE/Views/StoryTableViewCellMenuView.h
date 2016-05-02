//
//  StoryTableViewCellMenuView.h
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONStory;


@interface StoryTableViewCellMenuView : UIView

- (void)loadStory:(CEEJSONStory *)story;

@end
