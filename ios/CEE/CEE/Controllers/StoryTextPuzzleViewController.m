//
//  StoryTextPuzzleViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import ReactiveCocoa;
@import Masonry;
@import SVProgressHUD;


#import "StoryTextPuzzleViewController.h"
#import "AppearanceConstants.h"
#import "StoryLevelsRootViewController.h"
#import "StoryItemsViewController.h"


@interface StoryTextPuzzleViewController ()
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UITextField * answerField;
@property (nonatomic, strong) UIView * underLine;
@property (nonatomic, strong) UIButton * confirmButton;
@end

@implementation StoryTextPuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = hexColor(0x666666);
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    
    self.contentView = [[UIView alloc] init];
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:tapRecognizer];
    [self.contentScrollView addSubview:self.contentView];
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = rgbColor(131, 131, 131);
    [self.contentView addSubview:self.backgroundView];
    
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    self.messageLabel.textColor = kCEETextBlackColor;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 4;
    [self.contentView addSubview:self.messageLabel];
    
    self.answerField = [[UITextField alloc] init];
    self.answerField.textAlignment = NSTextAlignmentCenter;
    self.answerField.textColor = kCEETextBlackColor;
    self.answerField.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    self.answerField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"输  入"
                                    attributes:@{NSForegroundColorAttributeName: hexColor(0x929292),
                                                 NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:18]}];
    [self.contentView addSubview:self.answerField];
    
    self.underLine = [[UIView alloc] init];
    self.underLine.backgroundColor = kCEECircleGrayColor;
    [self.contentView addSubview:self.underLine];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = hexColor(0xefe529);
    [self.confirmButton setTitle:@"确  认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    [self.confirmButton addTarget:self
                           action:@selector(confirmPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.confirmButton];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
    }];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(70);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(350);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(406);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_bottom);
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        make.bottom.equalTo(self.answerField.mas_top);
    }];
    
    [self.answerField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-16);
        make.height.mas_equalTo(25);
        make.left.equalTo(self.backgroundView.mas_left);
        make.right.equalTo(self.backgroundView.mas_right);
    }];
    
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.answerField.mas_bottom);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(124);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-49);
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)confirmPressed:(id)sender {
    if ([self.answerField.text isEqualToString:self.answer]) {
        StoryLevelsRootViewController * levelsRoot = (StoryLevelsRootViewController *)(self.navigationController);
        [levelsRoot nextLevel];
    } else {
        [SVProgressHUD showInfoWithStatus:@"答案不正确"];
    }
}

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSUInteger animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationCurve|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGFloat keyboardHeight = [UIScreen mainScreen].bounds.size.height - endFrame.origin.y;
                         self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
                     }
                     completion:nil];
    
    if (self.answerField.isFirstResponder) {
        [self.contentScrollView scrollRectToVisible:self.answerField.frame animated:YES];
    }
}

@end
