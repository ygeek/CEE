//
//  StoryNumberPuzzleViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import ReactiveCocoa;
@import SVProgressHUD;


#import "StoryNumberPuzzleViewController.h"
#import "HUDNumberInputViewController.h"
#import "StoryLevelsRootViewController.h"
#import "AppearanceConstants.h"

@interface StoryNumberPuzzleViewController () <HUDNumberInputViewControllerDelegate>
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIButton * inputButton;
@end

@implementation StoryNumberPuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = hexColor(0x666666);
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = rgbColor(131, 131, 131);
    [self.view addSubview:self.backgroundView];
   
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    self.messageLabel.textColor = kCEETextBlackColor;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 4;
    [self.view addSubview:self.messageLabel];
    
    self.inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.inputButton.backgroundColor = hexColor(0xefe529);
    [self.inputButton setTitle:@"输  入" forState:UIControlStateNormal];
    [self.inputButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    self.inputButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    [self.inputButton addTarget:self action:@selector(inputPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputButton];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(70);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(350);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(406);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_bottom);
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        make.bottom.equalTo(self.inputButton.mas_top);
    }];
    
    [self.inputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        make.height.mas_equalTo(66);
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
    
    RAC(self, imageView.image) = [RACObserve(self, image) doNext:^(UIImage * image) {
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 40;
        CGFloat maxHeight = 406;
        if (image.size.width > maxWidth || image.size.height > maxHeight) {
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            self.imageView.contentMode = UIViewContentModeCenter;
        }
    }];
    RAC(self, messageLabel.text) = RACObserve(self, text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inputPressed:(id)sender {
    HUDNumberInputViewController * hud = [[HUDNumberInputViewController alloc] init];
    hud.answer = self.answer;
    hud.delegate = self;
    [self presentViewController:hud animated:YES completion:nil];
}

- (void)backPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)archivePressed:(id)sender {
    
}

#pragma mark - HUDNumberInputViewControllerDelegate

- (void)numberInputController:(HUDNumberInputViewController *)controller didSelectNumbers:(NSString *)numbers {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([numbers isEqualToString:self.answer]) {
            StoryLevelsRootViewController * levelsRoot = (StoryLevelsRootViewController *)(self.navigationController);
            [levelsRoot nextLevel];
        } else {
            [SVProgressHUD showInfoWithStatus:@"答案不正确"];
        }
    }];
}

@end
