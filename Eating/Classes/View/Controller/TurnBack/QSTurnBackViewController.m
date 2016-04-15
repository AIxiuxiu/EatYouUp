//
//  QSTurnBackViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSTurnBackViewController.h"
#import "QSNormalNavigationBar.h"

#import <objc/runtime.h>

//导航栏关联
static char NavigationBarKey;
@implementation QSTurnBackViewController

//创建UI
- (void)setupUI
{
    //设置UITabelView的自动开始
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //背景颜色
    self.view.backgroundColor = kBaseBackgroundColor;
    
    //创建主显示列表的底scrollView
    [self createMiddleMainShowView];
    
    //创建tabBar
    [self createTabBar];
    
    //创建导航栏
    [self createNavigationBar];
}

//创建导航栏
- (void)createNavigationBar
{
    //创建navigation：640 × 172
    QSNormalNavigationBar *navBar = [[QSNormalNavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 120.0f)];
    [self.view addSubview:navBar];
    [navBar addTurnBackButton];
    navBar.callBack = ^(NAVIGATION_BAR_NORMAL_ACTION_TYPE actionType,BOOL flag){
        
        if (actionType == DEFAULT_NBNAT) {
            //如果是默认事件，直接返回
            return;
        }
        
        //返回事件
        if (actionType == TURN_BACK_NBNAT) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        //进入导航栏事件分发中心
        [self navigationBarAction:actionType andFlag:flag];
        
    };
    objc_setAssociatedObject(self, &NavigationBarKey, navBar, OBJC_ASSOCIATION_ASSIGN);
}

//创建中间展现视图
- (void)createMiddleMainShowView
{
    
}

//创建tabBar
- (void)createTabBar
{
    
}

//设置中间标题
- (void)setMiddleTitle:(NSString *)title
{
    QSNormalNavigationBar *navBar = objc_getAssociatedObject(self, &NavigationBarKey);
    [navBar setMiddleTitle:title];
}

//设置中间视图
- (void)setMiddleView:(UIView *)view
{
    QSNormalNavigationBar *navBar = objc_getAssociatedObject(self, &NavigationBarKey);
    [navBar setMiddleView:view];
}

//设置右侧视图
- (void)setRightView:(UIView *)view
{
    QSNormalNavigationBar *navBar = objc_getAssociatedObject(self, &NavigationBarKey);
    [navBar setRightView:view];
}

//channel创建
- (void)createNavigationChannelBar
{
    QSNormalNavigationBar *navBar = objc_getAssociatedObject(self, &NavigationBarKey);
    [navBar createFoodGroudChannelBar];
}

//*****************************
//          导航栏事件分发
//*****************************
#pragma mark - 导航栏事件分发
- (void)navigationBarAction:(NAVIGATION_BAR_NORMAL_ACTION_TYPE)actionType andFlag:(BOOL)flag
{
    
}

@end
