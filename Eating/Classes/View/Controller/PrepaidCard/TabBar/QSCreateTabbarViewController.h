//
//  QSCreateTabbarViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"
#import "QSNormalTabBar.h"

@interface QSCreateTabbarViewController : QSPrepaidChannelImageViewController

/**
 *  @author yangshengmeng, 14-12-09 17:12:32
 *
 *  @brief  创建给定类型的tabbar
 *
 *  @param tabbarType tabbar的类型：FOODGROUD_TNT-美食搭吃团tabbar   FOODDETECTIVE_TNT-美食侦探社tabbar
 *
 *  @since 2.0
 */
- (void)createTabBarChannelBarWithType:(TABBAR_NORMAL_TYPE)tabbarType;

///显示左侧编辑/添加按钮
- (void)showEditButton:(BOOL)flag;

///显示满员按钮
- (void)resetMiddleButtonStyle:(TABBAR_MIDDLEBUTTON_STYLE)teamStatus;

@end
