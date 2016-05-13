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


@protocol MapPanelViewDelegate <NSObject>

- (void)mapPressed:(CEEJSONMap *)map;

@end


@interface MapPanelView : UIView
@property (nonatomic, weak) id<MapPanelViewDelegate> delegate;
@property (nonatomic, strong) NSArray<UIButton *> * mapButtons;
@property (nonatomic, strong) UIButton * moreMapButton;
@property (nonatomic, strong) NSArray<CEEJSONMap *> * maps;

- (AnyPromise *)loadAcquiredMaps:(NSArray<CEEJSONMap *> *)maps;

@end
