//
//  QSRecommendList1Cell.m
//  Eating
//
//  Created by System Administrator on 12/9/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSRecommendList1Cell.h"
#import "QSConfig.h"

@implementation QSRecommendList1Cell

- (void)setItem:(QSCouponDetailData *)item
{
    _item = item;
}

- (void)awakeFromNib {

    self.contentLabel1.textColor = kBaseGrayColor;
    self.contentLabel2.textColor= kBaseLightGrayColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
