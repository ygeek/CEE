//
//  AcquiredMapsViewController.m
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import RDVTabBarController;

#import "AcquiredMapsViewController.h"
#import "AcquiredMapCollectionViewCell.h"
#import "EmptyMapCollectionViewCell.h"


@interface AcquiredMapsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@end


@implementation AcquiredMapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    screenSize.height -= (22 + 44);
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(screenSize.width / 3, screenSize.height / 5);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[AcquiredMapCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([AcquiredMapCollectionViewCell class])];
    [self.collectionView registerClass:[EmptyMapCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([EmptyMapCollectionViewCell class])];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.leftBarButtonItem
    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(backPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.maps.count - self.maps.count % 15 + 15;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.maps.count) {
        AcquiredMapCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AcquiredMapCollectionViewCell class]) forIndexPath:indexPath];
        [cell loadMap:self.maps[indexPath.row]];
        return cell;
    } else {
        EmptyMapCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EmptyMapCollectionViewCell class]) forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.maps.count) {
        [self.delegate acquiredMapsViewController:self didSelectMap:self.maps[indexPath.row]];
    }
}

@end
