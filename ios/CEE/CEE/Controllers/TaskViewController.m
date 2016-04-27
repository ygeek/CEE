//
//  TaskViewController.m
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "TaskViewController.h"
#import "TaskQuestionView.h"
#import "TaskAnswerView.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"


@interface TaskViewController ()
@property (nonatomic, strong) TaskQuestionView * questionView;
@property (nonatomic, strong) TaskAnswerView * answerView;
@end


@implementation TaskViewController

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
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    
    [self loadSampleQuestionView];
    [self loadSampleAnswerView];
    
    [self.view addSubview:self.questionView];
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmPressed:(id)sender {
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.questionView removeFromSuperview];
                        [self.view addSubview:self.answerView];
                        [self.answerView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo(self.view);
                        }];
                    } completion:NULL];
}

- (void)loadSampleQuestionView {
    self.questionView = [[TaskQuestionView alloc] init];

    [self.questionView.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.questionView.photoView.image = [UIImage imageWithColor:kCEEThemeYellowColor size:CGSizeMake(232, 79)];
    self.questionView.questionLabel.text = @"这是一段测试";
    [self.questionView loadOptions:@[@"选项A", @"选项B", @"选项C", @"选项D"]];
    [self.questionView setLocation:@"八一路100号"];
    
    [self.view addSubview:self.questionView];
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadSampleAnswerView {
    self.answerView = [[TaskAnswerView alloc] init];

    self.answerView.photoView.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(232, 144)];
    self.answerView.titleLabel.text = @"可乐加冰不解释";
    self.answerView.detailLabel.text = @"妥妥的~";
}

@end
