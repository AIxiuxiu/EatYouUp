//
//  QSMerchantIndexCell1.h
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewCell.h"

@class QSMerchantDetailData;
@interface QSMerchantIndexCell1 : QSViewCell

@property (nonatomic, strong) QSMerchantDetailData *item;

@property (weak, nonatomic) IBOutlet UIButton *consumeButton;
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *starbgImageView;

@property (nonatomic, strong) void(^onCollectHandler)(BOOL);

- (IBAction)onCollectButtonAction:(id)sender;

@end
