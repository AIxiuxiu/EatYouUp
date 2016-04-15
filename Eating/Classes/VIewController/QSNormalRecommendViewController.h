//
//  QSNormalRecommendViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/23.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidTurnBackViewController.h"

@interface QSNormalRecommendViewController : QSPrepaidTurnBackViewController

/**
 *  @author             yangshengmeng, 14-12-23 14:12:03
 *
 *  @brief              根据给定的商户ID，列出对应商户的优惠页面
 *
 *  @param merchantID   商户ID
 *
 *  @return             返回当前列表对象
 *
 *  @since              2.0
 */
- (instancetype)initWithMerchantID:(NSString *)merchantID;

@end
