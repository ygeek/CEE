//
//  FillProfileViewController.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "FillProfileViewController.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"

@interface FillProfileViewController ()
@property (nonatomic, strong) UIView * headShadowView;
@property (nonatomic, strong) UIImageView * headView;
@property (nonatomic, strong) UIButton * headEditButton;

@property (nonatomic, strong) UILabel * nicknameLabel;
@property (nonatomic, strong) UIView * nicknameSeperator;
@property (nonatomic, strong) UITextField * nicknameField;

@property (nonatomic, strong) UILabel * sexLabel;
@property (nonatomic, strong) UIView * sexSeperator;
@property (nonatomic, strong) UIButton * maleButton;
@property (nonatomic, strong) UILabel * maleLabel;
@property (nonatomic, strong) UIButton * femaleButton;
@property (nonatomic, strong) UILabel * femaleLabel;

@property (nonatomic, strong) UILabel * birthdayLabel;
@property (nonatomic, strong) UIView * birthdaySeperator;
@property (nonatomic, strong) UILabel * birthdayField;

@property (nonatomic, strong) UILabel * locationLabel;
@property (nonatomic, strong) UIView * locationSeperator;
@property (nonatomic, strong) UILabel * locationField;

@property (nonatomic, strong) UIButton * finishButton;

@end

@implementation FillProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(86, 86)]];
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = 43;
    
    self.headShadowView = [[UIView alloc] init];
    self.headShadowView.backgroundColor = [UIColor clearColor];
    self.headShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headShadowView.layer.shadowOpacity = 0.5;
    self.headShadowView.layer.shadowRadius = 5;
    self.headShadowView.layer.shadowOffset = CGSizeMake(3.5, 3.5);
    self.headShadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 86, 86) cornerRadius:43].CGPath;
   self.headShadowView.clipsToBounds = NO;
    
    self.headEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headEditButton setImage:[UIImage imageWithColor:[UIColor blueColor] size:CGSizeMake(24, 24)] forState:UIControlStateNormal];
    self.headEditButton.layer.masksToBounds = YES;
    self.headEditButton.layer.cornerRadius = 12;
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setTitleColor:kCEETextLightBlackColor forState:UIControlStateNormal];
    [self.finishButton setBackgroundImage:[UIImage imageWithColor:kCEETextYellowColor size:CGSizeMake(270, 40)] forState:UIControlStateNormal];
    [self.finishButton setBackgroundImage:[UIImage imageWithColor:kCEETextHighlightYellowColor size:CGSizeMake(270, 40)] forState:UIControlStateHighlighted];
    self.finishButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.nicknameLabel.textColor = kCEETextLightBlackColor;
    self.nicknameLabel.text = @"昵称";
    
    self.nicknameSeperator = [[UIView alloc] init];
    self.nicknameSeperator.backgroundColor = kCEETextLightBlackColor;
    
    self.nicknameField = [[UITextField alloc] init];
    self.nicknameField.attributedPlaceholder
        = [[NSAttributedString alloc] initWithString:@"最多10个字符"
                                          attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                                                       NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    
    self.sexLabel = [[UILabel alloc] init];
    self.sexLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.sexLabel.textColor = kCEETextLightBlackColor;
    self.sexLabel.text = @"性别";
    
    self.sexSeperator = [[UIView alloc] init];
    self.sexSeperator.backgroundColor = kCEETextLightBlackColor;
    
    self.maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.maleButton.layer.masksToBounds = YES;
    self.maleButton.layer.cornerRadius = 6.5;
    [self.maleButton setBackgroundImage:[UIImage imageWithColor:kCEETextBlackColor size:CGSizeMake(13, 13)]
                               forState:UIControlStateSelected];
    [self.maleButton setBackgroundImage:[UIImage imageWithColor:kCEESelectedGrayColor size:CGSizeMake(13, 13)]
                               forState:UIControlStateNormal];
    
    self.maleLabel = [[UILabel alloc] init];
    self.maleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.maleLabel.textColor = kCEETextLightBlackColor;
    self.maleLabel.text = @"男";
    
    self.femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.femaleButton.layer.masksToBounds = YES;
    self.femaleButton.layer.cornerRadius = 6.5;
    [self.femaleButton setBackgroundImage:[UIImage imageWithColor:kCEETextBlackColor size:CGSizeMake(13, 13)]
                                 forState:UIControlStateSelected];
    [self.femaleButton setBackgroundImage:[UIImage imageWithColor:kCEESelectedGrayColor size:CGSizeMake(13, 13)]
                                 forState:UIControlStateNormal];
    
    self.femaleLabel = [[UILabel alloc] init];
    self.femaleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.femaleLabel.textColor = kCEETextLightBlackColor;
    self.femaleLabel.text = @"女";
    
    self.birthdayLabel = [[UILabel alloc] init];
    self.birthdayLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.birthdayLabel.textColor = kCEETextLightBlackColor;
    self.birthdayLabel.text = @"生日";
    
    self.birthdaySeperator = [[UIView alloc] init];
    self.birthdaySeperator.backgroundColor = kCEETextLightBlackColor;
    
    self.birthdayField = [[UILabel alloc] init];
    self.birthdayField.textColor = [kCEETextBlackColor colorWithAlphaComponent:0.3];
    self.birthdayField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.birthdayField.text = @"未设置";
    self.birthdayField.textAlignment = NSTextAlignmentLeft;
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.locationLabel.textColor = kCEETextLightBlackColor;
    self.locationLabel.text = @"位置";
    
    self.locationSeperator = [[UIView alloc] init];
    self.locationSeperator.backgroundColor = kCEETextLightBlackColor;
    
    self.locationField = [[UILabel alloc] init];
    self.locationField.textColor = [kCEETextBlackColor colorWithAlphaComponent:0.3];
    self.locationField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.locationField.text = @"湖南长沙";
    self.locationField.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:self.headShadowView];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.headEditButton];
    [self.view addSubview:self.finishButton];
    [self.view addSubview:self.nicknameLabel];
    [self.view addSubview:self.nicknameSeperator];
    [self.view addSubview:self.nicknameField];
    [self.view addSubview:self.sexLabel];
    [self.view addSubview:self.sexSeperator];
    [self.view addSubview:self.maleButton];
    [self.view addSubview:self.maleLabel];
    [self.view addSubview:self.femaleButton];
    [self.view addSubview:self.femaleLabel];
    [self.view addSubview:self.birthdayLabel];
    [self.view addSubview:self.birthdaySeperator];
    [self.view addSubview:self.birthdayField];
    [self.view addSubview:self.locationLabel];
    [self.view addSubview:self.locationSeperator];
    [self.view addSubview:self.locationField];
    
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(86);
        make.top.equalTo(self.view.mas_top).offset(84);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.headShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headView);
    }];
    
    [self.headEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
        make.top.equalTo(self.headView.mas_centerY).offset(17);
        make.left.equalTo(self.headView.mas_centerX).offset(15);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-144);
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(245);
        make.left.equalTo(self.finishButton.mas_left).offset(6);
    }];
    
    [self.nicknameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.nicknameSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        make.top.equalTo(self.nicknameLabel.mas_top);
        make.bottom.equalTo(self.nicknameLabel.mas_bottom);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(7);
    }];
    
    [self.nicknameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_top);
        make.bottom.equalTo(self.nicknameLabel.mas_bottom);
        make.left.equalTo(self.nicknameSeperator.mas_right).offset(7);
        make.right.lessThanOrEqualTo(self.finishButton.mas_right).offset(-6);
    }];
    
    [self.sexSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        make.centerX.equalTo(self.nicknameSeperator.mas_centerX);
        make.top.equalTo(self.sexLabel.mas_top);
        make.bottom.equalTo(self.sexLabel.mas_bottom);
    }];
    
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(39);
        make.left.equalTo(self.nicknameLabel.mas_left);
    }];
    
    [self.sexLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexLabel.mas_centerY);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
        make.left.equalTo(self.sexSeperator.mas_right).offset(26);
    }];
    
    [self.maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maleButton.mas_centerY);
        make.left.equalTo(self.maleButton.mas_right).offset(7);
    }];
    
    [self.maleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maleButton.mas_centerY);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
        make.left.equalTo(self.maleButton.mas_right).offset(82);
    }];
    
    [self.femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maleButton.mas_centerY);
        make.left.equalTo(self.femaleButton.mas_right).offset(7);
    }];
    
    [self.femaleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexLabel.mas_bottom).offset(39);
        make.left.equalTo(self.sexLabel.mas_left);
    }];
    
    [self.birthdayLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.birthdaySeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        make.centerX.equalTo(self.sexSeperator.mas_centerX);;
        make.top.equalTo(self.birthdayLabel.mas_top);
        make.bottom.equalTo(self.birthdayLabel.mas_bottom);
    }];
    
    [self.birthdayField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdaySeperator.mas_top);
        make.bottom.equalTo(self.birthdaySeperator.mas_bottom);
        make.left.equalTo(self.birthdaySeperator.mas_right).offset(7);
        make.right.lessThanOrEqualTo(self.finishButton.mas_right).offset(-6);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdayLabel.mas_bottom).offset(39);
        make.left.equalTo(self.birthdayLabel.mas_left);
    }];
    
    [self.locationLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.locationSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        make.centerX.equalTo(self.birthdaySeperator.mas_centerX);
        make.top.equalTo(self.locationLabel.mas_top);
        make.bottom.equalTo(self.locationLabel.mas_bottom);
    }];
    
    [self.locationField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationSeperator.mas_top);
        make.bottom.equalTo(self.locationSeperator.mas_bottom);
        make.left.equalTo(self.locationSeperator.mas_right).offset(7);
        make.right.lessThanOrEqualTo(self.finishButton.mas_right).offset(-6);
    }];
    
    
    self.navigationItem.leftBarButtonItem
        = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(23, 23)]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(backPressed:)];
    
    self.navigationItem.rightBarButtonItem
        = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(23, 23)]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(menuPressed:)];
    
    self.headView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menuPressed:(id)sender {
    
}

- (void)finishPressed:(id)sender {
    
}

- (void)birthdayPressed:(id)sender {
    
}

- (void)locationPressed:(id)sender {
    
}

@end
