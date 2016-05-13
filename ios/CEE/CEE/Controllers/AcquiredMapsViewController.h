//
//  AcquiredMapsViewController.h
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEEMap.h"

@class AcquiredMapsViewController;

@protocol AcquiredMapsViewControllerDelegate <NSObject>

- (void)acquiredMapsViewController:(AcquiredMapsViewController *)controller didSelectMap:(CEEJSONMap *)map;

@end

@interface AcquiredMapsViewController : UIViewController
@property (nonatomic, weak) id<AcquiredMapsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray<CEEJSONMap *> * maps;
@end
