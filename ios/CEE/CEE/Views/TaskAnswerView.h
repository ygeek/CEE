//
//  TaskAnswerView.h
//  CEE
//
//  Created by Meng on 16/4/27.
//  Copyright © 2016年 ygeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskAnswerView : UIView
@property (nonatomic, strong) UIImageView * closeButtonBG;
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UIImageView * photoView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UIButton * nextButton;
@end
