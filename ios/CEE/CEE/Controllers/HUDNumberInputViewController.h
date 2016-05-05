//
//  StoryNumberInputViewController.h
//  CEE
//
//  Created by Meng on 16/5/5.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HUDNumberInputViewController;


@protocol HUDNumberInputViewControllerDelegate <NSObject>

- (void)numberInputController:(HUDNumberInputViewController *)controller didSelectNumbers:(NSString *)numbers;

@end


@interface HUDNumberInputViewController : UIViewController
@property (nonatomic, weak) id<HUDNumberInputViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString * answer;
@end
