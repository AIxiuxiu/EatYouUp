//
//  QSPrepaidCarPayViewController.h
//  Eating
//
//  Created by ysmeng on 15/1/6.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSPrepaidCarPayViewController : QSPrepaidChannelImageViewController

/**
 *  @author     yangshengmeng, 15-01-06 17:01:45
 *
 *  @brief      根据储值卡支付的参数，初始化确认支付页面
 *
 *  @param dict 参数字典
 *
 *  @return     返回储值卡支付确认页面
 *
 *  @since      2.0
 */
- (instancetype)initWithPrepaidCardPayParams:(NSDictionary *)dict;

@end
