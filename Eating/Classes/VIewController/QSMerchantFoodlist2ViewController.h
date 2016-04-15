//
//  QSMerchantFoodlist2ViewController.h
//  Eating
//
//  Created by System Administrator on 12/5/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantIndexReturnData;
@class QSFoodListReturnData;
@interface QSMerchantFoodlist2ViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, strong) QSMerchantIndexReturnData *merchantIndexReturnData;
@property (nonatomic, strong) QSFoodListReturnData *foodlistReturnData;

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (nonatomic, strong) UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UIButton *takeoutButton;

@property (weak, nonatomic) IBOutlet UIView *cartView;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UILabel *cartLabel;

@property (weak, nonatomic) IBOutlet UIView *listiconsView;
@property (weak, nonatomic) IBOutlet UIButton *listicon;
@property (weak, nonatomic) IBOutlet UIButton *listicon1;
@property (weak, nonatomic) IBOutlet UIButton *listicon2;
@property (weak, nonatomic) IBOutlet UIButton *listicon3;
@property (weak, nonatomic) IBOutlet UIButton *listicon4;

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIScrollView *popupScrollView;

- (IBAction)onShowListButtonAction:(id)sender;

- (IBAction)onListIconButtonAction:(id)sender;

- (IBAction)onAddCarButtonAction:(id)sender;
@end
