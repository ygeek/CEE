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
#import "CEETask.h"
#import "UIImageView+Utils.h"


@interface TaskViewController ()
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) TaskQuestionView * questionView;
@property (nonatomic, strong) TaskAnswerView * answerView;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) BOOL everWrong;
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
    
    self.everWrong = NO;
    self.currentIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    
    self.containerView = [[UIView alloc] init];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.questionView = [[TaskQuestionView alloc] init];
    [self.questionView.confirmButton addTarget:self
                                        action:@selector(confirmPressed:)
                              forControlEvents:UIControlEventTouchUpInside];
    [self.questionView.closeButton addTarget:self
                                      action:@selector(closePressed:)
                            forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.questionView];
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    self.answerView = [[TaskAnswerView alloc] init];
    [self.answerView.nextButton addTarget:self
                                   action:@selector(nextPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.answerView.closeButton addTarget:self
                                    action:@selector(closePressed:)
                          forControlEvents:UIControlEventTouchUpInside];
    
    [self loadChoiceAtIndex:self.currentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmPressed:(id)sender {
    if ([self.task.choices[self.currentIndex] answer].integerValue != self.questionView.selectedIndex) {
        self.everWrong = YES;
    }
    
    [UIView transitionWithView:self.containerView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self.questionView removeFromSuperview];
                        [self.containerView addSubview:self.answerView];
                        [self.answerView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo(self.containerView);
                        }];
                    } completion:NULL];
}

- (void)nextPressed:(id)sender {
    self.currentIndex++;
    if (self.currentIndex >= self.task.choices.count) {
        if (!self.everWrong) {
            [self.delegate task:self.task completedInController:self];
        } else {
            [self.delegate task:self.task failedInController:self];
        }
    } else {
        [self loadChoiceAtIndex:self.currentIndex];
        [UIView transitionWithView:self.containerView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.answerView removeFromSuperview];
                            [self.containerView addSubview:self.questionView];
                            [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.edges.equalTo(self.containerView);
                            }];
                        } completion:NULL];
    }
}

- (void)closePressed:(id)sender {
    [self.delegate task:self.task failedInController:self];
}

- (void)loadChoiceAtIndex:(NSInteger)index {
    CEEJSONChoice * choice = self.task.choices[index];
    [self.questionView.photoView cee_setImageWithKey:choice.image_key];
    self.questionView.questionLabel.text = choice.desc;
    [self.questionView setLocation:self.task.location];
    
    NSArray * options = [choice.options sortedArrayUsingComparator:^NSComparisonResult(CEEJSONOption *obj1, CEEJSONOption *obj2) {
        if (obj1.order.integerValue < obj2.order.integerValue) {
            return NSOrderedAscending;
        } else if (obj1.order.integerValue > obj2.order.integerValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    [self.questionView loadOptions:[options valueForKeyPath:@"desc"]];
    
    self.answerView.photoView.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(232, 144)];
    [self.answerView.photoView cee_setImageWithKey:choice.answer_image_key];
    self.answerView.titleLabel.text = [choice.options[choice.answer.integerValue] desc];
    self.answerView.detailLabel.text = choice.answer_message;
}

@end
