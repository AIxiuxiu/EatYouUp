//
//  QSAPIClientBase+CouponDetail.h
//  Eating
//
//  Created by ysmeng on 14/12/12.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+CouponDetail.h"

@interface QSAPIClientBase (CouponDetail)

/**
 *  @author             yangshengmeng, 14-12-12 12:12:52
 *
 *  @brief              请求优惠详情
 *
 *  @param couponParam  参数：id-优惠券ID type-优惠券类型
 *  @param callBack     请求成功或失败后的回调
 *
 *  @since              2.0
 */
- (void)getCouponDetailWithID:(NSDictionary *)couponParam andCallBack:(void(^)(BOOL requestFlag,QSYCouponDetailDataModel *model,NSString *errorInfo,NSString *errorCode))callBack;

/**
 *  @author         yangshengmeng, 15-01-08 00:01:45
 *
 *  @brief          储值卡退款
 *
 *  @param params   退款参数
 *  @param callBack 退款成功或失败时的回调
 *
 *  @since          2.0
 */
- (void)prepaidCardRefundWithParams:(NSDictionary *)params andCallBack:(void(^)(int flag,NSString *errorInfo,NSString *errorCode))callBack;

@end
