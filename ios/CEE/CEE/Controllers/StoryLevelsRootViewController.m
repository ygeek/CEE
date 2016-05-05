//
//  StoryLevelsRootViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

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

@interface StoryLevelsRootViewController ()

@end

@implementation StoryLevelsRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextLevel {
    NSUInteger nextIndex = self.viewControllers.count;
    if (nextIndex >= self.levels.count) {
        // TODO: 完成任务
        return;
    }
    
    UIViewController * nextVC = nil;
    
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
        
        nextVC = emptyVC;
    } else if ([type isEqualToString:@"h5"]) {
        StoryH5ViewController * h5VC = [[StoryH5ViewController alloc] init];
        
        nextVC = h5VC;
    } else {
        return;
    }
    [self pushViewController:nextVC animated:YES];
}

@end
