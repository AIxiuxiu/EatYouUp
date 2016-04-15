//
//  QSMerchantFoodlistViewController.h
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantIndexReturnData;
@interface QSMerchantFoodlistViewController : QSViewController


@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, strong) QSMerchantIndexReturnData *merchantIndexReturnData;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UITableView *foodTableView;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UIButton *takeoutButton;

@property (weak, nonatomic) IBOutlet UIView *cartView;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UILabel *cartLabel;

@property (weak, nonatomic) IBOutlet UIButton *sortButton1;
@property (weak, nonatomic) IBOutlet UIButton *sortButton2;
@property (weak, nonatomic) IBOutlet UIButton *sortButton3;


- (IBAction)onMenuButtonAction:(id)sender;

- (IBAction)onPhoneCallButtonAction:(id)sender;

- (IBAction)onTakeoutButtonAction:(id)sender;

- (IBAction)onBookButtonAction:(id)sender;

- (IBAction)onFilterButtonAction:(id)sender;

@end
