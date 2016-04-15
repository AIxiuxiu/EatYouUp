//
//  QSFoodDetailViewController.h
//  eating
//
//  Created by MJie on 14-11-9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSFoodDetailViewController : QSViewController

@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, strong) QSMerchantIndexReturnData *merchantIndexReturnData;

@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (strong, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIScrollView *foodScrollView;
@property (nonatomic,assign) BOOL takeOutFlag;//!<是否具备外卖功能

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UIButton *takeoutButton;

@property (weak, nonatomic) IBOutlet UIView *cartView;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UILabel *cartLabel;

@property (weak, nonatomic) IBOutlet UIButton *listButton;

@property (weak, nonatomic) IBOutlet UIView *listiconsView;
@property (weak, nonatomic) IBOutlet UIButton *listicon;
@property (weak, nonatomic) IBOutlet UIButton *listicon1;
@property (weak, nonatomic) IBOutlet UIButton *listicon2;
@property (weak, nonatomic) IBOutlet UIButton *listicon3;
@property (weak, nonatomic) IBOutlet UIButton *listicon4;

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIScrollView *popupScrollView;


- (IBAction)onAddCartButtonAction:(id)sender;

- (IBAction)onShowListButtonAction:(id)sender;

- (IBAction)onListIconButtonAction:(id)sender;

- (IBAction)onPhoneCallButtonAction:(id)sender;

- (IBAction)onTakeoutButtonAction:(id)sender;

- (IBAction)onBookButtonAction:(id)sender;

@end
