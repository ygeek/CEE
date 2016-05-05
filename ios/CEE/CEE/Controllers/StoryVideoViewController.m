//
//  StoryVideoViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import AVKit;
@import AVFoundation;
@import Masonry;
@import ReactiveCocoa;


#import <PromiseKit/PromiseKit.h>

#import "StoryVideoViewController.h"
#import "StoryLevelsRootViewController.h"
#import "CEEDownloadURLAPI.h"


@interface StoryVideoViewController () <AVPlayerViewControllerDelegate>
@property (nonatomic, strong) AVPlayerViewController * playerVC;
@property (nonatomic, assign) BOOL videoPlayed;
@end

@implementation StoryVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoPlayed = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationItem setHidesBackButton:YES];
    
    self.playerVC = [[AVPlayerViewController alloc] init];
    
    self.playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backPressed:)];
    backItem.tintColor = UIColor.whiteColor;
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.videoPlayed) {
        [self loadVideoURL];
    } else {
        StoryLevelsRootViewController * levelsRoot = (StoryLevelsRootViewController *)(self.navigationController);
        [levelsRoot nextLevel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDidFinishPlaying:(NSNotification *)notification {
    [self.playerVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadVideoURL {
    [[CEEDownloadURLAPI api] requestURLWithKey:self.videoKey].then(^(NSString * url) {
        self.playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playerVC.player.currentItem];
        
        [self presentViewController:self.playerVC animated:YES completion:^{
            [self.playerVC.player play];
            self.videoPlayed = YES;
        }];
    }).catch(^(NSError *error) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"网络问题"
                                                                        message:@"读取视频数据失败，重试一下吧。"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"重试"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
            [self loadVideoURL];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - AVPlayerViewControllerDelegate



@end
