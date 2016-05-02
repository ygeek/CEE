//
//  MapPanelView.h
//  CEE
//
//  Created by Meng on 16/4/24.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import PromiseKit;

#import <UIKit/UIKit.h>

#import "CEEMap.h"

@interface MapPanelView : UIView
@property (nonatomic, strong) NSArray<UIButton *> * mapButtons;
@property (nonatomic, strong) UIButton * moreMapButton;

- (AnyPromise *)loadAcquiredMaps:(NSArray<CEEJSONMap *> *)maps;

@end
