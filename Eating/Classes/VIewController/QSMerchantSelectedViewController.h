//
//  QSMerchantSelectedViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSMerchantSelectedViewController : QSPrepaidChannelImageViewController

/**
 *  @author yangshengmeng, 14-12-20 12:12:59
 *
 *  @brief  正向传的回调block，方便上级VC在商户选择窗口返回时，回调
 *
 *  @param merchantID   商户ID
 *  @param merchantName 商户名称
 *
 *
 */
@property (nonatomic,copy) void(^callBack)(NSString *merchantID,NSString *merchantName,NSDictionary *params);

@end
