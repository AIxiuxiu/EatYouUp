//
//  QSPrepaidTurnBackViewController.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"
#import "QSPrepaidCardNavigationBar.h"

@interface QSPrepaidTurnBackViewController : QSViewController

///返回时的动画：YES-动画返回，默认动画返回   NO-返回时没有动画
@property (nonatomic,assign) BOOL turnBackAninmationFlag;//!<返回时的动画：YES-动画返回，默认动画返回   NO-返回时没有动画

///返回时的执行事件
@property (nonatomic,copy) void(^turnBackBlock)(NSString *tipsInfo,int intParams,UIViewController *vc,NSDictionary *dictParams);//!<点击返回时的回调block

//UI创建
- (void)createNavigationBar;

- (void)createMainShowView;

- (void)createTabBar;

//导航栏各种视图添加
- (void)setNavigationBarLeftView:(UIView *)view;

- (void)setNavigationBarMiddleTitle:(NSString *)title;

- (void)setNavigationBarMiddleView:(UIView *)view;

- (void)setNavigationBarRightView:(UIView *)view;

//导航栏回调
- (void)navigationBarCallBackAction:(NAVIGATIONBAR_CALLBACK_TYPE)actionType;

//touch 事件转发
- (void)sendTouchBeganAction:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 *  @author yangshengmeng, 14-12-12 22:12:31
 *
 *  @brief  判断当前是否已登录，如果传入一个YES的参数会弹出登录窗口，否，则只是返回检查结果
 *
 *  @return YES-表示已登录
 *
 *  @since  2.0
 */
- (BOOL)checkLoginStatus:(BOOL)flag;

/**
 *  @author         yangshengmeng, 14-12-13 12:12:39
 *
 *  @brief          弹出给定显示时间的alertView，显示特定的信息，并在给定时间后，自动移除
 *
 *  @param showTime 需要显示的时间，是一个float类型的参数
 *  @param msg      显示的提示信息
 *  @param callBack 移除提示后的回调事件
 *
 *  @since          2.0
 */
- (void)showAlertMessageWithTime:(CGFloat)showTime andMessage:(NSString *)msg andCallBack:(void(^)(CGFloat showTime))callBack;

/**
 *  @author yangshengmeng, 14-12-15 10:12:47
 *
 *  @brief  返回事件
 *
 *  @since  2.0
 */
- (void)turnBackAction;

@end
