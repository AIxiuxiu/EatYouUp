//
//  QSMerchantIntroductionViewController.h
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantDetailData;
@interface QSMerchantIntroductionViewController : QSViewController

@property (nonatomic, strong) QSMerchantDetailData *item;

@property (weak, nonatomic) IBOutlet UIImageView *merchantLogoImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *introScrollView;

@property (weak, nonatomic) IBOutlet UIView *baseInfoView;
@property (weak, nonatomic) IBOutlet UIButton *merchantTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UIView *timeContainView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *trifficContainView;
@property (weak, nonatomic) IBOutlet UILabel *trifficLabel;

@property (weak, nonatomic) IBOutlet UIView *introContainView;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

- (IBAction)onPhoneCallButtonAction:(id)sender;

- (IBAction)onChatToMerchantButtonAction:(id)sender;

- (IBAction)onAddressButtonAction:(id)sender;

@end
