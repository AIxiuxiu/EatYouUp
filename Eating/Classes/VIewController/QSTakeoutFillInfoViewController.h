//
//  QSTakeoutFillInfoViewController.h
//  Eating
//
//  Created by MJie on 14-11-17.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSFoodListReturnData;
@class QSMerchantIndexReturnData;
@interface QSTakeoutFillInfoViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIImageView *merchantLogoImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *formScrollView;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIButton *couponButton;

@property (weak, nonatomic) IBOutlet UIView *payWayView;
@property (weak, nonatomic) IBOutlet UIButton *paywayButton1;
@property (weak, nonatomic) IBOutlet UIButton *paywayButton2;
@property (weak, nonatomic) IBOutlet UIButton *paywayButton3;

@property (weak, nonatomic) IBOutlet UIView *memoView;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;

@property (weak, nonatomic) IBOutlet UITableView *foodlistTableView;
@property (weak, nonatomic) IBOutlet UIView *foodFooterView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) QSFoodListReturnData *foodlistReturnData;
@property (nonatomic, strong) QSMerchantIndexReturnData *merchantIndexReturnData;
@property (nonatomic, copy) NSString *merchant_id;

- (IBAction)onSexButtonAction:(id)sender;

- (IBAction)onCouponButtonAction:(id)sender;

- (IBAction)onPayWayButtonAction:(id)sender;

- (IBAction)onConfirmButtonAction:(id)sender;

@end
