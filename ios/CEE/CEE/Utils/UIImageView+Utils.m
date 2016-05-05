//
//  UIImageView+Utils.m
//  CEE
//
//  Created by Meng on 16/5/2.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import SDWebImage;

#import "UIImageView+Utils.h"

#import "CEEDownloadURLAPI.h"


static char currentOperationIDKey;


@implementation UIImageView (Utils)

- (void)cee_setImageWithKey:(NSString *)key {
    [self cee_setImageWithKey:key placeholder:nil];
}

- (void)cee_setImageWithKey:(NSString *)key placeholder:(UIImage *)image {
    NSString * operationID = [[NSUUID UUID] UUIDString];
    objc_setAssociatedObject(self, &currentOperationIDKey, operationID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak typeof(self) weakSelf = self;
    [[CEEDownloadURLAPI api] requestURLWithKey:key].then(^(NSString *url) {
        if (!weakSelf) {
            return;
        }
        NSString * currentID = objc_getAssociatedObject(weakSelf, &currentOperationIDKey);
        if (![currentID isEqualToString:operationID]) {
            return;
        }
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [UIView transitionWithView:self
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.image = image;
                                } completion:nil];
            } else {
                NSLog(@"load image key [%@] error: %@", key, error);
            }
        }];
    }).catch(^(NSError *error) {
        NSLog(@"get download url for key [%@] error: %@", key, error);
    });
}

@end
