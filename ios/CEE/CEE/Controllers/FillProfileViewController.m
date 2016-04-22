//
//  FillProfileViewController.m
//  CEE
//
//  Created by Meng on 16/4/18.
//  Copyright © 2016年 ygeek. All rights reserved.
//

@import CoreLocation;
@import Masonry;
@import ReactiveCocoa;
@import DZNPhotoPickerController;
@import Qiniu;
@import SVProgressHUD;

#import "TLCityPickerController.h"

#import "FillProfileViewController.h"
#import "AppearanceConstants.h"
#import "UIImage+Utils.h"
#import "CEELocationManager.h"
#import "AIDatePickerController.h"
#import "CEEUploadTokenAPI.h"
#import "CEESaveUserProfileAPI.h"
#import "CEEUserSession.h"
#import "UIImage+Utils.h"

#define kLocatingText @"定位中"

@interface FillProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TLCityPickerDelegate>
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIView * headShadowView;
@property (nonatomic, strong) UIImageView * headView;
@property (nonatomic, strong) UIButton * headEditButton;

@property (nonatomic, strong) UILabel * nicknameLabel;
@property (nonatomic, strong) UIView * nicknameSeperator;
@property (nonatomic, strong) UITextField * nicknameField;

@property (nonatomic, strong) UILabel * sexLabel;
@property (nonatomic, strong) UIView * sexSeperator;
@property (nonatomic, strong) UIButton * maleButton;
@property (nonatomic, strong) UILabel * maleLabel;
@property (nonatomic, strong) UIButton * femaleButton;
@property (nonatomic, strong) UILabel * femaleLabel;

@property (nonatomic, strong) UILabel * birthdayLabel;
@property (nonatomic, strong) UIView * birthdaySeperator;
@property (nonatomic, strong) UILabel * birthdayField;

@property (nonatomic, strong) UILabel * locationLabel;
@property (nonatomic, strong) UIView * locationSeperator;
@property (nonatomic, strong) UILabel * locationField;
@property (nonatomic, strong) UIActivityIndicatorView * locatingIndicator;

@property (nonatomic, strong) UIButton * finishButton;

@property (nonatomic, copy) NSString * sex;
@property (nonatomic, strong) NSDate * birthday;
@property (nonatomic, strong) UIImage * photo;

@end

@implementation FillProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupContentScrollView];
    [self setupHeadView];
    [self setupFinishButton];
    [self setupNickname];
    [self setupSex];
    [self setupBirtyday];
    [self setupLocation];
    [self setupLayout];
   
    self.navigationItem.leftBarButtonItem
        = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(backPressed:)];
   
    self.headView.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    @weakify(self)
    [RACObserve(self, sex) subscribeNext:^(NSString * sex) {
        @strongify(self)
        if ([sex isEqualToString:@"男"]) {
            self.maleButton.selected = YES;
            self.femaleButton.selected = NO;
        } else if ([sex isEqualToString:@"女"]) {
            self.maleButton.selected = NO;
            self.femaleButton.selected = YES;
        } else {
            self.maleButton.selected = NO;
            self.femaleButton.selected = NO;
        }
    }];
    
    RAC(self, headView.image) = [RACObserve(self, photo) ignore:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.locationField.text && self.locationField.text.length > 0) {
        return;
    }
    
    self.locationField.text = kLocatingText;
    [self.locatingIndicator startAnimating];
    [[[CEELocationManager manager] getLocations] subscribeNext:^(NSArray<CLPlacemark *> * placemarks) {
        CLPlacemark * placemark = placemarks.firstObject;
        NSString * cityName = placemark.locality;
        self.locationField.text = cityName;
        [self.locatingIndicator stopAnimating];
        
        if (self.presentedViewController && [self.presentedViewController isKindOfClass:[UINavigationController class]]) {
            TLCityPickerController * vc = ((UINavigationController *)self.presentedViewController).viewControllers[0];
            if ([vc isKindOfClass:[TLCityPickerController class]]) {
                TLCity * city = [[CEELocationManager manager] getCityWithName:cityName];
                if (city) {
                    [vc setLocationCityID:city.cityID];
                    [vc.tableView reloadData];
                }
            }
        }
        
    } error:^(NSError * error) {
        if ([self.locationField.text isEqualToString:kLocatingText]) {
            self.locationField.text = @"未知位置";
        }
        [self.locatingIndicator stopAnimating];
    }];
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headEditPressed:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)finishPressed:(id)sender {
    UIImage * photo = self.photo;
    [SVProgressHUD show];
    if (photo) {
        [[[[CEEUploadTokenAPI alloc] init] requestUploadToken] subscribeNext:^(CEEUploadTokenSuccessResponse *response) {
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            NSData *data = UIImagePNGRepresentation([photo imageScaleToWidth:200]);
            [upManager putData:data
                           key:nil
                         token:response.upload_token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if (info.error) {
                              [SVProgressHUD showErrorWithStatus:info.error.localizedDescription];
                              return;
                          }
                          CEESaveUserProfileRequest * request = [[CEESaveUserProfileRequest alloc] init];
                          request.nickname = self.nicknameField.text;
                          request.head_img_key = resp[@"key"];
                          request.sex = self.sex;
                          if (self.birthday) {
                              request.birthday = @([self.birthday timeIntervalSince1970]);
                          }
                          request.location = self.locationField.text;
                          [[[[CEESaveUserProfileAPI alloc] init] saveUserProfile:request] subscribeNext:^(CEESaveUserProfileSuccessResponse *response) {
                              
                              [[[CEEUserSession session] loadUserProfile] subscribeNext:^(CEEUserProfile *profile) {
                                  [SVProgressHUD dismiss];
                                  [self dismissViewControllerAnimated:YES completion:nil];
                              } error:^(NSError *error) {
                                  [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                              }];
                          } error:^(NSError *error) {
                              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                          }];
                      } option:nil];
        } error:^(NSError * error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    } else {
        CEESaveUserProfileRequest * request = [[CEESaveUserProfileRequest alloc] init];
        request.nickname = self.nicknameField.text;
        request.head_img_key = nil;
        request.sex = self.sex;
        request.birthday = @([self.birthday timeIntervalSince1970]);
        request.location = self.locationField.text;
        [[[CEESaveUserProfileAPI alloc] init] saveUserProfile:request];
        [SVProgressHUD dismiss];
    }
}

- (void)malePressed:(id)sender {
    self.sex = @"男";
}

- (void)femalePressed:(id)sender {
    self.sex = @"女";
}

- (void)birthdayPressed:(id)sender {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate * date = self.birthday ?: [dateFormatter dateFromString:@"1990年01月01日"];
    AIDatePickerController * datePickerViewController = [AIDatePickerController pickerWithDate:date selectedBlock:^(NSDate *date) {
        self.birthday = date;
        self.birthdayField.text = [dateFormatter stringFromDate:date];
        [self dismissViewControllerAnimated:YES completion:nil];
    } cancelBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:datePickerViewController animated:YES completion:nil];
}

- (void)locationPressed:(id)sender {
    TLCityPickerController * picker = [[TLCityPickerController alloc] init];
    picker.delegate = self;
    TLCity * city = [[CEELocationManager manager] getCityWithName:self.locationField.text];
    if (city) {
        picker.locationCityID = city.cityID;
    }
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:picker];
    [navController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:[UIImage new]];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSUInteger animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationCurve|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGFloat keyboardHeight = [UIScreen mainScreen].bounds.size.height - endFrame.origin.y;
                         self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
                     }
                     completion:nil];
    
    if (self.nicknameField.isFirstResponder) {
        [self.contentScrollView scrollRectToVisible:self.nicknameField.frame animated:YES];
    }
}

#pragma mark - TLCityPickerDelegate

- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController
                didSelectCity:(TLCity *)city {
    self.locationField.text = city.cityName;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.photo = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setup Layout

- (void)setupContentScrollView {
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    
    self.contentView = [[UIView alloc] init];
    
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.contentView];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.contentView addGestureRecognizer:tapRecognizer];
}

- (void)setupHeadView {
    self.headView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(86, 86)]];
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = 43;
    
    self.headShadowView = [[UIView alloc] init];
    self.headShadowView.backgroundColor = [UIColor clearColor];
    self.headShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headShadowView.layer.shadowOpacity = 0.5;
    self.headShadowView.layer.shadowRadius = 5;
    self.headShadowView.layer.shadowOffset = CGSizeMake(3.5, 3.5);
    self.headShadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 86, 86) cornerRadius:43].CGPath;
    self.headShadowView.clipsToBounds = NO;
    
    self.headEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headEditButton setImage:[UIImage imageNamed:@"个人资料编辑"] forState:UIControlStateNormal];
    self.headEditButton.layer.masksToBounds = YES;
    self.headEditButton.layer.cornerRadius = 12;
    [self.headEditButton addTarget:self action:@selector(headEditPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.headShadowView];
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.headEditButton];
}

- (void)setupFinishButton {
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setTitleColor:kCEETextLightBlackColor forState:UIControlStateNormal];
    [self.finishButton setBackgroundImage:[UIImage imageWithColor:kCEETextYellowColor size:CGSizeMake(270, 40)] forState:UIControlStateNormal];
    [self.finishButton setBackgroundImage:[UIImage imageWithColor:kCEETextHighlightYellowColor size:CGSizeMake(270, 40)] forState:UIControlStateHighlighted];
    self.finishButton.titleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(finishPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.finishButton];
}

- (void)setupNickname {
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.nicknameLabel.textColor = kCEETextLightBlackColor;
    self.nicknameLabel.text = @"昵称";
    
    self.nicknameSeperator = [[UIView alloc] init];
    self.nicknameSeperator.backgroundColor = kCEETextLightBlackColor;
    
    self.nicknameField = [[UITextField alloc] init];
    self.nicknameField.attributedPlaceholder
    = [[NSAttributedString alloc] initWithString:@"最多10个字符"
                                      attributes:@{NSFontAttributeName: [UIFont fontWithName:kCEEFontNameRegular size:15],
                                                   NSForegroundColorAttributeName: [kCEETextBlackColor colorWithAlphaComponent:0.3],}];
    self.nicknameField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.nicknameField.textColor = kCEETextLightBlackColor;
    
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.nicknameSeperator];
    [self.contentView addSubview:self.nicknameField];
}

- (void)setupSex {
    self.sexLabel = [[UILabel alloc] init];
    self.sexLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.sexLabel.textColor = kCEETextLightBlackColor;
    self.sexLabel.text = @"性别";
    
    self.sexSeperator = [[UIView alloc] init];
    self.sexSeperator.backgroundColor = kCEETextLightBlackColor;
    
    self.maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.maleButton.layer.masksToBounds = YES;
    self.maleButton.layer.cornerRadius = 6.5;
    [self.maleButton setBackgroundImage:[UIImage imageWithColor:kCEETextBlackColor size:CGSizeMake(13, 13)]
                               forState:UIControlStateSelected];
    [self.maleButton setBackgroundImage:[UIImage imageWithColor:kCEESelectedGrayColor size:CGSizeMake(13, 13)]
                               forState:UIControlStateNormal];
    [self.maleButton addTarget:self action:@selector(malePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.maleLabel = [[UILabel alloc] init];
    self.maleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.maleLabel.textColor = kCEETextLightBlackColor;
    self.maleLabel.text = @"男";
    
    self.femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.femaleButton.layer.masksToBounds = YES;
    self.femaleButton.layer.cornerRadius = 6.5;
    [self.femaleButton setBackgroundImage:[UIImage imageWithColor:kCEETextBlackColor size:CGSizeMake(13, 13)]
                                 forState:UIControlStateSelected];
    [self.femaleButton setBackgroundImage:[UIImage imageWithColor:kCEESelectedGrayColor size:CGSizeMake(13, 13)]
                                 forState:UIControlStateNormal];
    [self.femaleButton addTarget:self action:@selector(femalePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.femaleLabel = [[UILabel alloc] init];
    self.femaleLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.femaleLabel.textColor = kCEETextLightBlackColor;
    self.femaleLabel.text = @"女";
    
    [self.contentView addSubview:self.sexLabel];
    [self.contentView addSubview:self.sexSeperator];
    [self.contentView addSubview:self.maleButton];
    [self.contentView addSubview:self.maleLabel];
    [self.contentView addSubview:self.femaleButton];
    [self.contentView addSubview:self.femaleLabel];
}

- (void)setupBirtyday {
    self.birthdayLabel = [[UILabel alloc] init];
    self.birthdayLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.birthdayLabel.textColor = kCEETextLightBlackColor;
    self.birthdayLabel.text = @"生日";
    
    self.birthdaySeperator = [[UIView alloc] init];
    self.birthdaySeperator.backgroundColor = kCEETextLightBlackColor;
    
    self.birthdayField = [[UILabel alloc] init];
    self.birthdayField.textColor = [kCEETextBlackColor colorWithAlphaComponent:0.3];
    self.birthdayField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.birthdayField.text = @"未设置";
    self.birthdayField.textAlignment = NSTextAlignmentLeft;
    self.birthdayField.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(birthdayPressed:)];
    [self.birthdayField addGestureRecognizer:tapRecognizer];
    
    [self.contentView addSubview:self.birthdayLabel];
    [self.contentView addSubview:self.birthdaySeperator];
    [self.contentView addSubview:self.birthdayField];
}

- (void)setupLocation {
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.locationLabel.textColor = kCEETextLightBlackColor;
    self.locationLabel.text = @"位置";
    
    self.locationSeperator = [[UIView alloc] init];
    self.locationSeperator.backgroundColor = kCEETextLightBlackColor;
    
    self.locationField = [[UILabel alloc] init];
    self.locationField.textColor = [kCEETextBlackColor colorWithAlphaComponent:0.3];
    self.locationField.font = [UIFont fontWithName:kCEEFontNameRegular size:15];
    self.locationField.text = nil;
    self.locationField.textAlignment = NSTextAlignmentLeft;
    self.locationField.userInteractionEnabled = YES;
    
    self.locatingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationPressed:)];
    [self.locationField addGestureRecognizer:tapRecognizer];
    
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.locationSeperator];
    [self.contentView addSubview:self.locationField];
    [self.contentView addSubview:self.locatingIndicator];
}

- (void)setupLayout {
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(86);
        make.top.equalTo(self.contentView.mas_top).offset(84 * verticalScale());
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.headShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headView);
    }];
    
    [self.headEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
        make.top.equalTo(self.headView.mas_centerY).offset(17);
        make.left.equalTo(self.headView.mas_centerX).offset(15);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-144 * verticalScale());
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(245 * verticalScale());
        make.left.equalTo(self.finishButton.mas_left).offset(6);
        make.width.mas_equalTo(30);
    }];
    
    [self.nicknameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.nicknameSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        make.top.equalTo(self.nicknameLabel.mas_top);
        make.bottom.equalTo(self.nicknameLabel.mas_bottom);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(7);
    }];
    
    [self.nicknameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_top);
        make.bottom.equalTo(self.nicknameLabel.mas_bottom);
        make.left.equalTo(self.nicknameSeperator.mas_right).offset(7);
        make.right.equalTo(self.finishButton.mas_right).offset(-6);
    }];
    
    [self.sexSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        make.centerX.equalTo(self.nicknameSeperator.mas_centerX);
        make.top.equalTo(self.sexLabel.mas_top);
        make.bottom.equalTo(self.sexLabel.mas_bottom);
    }];
    
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(39 * verticalScale());
        make.left.equalTo(self.nicknameLabel.mas_left);
    }];
    
    [self.sexLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexLabel.mas_centerY);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
        make.left.equalTo(self.sexSeperator.mas_right).offset(26);
    }];
    
    [self.maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maleButton.mas_centerY);
        make.left.equalTo(self.maleButton.mas_right).offset(7);
    }];
    
    [self.maleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maleButton.mas_centerY);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
        make.left.equalTo(self.maleButton.mas_right).offset(82);
    }];
    
    [self.femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maleButton.mas_centerY);
        make.left.equalTo(self.femaleButton.mas_right).offset(7);
    }];
    
    [self.femaleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexLabel.mas_bottom).offset(39 * verticalScale());
        make.left.equalTo(self.sexLabel.mas_left);
    }];
    
    [self.birthdayLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.birthdaySeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        make.centerX.equalTo(self.sexSeperator.mas_centerX);;
        make.top.equalTo(self.birthdayLabel.mas_top);
        make.bottom.equalTo(self.birthdayLabel.mas_bottom);
    }];
    
    [self.birthdayField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdaySeperator.mas_top);
        make.bottom.equalTo(self.birthdaySeperator.mas_bottom);
        make.left.equalTo(self.birthdaySeperator.mas_right).offset(7);
        make.right.lessThanOrEqualTo(self.finishButton.mas_right).offset(-6);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdayLabel.mas_bottom).offset(39 * verticalScale());
        make.left.equalTo(self.birthdayLabel.mas_left);
    }];
    
    [self.locationLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.locationSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        make.centerX.equalTo(self.birthdaySeperator.mas_centerX);
        make.top.equalTo(self.locationLabel.mas_top);
        make.bottom.equalTo(self.locationLabel.mas_bottom);
    }];
    
    [self.locationField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationSeperator.mas_top);
        make.bottom.equalTo(self.locationSeperator.mas_bottom);
        make.left.equalTo(self.locationSeperator.mas_right).offset(7);
        make.right.equalTo(self.locatingIndicator.mas_left);
    }];
    
    [self.locatingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locationField.mas_centerY);
        make.right.equalTo(self.finishButton.mas_right);
    }];
}

@end
