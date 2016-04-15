//
//  QSPrepaidCarViewController.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidTurnBackViewController.h"

@interface QSPrepaidCarViewController : QSPrepaidTurnBackViewController

/**
 *  @author                 yangshengmeng, 14-12-23 17:12:04
 *
 *  @brief                  创建一个指定商户的储值卡列表
 *
 *  @param couponListType   列表类型：一般是指定商户的储值卡列表类型
 *  @param merchantID       商户ID
 *
 *  @return                 返回一个储值卡列表
 *
 *  @since                  2.0
 */
- (instancetype)initWithCouponListType:(GET_COUPONTLIST_TYPE)couponListType andMerchantID:(NSString *)merchantID;

@end
