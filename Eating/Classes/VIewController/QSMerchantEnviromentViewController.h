//
//  QSMerchantEnviromentViewController.h
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantDetailData;
@interface QSMerchantEnviromentViewController : QSViewController

@property (nonatomic, strong) QSMerchantDetailData *item;
@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, strong) UIImage *merchant_image;

@property (weak, nonatomic) IBOutlet UIButton *diggButton;

- (IBAction)onShareButtonAction:(id)sender;

- (IBAction)onCollectButtonAction:(id)sender;

- (IBAction)onDiggButtonAction:(id)sender;


@end
