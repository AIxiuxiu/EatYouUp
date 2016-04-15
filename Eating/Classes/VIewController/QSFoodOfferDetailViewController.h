//
//  QSFoodOfferDetailViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/16.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSFoodOfferDetailViewController : QSPrepaidChannelImageViewController

/**
 *  @author wangshupeng, 14-12-27 10:12:50
 *
 *  @brief  根据菜品优惠券的ID创建一个菜品详情页面
 *
 *  @return 返回当前页面
 *
 *  @since  2.0
 */
- (instancetype)initWithCouponID:(NSString *)couponID andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType andCouponStatus:(MYLUNCHBOX_COUPON_STATUS)couponStatus;

@end
