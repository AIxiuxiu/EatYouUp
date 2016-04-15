//
//  QSUseNoticeViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@class QSYCouponDetailDataModel;
@interface QSUseNoticeViewController : QSPrepaidChannelImageViewController

/**
 *  @author         yangshengmeng, 14-12-12 15:12:39
 *
 *  @brief          通过使用详情信息模型创建使用知悉页面
 *
 *  @param model    使用知须数据模型
 *
 *  @return         返回使用知悉页面
 *
 *  @since          2.0
 */
- (instancetype)initWithDataModel:(QSYCouponDetailDataModel *)model;

@end
