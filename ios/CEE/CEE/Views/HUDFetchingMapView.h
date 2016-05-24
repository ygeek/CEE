//
//  HUDFetchingMapView.h
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "HUDBaseView.h"
#import "CEEMap.h"

@interface HUDFetchingMapView : HUDBaseView
@property (nonatomic, strong) CEEJSONMap * map;
@end
