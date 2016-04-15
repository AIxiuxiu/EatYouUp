//
//  QSOrderFormViewController.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@class QSYCouponDetailDataModel;
@interface QSOrderFormViewController : QSPrepaidChannelImageViewController

/**
 *  @author yangshengmeng, 14-12-12 16:12:43
 *
 *  @brief  根据优惠券的数据模型生成订单页面
 *
 *  @param  model 优惠券模型
 *
 *  @return 返回订单页面
 *
 *  @since  2.0
 */
- (instancetype)initWithOrderFormModel:(QSYCouponDetailDataModel *)model;

@end
