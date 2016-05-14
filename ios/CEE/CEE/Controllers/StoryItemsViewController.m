//
//  StoryItemsViewController.m
//  CEE
//
//  Created by Meng on 16/5/5.
//  Copyright © 2016年 ygeek. All rights reserved.
//


@import Masonry;
@import ReactiveCocoa;


#import "StoryItemsViewController.h"
#import "StoryMemoryViewController.h"
#import "CEETriangleView.h"
#import "AppearanceConstants.h"
#import "StoryItemCollectionViewCell.h"
#import "CEENotificationNames.h"
#import "CEEMapManager.h"


#define kStoryItemCellIdentifier @"kStoryItemCellIdentifier"


@interface StoryItemsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) CEETriangleView * triangle;
@property (nonatomic, strong) UIView * panel;
@property (nonatomic, strong) UILabel * panelLabel;
@property (nonatomic, strong) UIButton * panelButton;

@property (nonatomic, strong) NSNumber * selectedIndex;

@end


@implementation StoryItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = hexColor(0x7f7f7f);
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(92, 71);
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    CGFloat inset = (screenSize.width - 92 * 3 - 12 * 2) / 2.0;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.collectionView.alwaysBounceHorizontal = YES;
    
    [self.collectionView registerClass:[StoryItemCollectionViewCell class]
            forCellWithReuseIdentifier:kStoryItemCellIdentifier];
    
    [self.view addSubview:self.collectionView];
   
    self.triangle = [[CEETriangleView alloc] initWithFrame:CGRectMake(0, 0, 17, 9)];
    self.triangle.color = kCEEYellowColor;
    [self.view addSubview:self.triangle];
    
    self.panel = [[UIView alloc] init];
    self.panel.backgroundColor = kCEEYellowColor;
    [self.view addSubview:self.panel];
    
    self.panelLabel = [[UILabel alloc] init];
    self.panelLabel.textAlignment = NSTextAlignmentCenter;
    self.panelLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    self.panelLabel.textColor = kCEETextBlackColor;
    [self.panel addSubview:self.panelLabel];
    
    self.panelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.panelButton.layer.masksToBounds = YES;
    self.panelButton.layer.cornerRadius = 8;
    self.panelButton.backgroundColor = [UIColor whiteColor];
    [self.panelButton setTitleColor:kCEETextBlackColor forState:UIControlStateNormal];
    [self.panelButton setTitle:@"开始导航" forState:UIControlStateNormal];
    [self.panelButton addTarget:self action:@selector(panelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:self.panelButton];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(194);
        make.height.mas_equalTo(120);
    }];
    
   
    [self.panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(8);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(186);
    }];
    
    [self.panelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panel.mas_left).offset(20);
        make.right.equalTo(self.panel.mas_right).offset(-20);
        make.top.equalTo(self.panel.mas_top).offset(20);
        make.bottom.equalTo(self.panelButton.mas_top).offset(-20);
    }];
    
    [self.panelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.panel.mas_bottom).offset(-23);
        make.centerX.equalTo(self.panel.mas_centerX);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(36);
    }];
   
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backPressed:)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton * memoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    memoryButton.frame = CGRectMake(0, 0, 40, 20);
    [memoryButton setTitle:@"记忆" forState:UIControlStateNormal];
    [memoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    memoryButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    [memoryButton addTarget:self action:@selector(memoryPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * memoryItem = [[UIBarButtonItem alloc] initWithCustomView:memoryButton];
    memoryItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = memoryItem;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"道具箱";
    self.navigationItem.titleView = titleLabel;
    
    @weakify(self)
    [RACObserve(self, selectedIndex) subscribeNext:^(NSNumber * index) {
        @strongify(self)
        if (!index) {
            self.triangle.hidden = YES;
            self.panel.hidden = YES;
        } else {
            self.triangle.hidden = NO;
            self.panel.hidden = NO;
            [self updatePanelWithItem:self.items[index.integerValue]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)memoryPressed:(id)sender {
    StoryMemoryViewController * memoryVC = [[StoryMemoryViewController alloc] init];
    NSMutableArray<CEEJSONLevel *> * memoryLevels = [NSMutableArray array];
    for (CEEJSONLevel * level in self.completedLevels) {
        NSString * type = level.content[@"type"];
        if ([type isEqualToString:@"dialog"] ||
            [type isEqualToString:@"video"]) {
            [memoryLevels addObject:level];
        }
    }
    memoryVC.levels = memoryLevels;
    [self.navigationController pushViewController:memoryVC animated:YES];
}

- (void)panelButtonPressed:(id)sender {
    CEEJSONItem * item = self.items[self.selectedIndex.integerValue];
    if ([item.content[@"type"] isEqualToString:@"navigation"]) {
        NSNumber * latitude = item.content[@"latitude"];
        NSNumber * longitude = item.content[@"longitude"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCEEEventNotificationName
                                                            object:item
                                                          userInfo:@{kCEEEventNameKey: item.content[@"event"]}];
        
        if (![[CEEMapManager manager] openNavigationAppToLatitude:latitude.floatValue longitude:longitude.floatValue]) {
            NSLog(@"call navigation app failed.");
        }
    } else if ([item.content[@"type"] isEqualToString:@"lock"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCEEEventNotificationName
                                                            object:item
                                                          userInfo:@{kCEEEventNameKey: item.content[@"event"]}];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CEEJSONItem * item = self.items[indexPath.row];
    
    StoryItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStoryItemCellIdentifier forIndexPath:indexPath];
    
    [cell loadItem:item];
    
    cell.alpha = item.activate_at.unsignedIntegerValue > self.completedLevels.count ? 0.5 : 1.0;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CEEJSONItem * item = self.items[indexPath.row];
    
    if (item.activate_at.unsignedIntegerValue > self.completedLevels.count) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        if (self.selectedIndex) {
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex.unsignedIntegerValue
                                                                     inSection:0]
                                         animated:NO
                                   scrollPosition:UICollectionViewScrollPositionNone];
            [self updateTriangle];
        }
        return;
    }
    
    if (!self.selectedIndex) {
        self.selectedIndex = @(indexPath.row);
        [self updateTriangle];
    } else if ([self.selectedIndex isEqualToNumber:@(indexPath.row)]) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        self.selectedIndex = nil;
    } else {
        self.selectedIndex = @(indexPath.row);
        [self updateTriangle];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.selectedIndex) {
        [self updateTriangle];
    }
}

- (void)updateTriangle {
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex.integerValue inSection:0]];
    CGRect frame = [self.view convertRect:cell.frame fromView:self.collectionView];
    self.triangle.center = CGPointMake(CGRectGetMidX(frame), self.panel.frame.origin.y - 4);
}

- (void)updatePanelWithItem:(CEEJSONItem *)item {
    if ([item.content[@"type"] isEqualToString:@"navigation"]) {
        self.panelLabel.text = item.content[@"text"];
        [self.panelButton setTitle:@"开始导航" forState:UIControlStateNormal];
        self.panelButton.hidden = NO;
    } else if ([item.content[@"type"] isEqualToString:@"note"]) {
        self.panelLabel.text = item.content[@"text"];
        self.panelButton.hidden = YES;
    } else if ([item.content[@"type"] isEqualToString:@"lock"]) {
        self.panelLabel.text = item.content[@"text"];
        [self.panelButton setTitle:@"开锁" forState:UIControlStateNormal];
        self.panelButton.hidden = NO;
    }
}

@end
