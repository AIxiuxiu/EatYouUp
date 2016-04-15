//
//  QSCommitOrderViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@class QSYOrderNormalFormModel;
@interface QSCommitOrderViewController : QSPrepaidChannelImageViewController

///提供给外部调用本支付页时，支付结果的回调
@property (nonatomic,copy) void(^payResultCallBack)(NSString *payCode,NSString *payInfo);

/**
 *  @author         yangshengmeng, 14-12-12 23:12:01
 *
 *  @brief          按给定的基本订单数据创建支付订单页面，并再次细化订单信息
 *
 *  @param model    基本订单信息
 *
 *  @return         返回强化订单信息页面
 *
 *  @since          2.0
 */
- (instancetype)initWithOrderModel:(QSYOrderNormalFormModel *)model;

@end
