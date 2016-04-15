//
//  QSLunchBoxCouponDetailViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/3.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSLunchBoxCouponDetailViewController : QSPrepaidChannelImageViewController

@property (nonatomic,copy) void(^refundCommitedCallBack)(int flag);

/**
*  @author              yangshengmeng, 14-12-17 22:12:14
*
*  @brief               在目标视图加载显示支付失败的询问页
*
*  @param marName       商户名称
*  @param marID         商户ID
*  @param couponID      优惠券ID
*  @param couponSubID   优惠券子ID
*  @param couponType    优惠券类型
*  @param status        优惠券当前状态
*
*  @return              返回优惠券详情页面
*
*  @since               2.0
*/
- (instancetype)initWithMarchantName:(NSString *)marName andMarchantID:(NSString *)marID andCouponID:(NSString *)couponID andCouponSubID:(NSString *)couponSubID andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType andCouponStatus:(MYLUNCHBOX_COUPON_STATUS)status;

@end
