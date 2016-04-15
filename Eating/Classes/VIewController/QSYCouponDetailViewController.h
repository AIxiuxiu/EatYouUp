//
//  QSYCouponDetailViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidTurnBackViewController.h"

@interface QSYCouponDetailViewController : QSPrepaidTurnBackViewController

//@property (nonatomic,retain) 

/**
 *  @author           yangshengmeng, 14-12-09 23:12:19
 *
 *  @brief            创建优惠卷详情页面
 *
 *  @param marName    优惠卷提供的商户
 *  @param couponType 优惠卷类型
 *
 *  @return           返回对应优惠卷类型
 *
 *  @since            2.0
 */
- (instancetype)initWithMarName:(NSString *)marName andMarchantID:(NSString *)marchantID andCouponID:(NSString *)couponID andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType;

@end
