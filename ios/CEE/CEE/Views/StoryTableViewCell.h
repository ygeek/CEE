//
//  StoryTableViewCell.h
//  CEE
//
//  Created by Meng on 16/4/16.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <ABMenuTableViewCell/ABMenuTableViewCell.h>

@class CEEJSONStory;

@interface StoryTableViewCell : ABMenuTableViewCell

- (void)loadStory:(CEEJSONStory *)story;

@end
