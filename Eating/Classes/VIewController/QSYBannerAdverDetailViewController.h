//
//  QSYBannerAdverDetailViewController.h
//  Eating
//
//  Created by ysmeng on 15/1/6.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSYBannerAdverDetailViewController : QSPrepaidChannelImageViewController

/**
 *  @author             yangshengmeng, 15-01-06 12:01:28
 *
 *  @brief              根据给定的活动地址初始化活动详情页面
 *
 *  @param urlString    活动地址url
 *
 *  @return             返回活动详情页面
 *
 *  @since              2.0
 */
- (instancetype)initWithURL:(NSString *)urlString;

@end
