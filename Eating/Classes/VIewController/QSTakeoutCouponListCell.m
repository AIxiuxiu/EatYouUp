//
//  QSTakeoutCouponListCell.m
//  Eating
//
//  Created by System Administrator on 12/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSTakeoutCouponListCell.h"
#import "QSConfig.h"
#import "QSAPIModel+Coupon.h"
#import <UIImageView+AFNetworking.h>
#import "NSDate+QSDateFormatt.h"
#import "UIView+UI.h"

@implementation QSTakeoutCouponListCell

- (void)setItem:(QSCouponDetailData *)item
{
    _item = item;
    
    self.nameLabel.text = _item.goods_name;
    self.dateLabel.text = [NSDate formatIntegerIntervalToDateString:_item.end_time];
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_item.coup_logo] placeholderImage:nil];
    [self.logoImageView roundView];
    
    if ([_item.goods_v_type isEqualToString:@"1"]) {
        self.priceView = [UIView priceViewWithPrice:_item.coup_price Color:kBaseOrangeColor];
        [self.contentView addSubview:self.priceView];
    }
    else if ([_item.goods_v_type isEqualToString:@"2"]){
        self.priceView = [UIView discountViewWithDiscount:_item.coup_price Color:kBaseOrangeColor];
        [self.contentView addSubview:self.priceView];
    }
    else if ([_item.goods_v_type isEqualToString:@"3"]){
        self.priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:self.priceView.bounds];
        label.text = @"免";
        label.textColor = kBaseOrangeColor;
        label.font = [UIFont systemFontOfSize:42.0];
        [self.priceView addSubview:label];
        [self.contentView addSubview:self.priceView];
    }
    

    NSString *imagename = [NSString stringWithFormat:@"recommend_list_cellbg%ld",self.bgType+1];
    self.bgImageView.image = IMAGENAME(imagename);
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    self.nameLabel.textColor = kBaseGrayColor;
    self.dateLabel.textColor = kBaseLightGrayColor;
    [self.bgImageView roundCornerRadius:8];
    
}

- (void)drawRect:(CGRect)rect
{
    self.priceView.center = CGPointMake(DeviceWidth+10-self.priceView.frame.size.width, self.frame.size.height/2);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
