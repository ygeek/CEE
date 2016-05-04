//
//  DrawerViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;
@import SVProgressHUD;
@import RDVTabBarController;

#import "DrawerViewController.h"
#import "CouponScrollView.h"
#import "HUDCouponCodeView.h"
#import "CouponCard.h"
#import "CEECouponListAPI.h"
#import "UIImage+Utils.h"
#import "HUDCouponCodeViewController.h"
#import "UserProfileViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NUMBER_OF_VISIBLE_VIEWS 5


@interface DrawerViewController () <CouponScrollViewDataSource,
                                    CouponScrollViewDelegate,
                                    CouponCardDelegate,
                                    HUDCouponCodeViewControllerDelegate>
@property (nonatomic, strong) CouponScrollView * scrollView;
@property (nonatomic, strong) HUDCouponCodeView * codeView;
@property (nonatomic, assign) BOOL isReload;
@property (nonatomic, strong) NSArray<CEEJSONCoupon *> * coupons;
@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[CouponScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.dataSource = self;
    self.scrollView.delegate = self;
    
    self.codeView = [[HUDCouponCodeView alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"个人主页"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(menuPressed:)];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(410);
    }];
    
    self.isReload = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.isReload) {
        self.isReload = YES;
        [self.scrollView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.coupons) {
        [self reloadAll];
    }
}

- (void)reloadAll {
    [SVProgressHUD showWithStatus:@"正在获取优惠券信息"];
    [[CEECouponListAPI api] fetchCouponList].then(^(NSArray<CEEJSONCoupon *> *coupons) {
        self.coupons = [coupons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"consumed == NO"]];
        [self.scrollView reloadData];
        [SVProgressHUD dismiss];
    }).catch(^(NSError *error){
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    });
}

#pragma mark - Event Handling

- (void)menuPressed:(id)sender {
    UserProfileViewController * profileVC = [[UserProfileViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [self.rdv_tabBarController presentViewController:navController animated:YES completion:nil];
}

#pragma mark CouponScrollViewDatasource

- (NSInteger)numberOfViews {
    return self.coupons.count;
}

- (NSInteger)numberOfVisibleViews {
    return NUMBER_OF_VISIBLE_VIEWS;
}

- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [[CouponCard alloc] init];
    }
    
    int beginIndex = -floor(self.numberOfViews / 2.0f) + (self.numberOfViews % 2 == 0);
    int endIndex = floor(self.numberOfViews / 2.0f);
    if (index < beginIndex || index > endIndex || self.numberOfViews == 0) {
        view.hidden = YES;
        return view;
    } else {
        view.hidden = NO;
    }
    
    CouponCard * couponCard = (CouponCard *)view;
    couponCard.delegate = self;
    
    CEEJSONCoupon * coupon = self.coupons[index - beginIndex];
    [couponCard loadCoupon:coupon];
   
    return view;
}

- (CGFloat)viewHeightAtIndex:(NSInteger)index {
    return 212;
}

- (UIView *)newCard {
    CGFloat width =  SCREEN_WIDTH / 10 * 7.2;
    
    UIView *snapshot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 212)];
    snapshot.backgroundColor = [UIColor whiteColor];
    snapshot.layer.cornerRadius = 5;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:snapshot.bounds];
    snapshot.layer.shadowColor = [UIColor blackColor].CGColor;
    snapshot.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    snapshot.layer.shadowOpacity = .3;
    snapshot.layer.shadowPath = shadowPath.CGPath;
    
    UIView * head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 55)];
    head.backgroundColor = [UIColor yellowColor];
    [snapshot addSubview:head];
    
    return snapshot;
}

#pragma mark - CouponCardDelegate

- (void)couponCard:(CouponCard *)card consumeCoupon:(CEEJSONCoupon *)coupon {
    HUDCouponCodeViewController * codeVC = [[HUDCouponCodeViewController alloc] init];
    codeVC.couponUUID = coupon.uuid;
    codeVC.delegate = self;
    [self presentViewController:codeVC animated:YES completion:nil];
}

#pragma mark - HUDCouponCodeViewControllerDelegate

- (void)couponCodeVerified:(HUDCouponCodeViewController *)controller {
    [self reloadAll];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark CouponScrollViewDelegate

- (void)updateView:(UIView *)view withProgress:(CGFloat)progress currentIndex:(NSInteger)currentIndex scrollDirection:(CouponScrollDirection)direction {
    NSMutableArray * views = [[self.scrollView allViews] mutableCopy];
    [views sortUsingComparator:^NSComparisonResult(UIView * view1, UIView * view2) {
        return view1.tag > view2.tag;
    }];
    for (UIView * view in views) {
        if (view.tag >= currentIndex) {
            break;
        }
        [view.superview bringSubviewToFront:view];
    }
    
    for (UIView * view in views.reverseObjectEnumerator) {
        if (view.tag < currentIndex) {
            break;
        }
        [view.superview bringSubviewToFront:view];
    }
    
    ((CouponCard *)view).shadowView.alpha = (1.0 - [self alphaForProgress:progress]);
    if (labs(view.tag - currentIndex) >= self.numberOfVisibleViews / 2) {
        view.alpha = fmax(3.0 - fabs(progress), 0.0);
    } else {
        view.alpha = 1.0;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // scale
    CGFloat scale = [self scaleForProgress:progress];
    transform = CGAffineTransformScale(transform, scale, scale);
    
    // translation
    CGFloat translation = [self translationForProgress:progress];
    transform = CGAffineTransformTranslate(transform, 0, translation);
    
    view.transform = transform;
}

- (CGFloat)alphaForProgress:(CGFloat)progress {
    CGFloat alpha0 = 1.0;
    CGFloat alpha1 = 0.8;
    CGFloat alpha2 = 0.65;
    CGFloat alpha3 = 0.0;
    
    progress = fabs(progress);
    if (progress >= 3.0) {
        return alpha3;
    } else if (progress >= 2.0) {
        CGFloat delta = progress - 2.0;
        return alpha2 * (1.0 - delta) + alpha3 * delta;
    } else if (progress >= 1.0) {
        CGFloat delta = progress - 1.0;
        return alpha1 * (1.0 - delta) + alpha2 * delta;
    } else {
        return alpha0 * (1.0 - progress) + alpha1 * progress;
    }
}

- (CGFloat)scaleForProgress:(CGFloat)progress {
    CGFloat scale0 = 1.0;
    CGFloat scale1 = 0.89;
    CGFloat scale2 = 0.76;
    CGFloat scale3 = 0.5;
    
    progress = fabs(progress);
    if (progress >= 3.0) {
        return scale3;
    } else if (progress >= 2.0) {
        CGFloat delta = progress - 2.0;
        return scale2 * (1.0 - delta) + scale3 * delta;
    } else if (progress >= 1.0) {
        CGFloat delta = progress - 1.0;
        return scale1 * (1.0 - delta) + scale2 * delta;
    } else {
        return scale0 * (1.0 - progress) + scale1 * progress;
    }
}

- (CGFloat)translationForProgress:(CGFloat)progress {
    CGFloat trans0 = 0.0;
    CGFloat trans1 = -22.0;
    CGFloat trans2 = -55.0;
    CGFloat trans3 = -90.0;
    
    CGFloat sign = progress >= 0 ? 1.0 : -1.0;
    progress = fabs(progress);
    if (progress >= 3.0) {
        return sign * trans3;
    } else if (progress >= 2.0) {
        CGFloat delta = progress - 2.0;
        return sign * (trans2 * (1.0 - delta) + trans3 * delta);
    } else if (progress >= 1.0) {
        CGFloat delta = progress - 1.0;
        return sign * (trans1 * (1.0 - delta) + trans2 * delta);
    } else {
        return sign * (trans0 * (1.0 - progress) + trans1 * progress);
    }
}

@end
