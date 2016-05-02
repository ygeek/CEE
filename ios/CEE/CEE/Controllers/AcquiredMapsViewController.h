//
//  AcquiredMapsViewController.h
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEEMap.h"

@interface AcquiredMapsViewController : UIViewController
@property (nonatomic, strong) NSArray<CEEJSONMap *> * maps;
@end
