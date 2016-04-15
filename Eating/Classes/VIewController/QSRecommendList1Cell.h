//
//  QSRecommendList1Cell.h
//  Eating
//
//  Created by System Administrator on 12/9/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UI.h"
//time_pro 限时优惠数组 ，里面具体字段 看限时优惠字段说明
//greens_pro菜品优惠数组 ，里面具体字段 看限时菜品字段说明
//vip_pro   vip优惠数组 ，里面具体字段 看vip优惠字段说明
//money_coupon  代金卷数组 ，里面具体字段 看代金卷字段说明
//discount_coupon 折扣卷数组 ，里面具体字段 看折扣卷字段说明
//greens_coupon 菜品兑换券数组 ，里面具体字段 看菜品兑换券字段说明

@class QSCouponDetailData;
@interface QSRecommendList1Cell : UITableViewCell

@property (nonatomic, strong) NSDictionary *item;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;

@property (nonatomic, unsafe_unretained) kCouponType couponType;
@end
