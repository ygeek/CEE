//
//  DrawerViewController.m
//  CEE
//
//  Created by Meng on 16/4/11.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import Masonry;

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
    self.scrollView = [[CouponScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.dataSource = self;
    self.scrollView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"个人主页"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(menuPressed:)];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(410);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView reloadData];
}

#pragma mark - Event Handling

- (void)menuPressed:(id)sender {
    
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
    
    view.alpha = [self alphaForProgress:progress];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // scale
    CGFloat scale = [self scaleForProgress:progress];
    transform = CGAffineTransformScale(transform, scale, scale);
    
    // translation
    CGFloat translation = [self translationForProgress:progress];
    transform = CGAffineTransformTranslate(transform, 0, translation);
    
    view.transform = transform;
    
    NSLog(@"current:%ld, progress: %f, scale: %f, trans: %f", currentIndex, progress, scale, translation);
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
