//
//  QSTabBarTurnBackViewController.h
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSTurnBackViewController.h"
#import "QSNormalTabBar.h"

@interface QSTabBarTurnBackViewController : QSTurnBackViewController

//******************************
//      创建channelBar
//******************************
- (void)createTabBarChannelBarWithType:(TABBAR_NORMAL_TYPE)tabBarType;

///显示左侧编辑/添加按钮
- (void)showEditButton:(BOOL)flag;

///显示满员按钮
- (void)resetMiddleButtonStyle:(TABBAR_MIDDLEBUTTON_STYLE)teamStatus;

@end
