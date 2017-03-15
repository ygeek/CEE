//
//  StoryMemoryViewController.m
//  CEE
//
//  Created by Meng on 16/5/6.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import PromiseKit;

#import "StoryMemoryViewController.h"
#import "StoryDialogViewController.h"
#import "StoryVideoViewController.h"
#import "MemoryItemCollectionViewCell.h"
#import "AppearanceConstants.h"
#import "CEEImageManager.h"
#import "CEEStory.h"

#define kMemoryItemCellIdentifier @"kMemoryItemCellIdentifier"


@interface StoryMemoryViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@end


@implementation StoryMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = hexColor(0x7f7f7f);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(92 + 34 + 34, 91 + 76);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat horizontalInset = (screenSize.width - (92 + 34 + 34) * 2.0) / 2.0;
    CGFloat vertialInset = 88 - 76 / 2.0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(vertialInset, horizontalInset, vertialInset, horizontalInset);
    self.collectionView.backgroundColor = kCEEYellowColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[MemoryItemCollectionViewCell class] forCellWithReuseIdentifier:kMemoryItemCellIdentifier];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(106);
        make.bottom.equalTo(self.view.mas_bottom).offset(-106);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backPressed:)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"记忆";
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.levels.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MemoryItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMemoryItemCellIdentifier
                                                                                    forIndexPath:indexPath];
    [cell.itemView loadLevel:self.levels[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UIViewController * levelVC = nil;
    
    CEEJSONLevel * level = self.levels[indexPath.row];
    
    NSString * type = level.content[@"type"];
    if ([type isEqualToString:@"dialog"]) {
        StoryDialogViewController * dialogVC = [[StoryDialogViewController alloc] init];
        [[CEEImageManager manager] queryImageForKey:level.content[@"img"]]
        .then(^(UIImage *image) {
            [dialogVC setImage:image];
        });
        dialogVC.sayer = level.content[@"sayer"];
        dialogVC.text = level.content[@"text"];
        [dialogVC reloadData];
        levelVC = dialogVC;
    } else if ([type isEqualToString:@"video"]) {
        StoryVideoViewController * videoVC = [[StoryVideoViewController alloc] init];
        videoVC.videoKey = level.content[@"video_key"];
        levelVC = videoVC;
    }
    
    levelVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:levelVC animated:YES completion:nil];
}

@end
