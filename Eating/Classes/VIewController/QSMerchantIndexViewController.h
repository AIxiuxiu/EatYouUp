//
//  QSMerchantIndexViewController.h
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSMerchantIndexViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;

@property (weak, nonatomic) IBOutlet UITableView *mearchantIndexTableView;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIImageView *merchantLogoImageView;
@property (weak, nonatomic) IBOutlet UIButton *diggButton;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UIButton *takeoutButton;

@property (weak, nonatomic) IBOutlet UIView *cartView;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UILabel *cartLabel;

- (IBAction)onShareButtonAction:(id)sender;

- (IBAction)onDiggButtonAction:(id)sender;

- (IBAction)onCollectButtonAction:(id)sender;

- (IBAction)onPhoneCallButtonAction:(id)sender;

- (IBAction)onChatButtonAction:(id)sender;

- (IBAction)onTakeoutButtonAction:(id)sender;

- (IBAction)onBookButtonAction:(id)sender;


@end
