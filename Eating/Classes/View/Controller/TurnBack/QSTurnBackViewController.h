//
//  QSTurnBackViewController.h
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSTurnBackViewController : QSViewController

//创建导航栏
- (void)createNavigationBar;

//创建中间展现视图
- (void)createMiddleMainShowView;

//创建tabBar
- (void)createTabBar;

//设置中间标题
- (void)setMiddleTitle:(NSString *)title;

//设置中间视图
- (void)setMiddleView:(UIView *)view;

//设置右侧视图
- (void)setRightView:(UIView *)view;

//channel创建
- (void)createNavigationChannelBar;

@end
