//
//  QSTabBarTurnBackViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSTabBarTurnBackViewController.h"

#import <objc/runtime.h>

//tabBar关联key
static char TabBarViewKey;
@interface QSTabBarTurnBackViewController ()

@end

@implementation QSTabBarTurnBackViewController

//创建tabBar
- (void)createTabBar
{
    QSNormalTabBar *tabBar = [[QSNormalTabBar alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 57.0f, self.view.frame.size.width, 57.0f) andCallBack:^(TABBAR_NORMAL_ACTION_TYPE actionType, BOOL flag) {
        
        ///跳转到底部事件分发
        [self tabBarAction:actionType];
        
    }];
    [self.view addSubview:tabBar];
    objc_setAssociatedObject(self, &TabBarViewKey, tabBar, OBJC_ASSOCIATION_ASSIGN);
}

- (void)createTabBarChannelBarWithType:(TABBAR_NORMAL_TYPE)tabBarType
{
    QSNormalTabBar *tabBar = objc_getAssociatedObject(self, &TabBarViewKey);
    [tabBar createChannelBarWithType:tabBarType];
}

///显示左侧编辑/添加按钮
- (void)showEditButton:(BOOL)flag
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNormalTabBar *tabBar = objc_getAssociatedObject(self, &TabBarViewKey);
        [tabBar showEditButton:flag];
        
    });

}

///显示满员按钮
- (void)resetMiddleButtonStyle:(TABBAR_MIDDLEBUTTON_STYLE)statusStyle
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNormalTabBar *tabBar = objc_getAssociatedObject(self, &TabBarViewKey);
        [tabBar resetMiddleButtonStyle:statusStyle];
        
    });

}

///tabBar事件
- (void)tabBarAction:(TABBAR_NORMAL_ACTION_TYPE)actionType
{
    
}

@end
