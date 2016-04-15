//
//  QSMerchantIndexCell3.m
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantIndexCell3.h"
#import "QSAPIModel+Merchant.h"
#import "UIView+UI.h"
#import "QSConfig.h"

@implementation QSMerchantIndexCell3

- (void)setItem:(NSDictionary *)item
{
    _item = item;

    if (self.protype == kProType_Promotion) {
        [self.icon setTitle:@"促" forState:UIControlStateNormal];
        self.content.text = [_item objectForKey:@"goods_name"];
    }
    else if (self.protype == kProType_Coupon){
        [self.icon setTitle:@"券" forState:UIControlStateNormal];
        self.content.text = [_item objectForKey:@"goods_name"];
    }
    else if (self.protype == kProType_Card){
        [self.icon setTitle:@"券" forState:UIControlStateNormal];
    }
    
    self.price1.hidden = YES;
    self.price2.hidden = YES;
}



- (void)awakeFromNib {

    [self.icon setBackgroundColor:kBaseGreenColor];
    [self.icon roundCornerRadius:2];
    self.price1.textColor = kBaseGreenColor;
    self.price2.textColor = kBaseGrayColor;
    self.content.textColor = kBaseGrayColor;
    [self.bgImageView roundCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
