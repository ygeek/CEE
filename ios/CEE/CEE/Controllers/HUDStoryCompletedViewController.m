//
//  HUDBaseViewController.m
//  CEE
//
//  Created by Meng on 16/4/28.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDStoryCompletedViewController.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"

@interface HUDStoryCompletedViewController ()
@property (nonatomic, strong) UIView * panel;
@property (nonatomic, strong) UIImageView * picView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) NSTextAttachment * coinAttachment;
@property (nonatomic, strong) UILabel * moneyLabel;
@property (nonatomic, strong) UIButton * confirmButton;
@end


@implementation HUDStoryCompletedViewController

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
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = @"恭喜任务达成！";
    
    self.coinAttachment = [[NSTextAttachment alloc] init];
    UIImage * coinIcon = [UIImage imageNamed:@"钱币"];
    self.coinAttachment.image = coinIcon;
    UIFont * font = [UIFont fontWithName:kCEEFontNameRegular size:21];
    CGFloat mid = font.descender + font.capHeight;
    self.coinAttachment.bounds = CGRectIntegral(CGRectMake(-10,
                                                           font.descender - coinIcon.size.height / 2 + mid + 5,
                                                           coinIcon.size.width,
                                                           coinIcon.size.height));
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = kCEEThemeYellowColor;
    [self.confirmButton setTitleColor:hexColor(0x363636) forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:self.panel];
    [self.panel addSubview:self.picView];
    [self.panel addSubview:self.messageLabel];
    [self.panel addSubview:self.moneyLabel];
    [self.panel addSubview:self.confirmButton];
    
    [self.panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(232);
        make.height.mas_equalTo(186 + 65 + 48);
    }];
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panel.mas_top);
        make.left.equalTo(self.panel.mas_left);
        make.right.equalTo(self.panel.mas_right);
        make.height.mas_equalTo(186);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panel.mas_centerX);
        make.bottom.equalTo(self.picView.mas_bottom).offset(-20);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView.mas_bottom);
        make.left.equalTo(self.panel.mas_left);
        make.right.equalTo(self.panel.mas_right);
        make.bottom.equalTo(self.confirmButton.mas_top);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panel.mas_left);
        make.right.equalTo(self.panel.mas_right);
        make.bottom.equalTo(self.panel.mas_bottom);
        make.height.mas_equalTo(48);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSampleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadSampleData {
    self.picView.image = [UIImage imageWithColor:[UIColor greenColor] size:CGSizeMake(232, 186)];
    NSAttributedString * coinAttrStr = [NSAttributedString attributedStringWithAttachment:self.coinAttachment];
    NSAttributedString * moneyAttrStr =
    [[NSAttributedString alloc] initWithString:@"+100"
                                    attributes:@{NSForegroundColorAttributeName: hexColor(0xdfaa4a),
                                                 NSFontAttributeName:[UIFont fontWithName:kCEEFontNameRegular size:21]}];
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] initWithAttributedString:coinAttrStr];
    [result appendAttributedString:moneyAttrStr];
    self.moneyLabel.attributedText = result;
}

@end
