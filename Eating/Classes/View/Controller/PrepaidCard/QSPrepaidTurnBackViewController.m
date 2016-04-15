//
//  QSPrepaidTurnBackViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidTurnBackViewController.h"

@interface QSPrepaidTurnBackViewController (){
    NSString *_comeBackVCIndext;//返回按钮的下标
}

@property (nonatomic,strong) QSPrepaidCardNavigationBar *navigationBar;

@end

@implementation QSPrepaidTurnBackViewController

//*********************************
//             初始化
//*********************************
#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        ///初始化返回下标
        _comeBackVCIndext = [NSString stringWithFormat:@"-1"];
        
        ///初始化返回是否使用动画的标记
        self.turnBackAninmationFlag = YES;
        
    }
    
    return self;
}

//*********************************
//             UI搭建
//*********************************
#pragma mark - UI搭建
- (void)setupUI
{
    //取消scrollview自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置背景颜色
    self.view.backgroundColor = kBaseBackgroundColor;
    
    //创建主展示视图
    [self createMainShowView];
    
    //创建navigation bar
    [self createNavigationBar];
    
    //创建tabBar
    [self createTabBar];
}

/**
 *  @author yangshengmeng, 14-12-09 17:12:08
 *
 *  @brief  创建导航栏视图
 *
 *  @since 2.0
 */
- (void)createNavigationBar
{
    //创建导航栏并添加返回按钮
    self.navigationBar = [[QSPrepaidCardNavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DeviceWidth, 64.0f) andCallBack:^(NAVIGATIONBAR_CALLBACK_TYPE actionType) {
        
        if (actionType == TURNBACK_NCT) {
            
            ///调用返回接口
            [self turnBackAction];
            
        }
        
    }];
    [self.navigationBar setNavigationBarTurnBackButton];
    [self.view addSubview:self.navigationBar];
}

/**
 *  @author yangshengmeng, 14-12-09 17:12:49
 *
 *  @brief  创建主展示信息视图
 *
 *  @since 2.0
 */
- (void)createMainShowView
{
    //
}

/**
 *  @author yangshengmeng, 14-12-09 17:12:22
 *
 *  @brief  创建底Tabbar视图
 *
 *  @since 2.0
 */
- (void)createTabBar
{
    //
}

//*******************************
//             导航栏事件响应
//*******************************
#pragma mark - 导航栏事件响应
- (void)navigationBarCallBackAction:(NAVIGATIONBAR_CALLBACK_TYPE)actionType
{
    
}

//*******************************
//             设置导航栏不同的UI
//*******************************
#pragma mark - 设置导航栏不同的UI
- (void)setNavigationBarLeftView:(UIView *)view
{
    [self.navigationBar setNavigationBarLeftView:view];
}

- (void)setNavigationBarMiddleTitle:(NSString *)title
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationBar setNavigationBarMiddleTitle:title];
    });
}

- (void)setNavigationBarMiddleView:(UIView *)view
{
    [self.navigationBar setNavigationBarMiddleView:view];
}

- (void)setNavigationBarRightView:(UIView *)view
{
    [self.navigationBar setNavigationBarRightView:view];
}

#pragma mark - 触摸事件转发
- (void)sendTouchBeganAction:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.navigationBar touchesBegan:touches withEvent:event];
}

/**
 *  @author yangshengmeng, 14-12-12 22:12:31
 *
 *  @brief  判断当前是否已登录，如果传入一个YES的参数会弹出登录窗口，否，则只是返回检查结果
 *
 *  @return YES-表示已登录
 *
 *  @since  2.0
 */
#pragma mark - 检测登录状态
- (BOOL)checkLoginStatus:(BOOL)flag
{
    BOOL isLogin = YES;
    if (![UserManager sharedManager].userData) {
        isLogin = NO;
        
        ///如果flag为真，则弹出登录窗口
        if (flag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPresentLoginViewNotification object:nil];
        }
        
    }
    return isLogin;
}

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
#pragma mark - 弹出给定显示时间的alertView
- (void)showAlertMessageWithTime:(CGFloat)showTime andMessage:(NSString *)msg andCallBack:(void(^)(CGFloat showTime))callBack
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    //显示一秒后返回
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(showTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///回调
        if (callBack) {
            callBack(showTime);
        }
        
        ///消失
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
    });
}

/**
 *  @author yangshengmeng, 14-12-15 10:12:47
 *
 *  @brief  返回事件，如果不重写，则默认返回给定的下标VC，重写，就按重写跳转
 *
 *  @since  2.0
 */
#pragma mark - 返回按钮事件
- (void)turnBackAction
{
    
    //判断是否有指定返回下标
    int indext = [_comeBackVCIndext intValue];
    
    //返回上一级
    if (indext == -1) {
        
        [self.navigationController popViewControllerAnimated:self.turnBackAninmationFlag];
        
        return;
    }
    
    //返回给定下标VC
    if (indext > 0) {
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[[self.navigationController.viewControllers count] - indext] animated:self.turnBackAninmationFlag];
        
        return;
    }
    
}

@end
