//
//  QSViewController.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "QSConfig.h"
#import "UITextField+UI.h"
#import "UIButton+UI.h"
#import "UIView+UI.h"
#import "UserManager.h"
#import "NSString+Name.h"
#import "NSDate+QSDateFormatt.h"

//支付宝控制器
#import "QSAlixPayManager.h"

typedef enum
{
    LOGINVIEW_STATUS_DISMISS = 0,//!<进入登录界面时，不进行登录，直接点击了返回按钮时的状态
    LOGINVIEW_STATUS_SUCCESS,//!<之前未登录，现在已成功登录
    LOGINVIEW_STATUS_LOGINED,//!<已登录
    LOGINVIEW_STATUS_FAIL    //!<登录失败
}LOGINVIEW_STATUS;

@class QSTabbarViewController;
@interface QSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *orangeBgImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIView *topView2;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong) QSTabbarViewController *tabbarViewController;

- (void)setupUI;

- (IBAction)onBackButtonAction:(id)sender;

- (IBAction)onBackgroundButtonAction:(id)sender;

- (BOOL)checkIsLogin;

- (BOOL)checkIsLoginWithoutLoginAction;

- (BOOL)checkIsLogin:(NSString *)username and:(NSString *)password;

- (BOOL)checkIsLogin:(NSString *)username and:(NSString *)password callBack:(void(^)(LOGINVIEW_STATUS))callBack;

/**
 *  @author yangshengmeng, 14-12-25 16:12:27
 *
 *  @brief  显示一个停留一秒的提示框
 *
 *  @param view   提示框显示的父view
 *  @param tipStr 提示信息
 *
 *  @since 2.0
 */
- (void)showTip:(UIView*)view tipStr:(NSString*)tipStr;

/**
 *  @author         yangshengmeng, 14-12-25 16:12:27
 *
 *  @brief          弹出一个一秒钟的提示框，显示结束后执行给定的回调block
 *
 *  @param view     需要显示提示框的父视图
 *  @param tipStr   提示信息
 *  @param callBack 显示提示完成后的回调
 *
 *  @since          2.0
 */
- (void)showTip:(UIView*)view tipStr:(NSString*)tipStr andCallBack:(void(^)(void))callBack;

/**
 *  @author             yangshengmeng, 14-12-26 19:12:48
 *
 *  @brief              弹出一个有确认/取消按钮的提示框
 *
 *  @param confirmTitle 确认按钮标题
 *  @param cancelTitle  取消按钮标题
 *  @param tipStr       提示信息
 *  @param callBack     点击确认/或者取消时的回调
 *
 *  @since              2.0
 */
- (void)showTip:(NSString *)confirmTitle andCancelTitle:(NSString *)cancelTitle andTipsMessage:(NSString *)tipStr andCallBack:(void (^)(UIAlertActionStyle actionStyle))callBack;

- (void)showCameraActionSheetWithCallBack:(void(^)(NSInteger))callBack;

- (void)showActionSheet:(UIActionSheet *)action callBack:(void(^)(NSInteger))callBack;

- (void)makeCall:(NSString *)number;

- (void)showLoadingHud;

- (void)hideLoadingHud;

/**
 *  @author yangshengmeng, 14-12-18 16:12:33
 *
 *  @brief  如果列表数据为0，则显示暂无记录
 *
 *  @since  2.0
 */
- (void)showNoRecordUI:(BOOL)flag;

@end
