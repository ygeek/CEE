//
//  ViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "RootViewController.h"
#import "DrawerViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIViewController * vc1 = [[DrawerViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    
    UIViewController * vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor yellowColor];
    
    self.tabBar.translucent = YES;
    
    self.tabBar.backgroundView.backgroundColor = [UIColor colorWithRed:0
                                                                 green:0
                                                                  blue:0
                                                                 alpha:0.7];
    
    [self setViewControllers:@[vc1, vc2]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
