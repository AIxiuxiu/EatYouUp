//
//  QSMerchantIndexCell3.h
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewCell.h"

typedef enum
{
    kProType_Promotion,
    kProType_Coupon,
    kProType_Card
}kProType;

@class QSMerchantDetailData;
@interface QSMerchantIndexCell3 : QSViewCell

@property (nonatomic, strong) NSDictionary *item;

@property (nonatomic, unsafe_unretained) kProType protype;

@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@end
