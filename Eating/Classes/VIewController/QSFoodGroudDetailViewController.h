//
//  QSFoodGroudDetailViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSFoodGroudDetailViewController : QSPrepaidChannelImageViewController

/**
 *  @author         yangshengmeng, 14-12-24 10:12:48
 *
 *  @brief          初始化一个搭食团详情页面，需要传入当前搭食团的ID及用户ID
 *
 *  @param userID   用户ID
 *  @param teamID   搭食团的ID
 *  @param merName  商户名称
 *
 *  @return         返回详情页
 *
 *  @since          2.0
 */
- (instancetype)initWithID:(NSString *)userID andTeamID:(NSString *)teamID andMerchantName:(NSString *)merName;

@end
