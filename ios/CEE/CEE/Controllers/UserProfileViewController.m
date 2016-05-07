//
//  UserProfileViewController.m
//  CEE
//
//  Created by Meng on 16/5/4.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import OAStackView;

#import "UserProfileViewController.h"
#import "UserFriendsViewController.h"
#import "UserProfileView.h"
#import "CEEUserSession.h"
#import "MedalNormalCollectionViewCell.h"
#import "MedalEmptyCollectionViewCell.h"
#import "UIImage+Utils.h"
#import "UIImageView+Utils.h"
#import "CEEUserInfoAPI.h"


#define kMedalNormalCellIdentifier @"kMedalNormalCellIdentifier"
#define kMedalEmptyCellIdentifier  @"kMedalEmptyCellIdentifier"
#define kMedalHeaderIdentifier     @"kMedalHeaderIdentifier"


@interface UserProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) CEEJSONUserInfo * userInfo;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(23, 23)]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(settingPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[CEEUserInfoAPI api] fetchUserInfo].then(^(CEEJSONUserInfo * userInfo) {
        self.userInfo = userInfo;
        [UIView transitionWithView:self.collectionView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.collectionView reloadData];
                        } completion:nil];
    });
}

- (void)backPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)settingPressed:(id)sender {
    
}

- (void)friendsTapped:(id)sender {
    UserFriendsViewController * friendsVC = [[UserFriendsViewController alloc] init];
    [self.navigationController pushViewController:friendsVC animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userInfo.medals.count + (4 - (self.userInfo.medals.count % 4));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.userInfo.medals.count) {
        CEEJSONMedal * medal = self.userInfo.medals[indexPath.row];
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
        UserProfileView * profileView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                           withReuseIdentifier:kMedalHeaderIdentifier
                                                                                  forIndexPath:indexPath];
        CEEJSONUserProfile * profile = [CEEUserSession session].userProfile;
        UIImage * defaultHead = [UIImage imageNamed:@"cee-头像"];
        if (profile.head_img_key && profile.head_img_key.length > 0) {
            [profileView.headImageView cee_setImageWithKey:profile.head_img_key
                                               placeholder:defaultHead];
        } else {
            profileView.headImageView.image = defaultHead;
        }
        profileView.nicknameLabel.text = profile.nickname;
        profileView.coinLabel.text = self.userInfo.coin.stringValue ?: @"0";
        profileView.friendsLabel.text = self.userInfo.friend_num.stringValue ?: @"0";
        
        profileView.friendsLabel.userInteractionEnabled = YES;
        if (profileView.friendsLabel.gestureRecognizers.count == 0) {
            UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendsTapped:)];
            [profileView.friendsLabel addGestureRecognizer:tapRecognizer];
        }
        
        return profileView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

@end
