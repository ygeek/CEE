//
//  StoryLevelsRootViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import SVProgressHUD;
@import RDVTabBarController;

#import <PromiseKit/PromiseKit.h>

#import "StoryLevelsRootViewController.h"
#import "StoryDialogViewController.h"
#import "StoryVideoViewController.h"
#import "StoryNumberPuzzleViewController.h"
#import "StoryTextPuzzleViewController.h"
#import "StoryEmptyViewController.h"
#import "StoryH5ViewController.h"
#import "CEEStory.h"
#import "CEEImageManager.h"
#import "CEECompleteStoryLevelAPI.h"
#import "CEEStoryCompleteAPI.h"
#import "HUDCouponAcquiringViewController.h"
#import "CEENotificationNames.h"

@interface StoryLevelsRootViewController ()
@property (nonatomic, assign) NSInteger currentLevel;
@end

@implementation StoryLevelsRootViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.currentLevel = -1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextLevel {
    if (self.currentLevel < 0) {
        self.currentLevel = self.story.progress.integerValue;
        [self jumpToNextLevel];
        return;
    }
    
    [SVProgressHUD show];
    [[CEECompleteStoryLevelAPI api] completeStoryID:self.story.id
                                        withLevelID:self.levels[self.currentLevel].id]
    .then(^(NSArray<CEEJSONAward *> * awards) {
        [SVProgressHUD dismiss];
        
        NSUInteger nextIndex = self.currentLevel + 1;
        if (nextIndex >= self.levels.count) {
            [SVProgressHUD show];
            [[CEEStoryCompleteAPI api] completeStoryID:self.story.id].then(^(NSArray<CEEJSONAward *> * awards) {
                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kCEEStoryCompleteNotificationName
                                                                    object:self
                                                                  userInfo:@{kCEEStoryCompleteAwardsKey: awards}];
                [self dismissViewControllerAnimated:YES completion:nil];
            }).catch(^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            });
        } else {
            if (awards.count > 0) {
                HUDCouponAcquiringViewController * couponHUD = [[HUDCouponAcquiringViewController alloc] init];
                [self.rdv_tabBarController presentViewController:couponHUD animated:YES completion:^{
                    [self jumpToNextLevel];
                }];
            } else {
                [self jumpToNextLevel];
            }
        }
    }).catch(^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    });
}

- (void)jumpToNextLevel {
    UIViewController * nextVC = nil;
    
    NSUInteger nextIndex = ++self.currentLevel;
    CEEJSONLevel * level = self.levels[nextIndex];
    
    NSString * type = level.content[@"type"];
    if ([type isEqualToString:@"dialog"]) {
        StoryDialogViewController * dialogVC = [[StoryDialogViewController alloc] init];
        [[CEEImageManager manager] queryImageForKey:level.content[@"img"]]
        .then(^(UIImage *image) {
            [dialogVC setImage:image];
        });
        dialogVC.sayer = level.content[@"sayer"];
        dialogVC.text = level.content[@"text"];
        [dialogVC reloadData];
        nextVC = dialogVC;
    } else if ([type isEqualToString:@"video"]) {
        StoryVideoViewController * videoVC = [[StoryVideoViewController alloc] init];
        videoVC.videoKey = level.content[@"video_key"];
        nextVC = videoVC;
    } else if ([type isEqualToString:@"number"]) {
        StoryNumberPuzzleViewController * numberVC = [[StoryNumberPuzzleViewController alloc] init];
        [[CEEImageManager manager] queryImageForKey:level.content[@"img"]]
        .then(^(UIImage *image) {
            [numberVC setImage:image];
        });
        numberVC.text = level.content[@"text"];
        numberVC.answer = level.content[@"answer"];
        nextVC = numberVC;
    } else if ([type isEqualToString:@"text"]) {
        StoryTextPuzzleViewController * textVC = [[StoryTextPuzzleViewController alloc] init];
        [[CEEImageManager manager] queryImageForKey:level.content[@"img"]]
        .then(^(UIImage * image) {
            textVC.image = image;
        });
        textVC.text = level.content[@"text"];
        textVC.answer = level.content[@"answer"];
        nextVC = textVC;
    } else if ([type isEqualToString:@"empty"]) {
        StoryEmptyViewController * emptyVC = [[StoryEmptyViewController alloc] init];
        [[CEEImageManager manager] queryImageForKey:level.content[@"img"]]
        .then(^(UIImage *image) {
            emptyVC.image = image;
        });
        emptyVC.requiredEvent = level.content[@"event"];
        nextVC = emptyVC;
    } else if ([type isEqualToString:@"h5"]) {
        StoryH5ViewController * h5VC = [[StoryH5ViewController alloc] init];
        h5VC.url = level.content[@"url"];
        nextVC = h5VC;
    } else {
        return;
    }
    
    [self pushViewController:nextVC animated:YES];
}

- (NSArray<CEEJSONLevel *> *)completedLevels {
    return [self.levels subarrayWithRange:NSMakeRange(0, self.viewControllers.count)];
}

@end
