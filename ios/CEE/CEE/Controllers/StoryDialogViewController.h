//
//  StoryDialogViewController.h
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryDialogViewController : UIViewController
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, copy) NSString * sayer;
@property (nonatomic, copy) NSString * text;

- (void)reloadData;
    
@end
