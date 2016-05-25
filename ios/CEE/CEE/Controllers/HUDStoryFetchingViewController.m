//
//  HUDStoryFetchingViewController.m
//  CEE
//
//  Created by Meng on 16/4/30.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDStoryFetchingViewController.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"
#import "UIImageView+Utils.h"
#import "CEEStory.h"


@interface HUDStoryFetchingViewController ()
@property (nonatomic, strong) UIView * panel;
@property (nonatomic, strong) UIImageView * picView;
@property (nonatomic, strong) UILabel * messageLabel;
@end

@implementation HUDStoryFetchingViewController

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
    
    self.panel = [[UIView alloc] init];
    self.panel.backgroundColor = [UIColor whiteColor];
    self.panel.layer.masksToBounds = YES;
    self.panel.layer.cornerRadius = 10;
    
    self.picView = [[UIImageView alloc] init];
    self.picView.contentMode = UIViewContentModeScaleAspectFill;
    self.picView.clipsToBounds = YES;
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.messageLabel.textColor = hexColor(0x363636);
    self.messageLabel.text = @"别闹，正在分配故事…";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:self.panel];
    [self.panel addSubview:self.picView];
    [self.panel addSubview:self.messageLabel];
    
    [self.panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(232);
        make.height.mas_equalTo(299);
    }];
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panel.mas_top);
        make.left.equalTo(self.panel.mas_left);
        make.right.equalTo(self.panel.mas_right);
        make.height.mas_equalTo(251);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView.mas_bottom);
        make.left.equalTo(self.panel.mas_left);
        make.right.equalTo(self.panel.mas_right);
        make.bottom.equalTo(self.panel.mas_bottom);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadStory:(CEEJSONStory *)story {
    [self.picView cee_setImageWithKey:story.hud_image_key];
}

@end
