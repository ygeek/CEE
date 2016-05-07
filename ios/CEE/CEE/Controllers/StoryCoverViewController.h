//
//  StoryCoverViewController.h
//  CEE
//
//  Created by Meng on 16/4/17.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONStory;
@class CEEJSONLevel;


@interface StoryCoverViewController : UIViewController
@property (nonatomic, strong) CEEJSONStory * story;
@property (nonatomic, strong) NSArray<CEEJSONLevel *> * levels;
@end
