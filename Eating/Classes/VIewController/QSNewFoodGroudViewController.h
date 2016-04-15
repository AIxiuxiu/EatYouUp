//
//  QSNewFoodGroudViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@class QSNewFoodGroudModel;
@interface QSNewFoodGroudViewController : QSPrepaidChannelImageViewController

/**
 *  @author         yangshengmeng, 14-12-21 18:12:29
 *
 *  @brief          创建一个静态的搭食团详情页面
 *
 *  @param model    详情的数据模型
 *
 *  @return         返回当前创建的详情页
 *
 *  @since          2.0
 */
- (instancetype)initStaticDetailWithModel:(QSNewFoodGroudModel *)model;

@end
