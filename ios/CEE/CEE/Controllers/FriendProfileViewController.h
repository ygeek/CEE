//
//  FriendProfileViewController.h
//  CEE
//
//  Created by Meng on 16/5/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEEFriendInfo.h"
#import "CEEMedal.h"

@interface FriendProfileViewController : UIViewController
@property (nonatomic, strong) CEEJSONFriendInfo * friendInfo;
@property (nonatomic, strong) NSArray<CEEJSONMedal *> * medals;
@end
