//
//  FriendProfileViewController.m
//  CEE
//
//  Created by Meng on 16/5/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

#import "FriendProfileViewController.h"
#import "UserProfileView.h"
#import "MedalNormalCollectionViewCell.h"
#import "MedalEmptyCollectionViewCell.h"
#import "UIImage+Utils.h"
#import "UIImageView+Utils.h"
#import "CEEUserInfoAPI.h"
#import "CEEUploadManager.h"
#import "SettingViewController.h"
#import "CEESaveUserProfileAPI.h"

#define kMedalNormalCellIdentifier @"kMedalNormalCellIdentifier"
#define kMedalEmptyCellIdentifier  @"kMedalEmptyCellIdentifier"
#define kMedalHeaderIdentifier     @"kMedalHeaderIdentifier"

@interface FriendProfileViewController () <UICollectionViewDelegate,
                                           UICollectionViewDataSource,
                                           UINavigationControllerDelegate,
                                           UIImagePickerControllerDelegate>
@property (nonatomic, strong) UserProfileView * profileView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) BOOL isAppeared;
@end


@implementation FriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isAppeared = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(screenWidth / 4, screenWidth / 4);
    layout.headerReferenceSize = CGSizeMake(screenWidth, 400);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[MedalNormalCollectionViewCell class]
            forCellWithReuseIdentifier:kMedalNormalCellIdentifier];
    [self.collectionView registerClass:[MedalEmptyCollectionViewCell class]
            forCellWithReuseIdentifier:kMedalEmptyCellIdentifier];
    [self.collectionView registerClass:[UserProfileView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kMedalHeaderIdentifier];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.medals.count + (4 - (self.medals.count % 4));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.medals.count) {
        CEEJSONMedal * medal = self.medals[indexPath.row];
        MedalNormalCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMedalNormalCellIdentifier
                                                                                         forIndexPath:indexPath];
        [cell.iconView cee_setImageWithKey:medal.icon_key];
        return cell;
    } else {
        MedalEmptyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMedalEmptyCellIdentifier
                                                                                        forIndexPath:indexPath];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (!self.profileView) {
            self.profileView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                  withReuseIdentifier:kMedalHeaderIdentifier
                                                                         forIndexPath:indexPath];
        }
        UIImage * defaultHead = [UIImage imageNamed:@"cee-头像"];
        if (self.friendInfo.head_img_key && self.friendInfo.head_img_key.length > 0) {
            [self.profileView.headImageView cee_setImageWithKey:self.friendInfo.head_img_key
                                                    placeholder:defaultHead];
        } else {
            self.profileView.headImageView.image = defaultHead;
        }
        self.profileView.nicknameLabel.text = self.friendInfo.nickname;
        self.profileView.coinLabel.text = self.friendInfo.coin.stringValue ?: @"0";
        self.profileView.friendsTitleLabel.text = @"彩蛋";
        self.profileView.friendsLabel.text = self.friendInfo.finish_maps.stringValue ?: @"0";
        
        self.profileView.friendsLabel.userInteractionEnabled = YES;
        
        return self.profileView;
    }
    return nil;
}


@end
