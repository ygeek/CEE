//
//  StoryNumberInputViewController.m
//  CEE
//
//  Created by Meng on 16/5/5.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "HUDNumberInputViewController.h"
#import "AppearanceConstants.h"

@interface HUDNumberInputViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView * panelView;
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) NSMutableArray * selections;
@end

@implementation HUDNumberInputViewController

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
    
    self.panelView = [[UIView alloc] init];
    self.panelView.backgroundColor = [UIColor whiteColor];
    self.panelView.layer.cornerRadius = 10;
    self.panelView.layer.masksToBounds = YES;
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.showsSelectionIndicator = NO;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.panelView addSubview:self.pickerView];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = hexColor(0xefe529);
    [self.confirmButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确  定" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:18];
    [self.confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:self.confirmButton];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panelView.mas_centerX);
        make.centerY.equalTo(self.panelView.mas_centerY).offset(-43 / 2.0);
        make.left.equalTo(self.panelView.mas_left);
        make.right.equalTo(self.panelView.mas_right);
        make.height.mas_equalTo(60 * 3);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panelView.mas_left);
        make.right.equalTo(self.panelView.mas_right);
        make.bottom.equalTo(self.panelView.mas_bottom);
        make.height.mas_equalTo(43);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [hexColor(0x666666) colorWithAlphaComponent:0.6];
    
    [self.view addSubview:self.panelView];
    
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 146);
        make.height.mas_equalTo(310);
    }];
    
    [self.pickerView reloadAllComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (NSUInteger i = 0; i < self.selections.count; i++) {
        [self.pickerView selectRow:[self.selections[i] unsignedIntegerValue]
                       inComponent:i
                          animated:YES];
    }
}

- (void)setAnswer:(NSString *)answer {
    _answer = [answer copy];
    NSMutableArray * selections = [NSMutableArray array];
    for (NSUInteger i = 0; i < answer.length; i++) {
        NSUInteger random = arc4random_uniform(10);
        [selections addObject:@(random)];
    }
    self.selections = selections;
}

- (void)confirmPressed:(id)sender {
    NSString * numbers = [self.selections componentsJoinedByString:@""];
    [self.delegate numberInputController:self didSelectNumbers:numbers];
}

#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.answer.length;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

#pragma mark - UIPickerViewDelegate

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return MIN(40 + 15, ([UIScreen mainScreen].bounds.size.width - 146.0) / [self numberOfComponentsInPickerView:pickerView]);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 55;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    
    UILabel * label = nil;
    if (view) {
        label = (UILabel *)view;
    } else {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:kCEEFontNameRegular size:25];
        label.textColor = kCEETextBlackColor;
    }
    label.text = @(row).stringValue;
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selections[component] = @(row);
}

@end
