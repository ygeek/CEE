//
//  StoryDialogViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//


@import Masonry;


#import "StoryDialogViewController.h"
#import "AppearanceConstants.h"
#import "UIImageView+Utils.h"
#import "StoryLevelsRootViewController.h"


@interface StoryDialogViewController ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIView * textBoxView;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UIButton * skipButton;
@end


@implementation StoryDialogViewController

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
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.textBoxView = [[UIView alloc] init];
    self.textBoxView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:25];
    self.textLabel.textColor = kCEETextBlackColor;
    self.textLabel.numberOfLines = 10;
    self.textLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 40 - 36;
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.skipButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.skipButton setTitle:@"skip" forState:UIControlStateNormal];
    self.skipButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:25];
    [self.skipButton addTarget:self action:@selector(skipPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.textBoxView];
    [self.view addSubview:self.skipButton];
    [self.textBoxView addSubview:self.textLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.textBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
        make.right.equalTo(self.textBoxView.mas_right);
        make.bottom.equalTo(self.textBoxView.mas_top).offset(-5);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
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

- (void)skipPressed:(id)sender {
    StoryLevelsRootViewController * levelsRoot = (StoryLevelsRootViewController *)(self.navigationController);
    [levelsRoot nextLevel];
}

- (void)backPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)archivePressed:(id)sender {
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [UIView transitionWithView:self.imageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.imageView.image = image;
                    } completion:nil];
}

- (void)reloadData {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 35;
    
    NSString * content = nil;
    if (self.sayer && self.sayer.length > 0) {
        content = [NSString stringWithFormat:@"%@:\n%@", self.sayer, self.text];
    } else {
        content = self.text;
    }
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:content];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    
    self.textLabel.attributedText = attrString;
    
    if (self.sayer && self.sayer.length > 0) {
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.textBoxView).insets(UIEdgeInsetsMake(14, 18, 56, 18));
        }];
        
    } else {
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.textBoxView).insets(UIEdgeInsetsMake(44, 18, 44, 18));
        }];
    }
}

@end
