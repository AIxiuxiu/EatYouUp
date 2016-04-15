//
//  QSAPIClientBase+CouponList.h
//  Eating
//
//  Created by ysmeng on 14/12/10.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+CouponList.h"

@interface QSAPIClientBase (CouponList)

/**
 *  @author                 yangshengmeng, 15-01-05 12:01:47
 *
 *  @brief                  请求优惠券列表
 *
 *  @param couponListType   列表的类型
 *  @param page             获取第几页
 *  @param tempDict         参数字典
 *  @param callBack         回调
 *
 *  @since                  2.0
 */
- (void)getCouponListWithType:(GET_COUPONTLIST_TYPE)couponListType andPage:(int)page andParams:(NSDictionary *)tempDict andCallBack:(void(^)(BOOL flag,QSMarchantListReturnData *resultData,NSString *errorInfo,NSString *errorCode))callBack;

@end
