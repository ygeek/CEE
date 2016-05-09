//
//  StoryH5PuzzleViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import SVProgressHUD;

#import "StoryH5ViewController.h"
#import "StoryLevelsRootViewController.h"
#import "StoryItemsViewController.h"

@interface StoryH5ViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * webView;
@end

@implementation StoryH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backPressed:)];
    backItem.tintColor = UIColor.whiteColor;
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem * archiveItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"归档"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(archivePressed:)];
    archiveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = archiveItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSURL * url = [NSURL URLWithString:self.url];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)backPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)archivePressed:(id)sender {
    StoryLevelsRootViewController * levelsRoot = (StoryLevelsRootViewController *)(self.navigationController);
    StoryItemsViewController * itemsVC = [[StoryItemsViewController alloc] init];
    itemsVC.completedLevels = levelsRoot.completedLevels;
    itemsVC.items = levelsRoot.items;
    UINavigationController * navVC = [[UINavigationController alloc] initWithRootViewController:itemsVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [SVProgressHUD dismiss];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"加载失败"
                                                                    message:@"好像加载失败啦，需要重新加载吗？"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"重加载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:self.url];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"不用了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self backPressed:nil];
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ( [[[request URL] scheme] isEqualToString:@"next"] ) {
        StoryLevelsRootViewController * levelsRoot = (StoryLevelsRootViewController *)(self.navigationController);
        [levelsRoot nextLevel];
        return NO;
    }
    return YES;
}

@end
