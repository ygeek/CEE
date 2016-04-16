//
//  DrawerViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import "DrawerViewController.h"
#import "CouponScrollView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NUMBER_OF_VISIBLE_VIEWS 5


@interface DrawerViewController () <CouponScrollViewDataSource, CouponScrollViewDelegate>
@property (nonatomic, strong) CouponScrollView * scrollView;
@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[CouponScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scrollView];
    self.scrollView.dataSource = self;
    self.scrollView.delegate = self;
    self.scrollView.maxScrollDistance = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView reloadData];
}

#pragma mark CouponScrollViewDatasource

- (NSInteger)numberOfViews {
    return 9;
}

- (NSInteger)numberOfVisibleViews {
    return NUMBER_OF_VISIBLE_VIEWS;
}

- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [self newCard];
    }
    return view;
}

- (UIView *)newCard {
    CGFloat width =  SCREEN_WIDTH / 10 * 7.2;
    
    UIView *snapshot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 300)];
    snapshot.backgroundColor = [UIColor whiteColor];
    snapshot.layer.cornerRadius = 5;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:snapshot.bounds];
    snapshot.layer.shadowColor = [UIColor blackColor].CGColor;
    snapshot.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    snapshot.layer.shadowOpacity = .3;
    snapshot.layer.shadowPath = shadowPath.CGPath;
    
    return snapshot;
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
    
    // view.alpha = 1 - fabs(progress) * 0.2;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // scale
    CGFloat scale = 1 - fabs(progress) * 0.2;
    transform = CGAffineTransformScale(transform, scale, scale);
    
    // translation
    // CGFloat translation = progress * SCREEN_WIDTH / 5;
    
    //transform = CGAffineTransformTranslate(transform, 0, translation);
    
    view.transform = transform;
}

@end
