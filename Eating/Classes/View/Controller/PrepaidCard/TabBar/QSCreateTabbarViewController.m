//
//  QSCreateTabbarViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSCreateTabbarViewController.h"

#import <objc/runtime.h>

//关联
static char CustomTabBarViewKey;
@interface QSCreateTabbarViewController ()

@end

@implementation QSCreateTabbarViewController

/**
 *  @author yangshengmeng, 14-12-09 17:12:22
 *
 *  @brief  创建底Tabbar视图
 *
 *  @since 2.0
 */
- (void)createTabBar
{
    QSNormalTabBar *tabBar = [[QSNormalTabBar alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 57.0f, self.view.frame.size.width, 57.0f) andCallBack:^(TABBAR_NORMAL_ACTION_TYPE actionType, BOOL flag) {
        
        ///tabBar事件分发
        [self customTabBarAction:actionType];
        
    }];
    [self.view addSubview:tabBar];
    objc_setAssociatedObject(self, &CustomTabBarViewKey, tabBar, OBJC_ASSOCIATION_ASSIGN);
}

/**
 *  @author yangshengmeng, 14-12-09 17:12:32
 *
 *  @brief  创建给定类型的tabbar
 *
 *  @param tabbarType tabbar的类型：FOODGROUD_TNT-美食搭吃团tabbar   FOODDETECTIVE_TNT-美食侦探社tabbar
 *
 *  @since 2.0
 */
- (void)createTabBarChannelBarWithType:(TABBAR_NORMAL_TYPE)tabBarType
{
    QSNormalTabBar *tabBar = objc_getAssociatedObject(self, &CustomTabBarViewKey);
    [tabBar createChannelBarWithType:tabBarType];
}

//tabBar事件
- (void)customTabBarAction:(TABBAR_NORMAL_ACTION_TYPE)actionType
{
    
}

///显示左侧编辑/添加按钮
- (void)showEditButton:(BOOL)flag
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNormalTabBar *tabBar = objc_getAssociatedObject(self, &CustomTabBarViewKey);
        [tabBar showEditButton:flag];
        
    });
    
}

///显示满员按钮
- (void)resetMiddleButtonStyle:(TABBAR_MIDDLEBUTTON_STYLE)statusStyle
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNormalTabBar *tabBar = objc_getAssociatedObject(self, &CustomTabBarViewKey);
        [tabBar resetMiddleButtonStyle:statusStyle];
        
    });
    
}

@end
