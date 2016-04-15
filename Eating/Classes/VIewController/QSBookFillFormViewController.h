//
//  QSBookFillFormViewController.h
//  Eating
//
//  Created by System Administrator on 11/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantIndexReturnData;
@class QSYFoodGroudDataModel;
@interface QSBookFillFormViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, strong) QSMerchantIndexReturnData *merchantIndexReturnData;
@property (nonatomic,strong) QSYFoodGroudDataModel *teamModel;//!<搭食团数据模型

@property (nonatomic,copy) void(^commitTeamCallBack)(BOOL flag,NSString *ibookID);//!<点击成团时入此页面时，需要回调的block

@property (weak, nonatomic) IBOutlet UIScrollView *bookScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *merchantLogoImageView;

@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (weak, nonatomic) IBOutlet UIButton *seatTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


- (IBAction)onSeatNumButton:(id)sender;

- (IBAction)onSeatTypeButton:(id)sender;

- (IBAction)onBookDateButton:(id)sender;

- (IBAction)onBookTimeButton:(id)sender;

- (IBAction)onSexButtonAction:(id)sender;

- (IBAction)onConfirmButtonAction:(id)sender;

@end
