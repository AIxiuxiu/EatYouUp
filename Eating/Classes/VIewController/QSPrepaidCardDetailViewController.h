//
//  QSPrepaidCardDetailViewController.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidTurnBackViewController.h"

@interface QSPrepaidCardDetailViewController : QSPrepaidTurnBackViewController

/**
 *  @author             yangshengmeng, 14-12-12 10:12:44
 *
 *  @brief              根据商户名称和集会卡ID创建详情页面
 *
 *  @param marchantName 商户名
 *  @param cardID       集会卡ID
 *
 *  @return             返回详情页面
 *
 *  @since              2.0
 */
- (instancetype)initWithMarchantName:(NSString *)marchantName andMarID:(NSString *)marID andPrepaidCardID:(NSString *)cardID;

@end
