//
//  QSAPIClientBase+GetCoupon.h
//  Eating
//
//  Created by ysmeng on 14/12/17.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+GetCoupon.h"

@interface QSAPIClientBase (GetCoupon)

/**
 *  @author         yangshengmeng, 14-12-17 21:12:45
 *
 *  @brief          领取优惠券
 *
 *  @param couponID 优惠券ID
 *  @param callBack 领取成功/失败的回调
 *
 *  @since          2.0
 */
- (void)getCouponWithID:(NSString *)couponID andCallBack:(void(^)(BOOL getResult,NSString *errorInfo,NSString *errorCode))callBack;

@end
