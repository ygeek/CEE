//
//  HUDNewMapViewController.h
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CEEJSONMap;


@interface HUDNewMapViewController : UIViewController

- (void)loadMap:(CEEJSONMap *)map;

@end
