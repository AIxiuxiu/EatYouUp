//
//  QSCouponCell.m
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSCouponCell.h"
#import "QSConfig.h"


@implementation QSCouponCell

- (void)awakeFromNib {

    [self.contentView customView:_couponType];
    
    self.contentLabel.textColor = kBaseGrayColor;
    self.limitLabel.textColor = kBaseLightGrayColor;
    self.rightLabel.textColor = kBaseOrangeColor;
    
    self.backgroundImageView.image = IMAGENAME(@"recommend_list_cellbg2.png");
    
    self.contentLabel.text = @"优惠券内容 优惠券详情 优惠券信息.......优惠券内容 优惠券详情 优惠券信息";
    self.limitLabel.text = @"有效期: 至2014-10-17";
    self.rightLabel.text = @"8";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
