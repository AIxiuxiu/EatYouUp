//
//  QSMerchantIndexCell4.h
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewCell.h"

@class QSMerchantDetailData;
@interface QSMerchantIndexCell4 : QSViewCell

@property (nonatomic, strong) QSMerchantDetailData *item;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIView *bgImageView;
@property (nonatomic, strong) void(^onButtonHandler)(NSInteger);

- (IBAction)onButtonAction:(id)sender;

@end