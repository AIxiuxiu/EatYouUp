//
//  QSFavourableDetailViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSFavourableDetailViewController : QSPrepaidChannelImageViewController

/**
 *  @author         yangshengmeng, 15-01-06 09:01:16
 *
 *  @brief          根据详情信息初始化详情说明
 *
 *  @param comment  说明信息
 *
 *  @return         返回一个显示详情的页面
 *
 *  @since          2.0
 */
- (instancetype)initWithDetailComment:(NSString *)comment;

@end
