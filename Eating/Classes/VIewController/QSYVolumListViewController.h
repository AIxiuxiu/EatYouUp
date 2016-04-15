//
//  QSYVolumListViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidTurnBackViewController.h"

@interface QSYVolumListViewController : QSPrepaidTurnBackViewController

/**
 *  @author                 yangshengmeng, 14-12-23 17:12:48
 *
 *  @brief                  此接口专门为从商户进入商户优惠列表设定，只列出些商户的优惠信息
 *
 *  @param couponListType   列表类型
 *
 *  @return                 返回创建的当前VC
 *
 *  @since                  2.0
 */
- (instancetype)initWithListType:(GET_COUPONTLIST_TYPE)couponListType andMerchantID:(NSString *)merchantID;

@end
