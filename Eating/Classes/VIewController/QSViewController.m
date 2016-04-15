//
//  QSViewController.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"
#import "QSLoginViewController.h"
#import "QSTabbarViewController.h"
#import <objc/runtime.h>
#import "QSYCustomHUD.h"
#import "QSAPIModel+User.h"


#define kCallAlertViewTag 111

@interface QSViewController ()<UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) void(^actionSheetCallBack)(NSInteger);
@property (nonatomic, copy) NSString *phoneNumber;
@end

@implementation QSViewController

- (QSTabbarViewController *)tabbarViewController
{
    return [QSTabbarViewController sharedTabBarController];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = kBaseBackgroundColor;
    
    self.topView.backgroundColor = [UIColor clearColor];
    self.orangeBgImageView.backgroundColor = kBaseOrangeColor;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.backButton addTarget:self action:@selector(onBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = self.titleLabel.frame;
    frame.size.width = 260;
    self.titleLabel.frame = frame;
    

    self.backButton.center = CGPointMake(20, 40);
    
    self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.orangeBgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.titleLabel.center = CGPointMake(DeviceMidX, 40);
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    CGRect frame = self.topView.frame;
    frame.size.width = DeviceWidth;
    self.topView.frame = frame;
    
    frame = self.topView2.frame;
    frame.size.width = DeviceWidth;
    self.topView2.frame = frame;
}

- (BOOL)checkIsLogin
{
    BOOL isLogin = YES;
    if (![[UserManager sharedManager].userData hadUserId]) {
        isLogin = NO;
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_login_count"];
        NSString *loginPwd = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_login_pwd"];
        
        NSDictionary *dict = @{
                               @"username" : userName ? userName : @"",
                               @"password" : loginPwd ? loginPwd : @""
                               };
        [[QSTabbarViewController sharedTabBarController] showLoginViewDict:dict Callback:^(LOGINVIEW_STATUS status) {
            
            
            
        }];
    }
    
    return isLogin;
}

- (BOOL)checkIsLoginWithoutLoginAction
{
    BOOL isLogin = YES;
    if (![[UserManager sharedManager].userData hadUserId]) {
        
        isLogin = NO;
        
    }
    
    return isLogin;
}

- (BOOL)checkIsLogin:(NSString *)username and:(NSString *)password
{
    BOOL isLogin = YES;
    if (![[UserManager sharedManager].userData hadUserId]) {
        isLogin = NO;
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_login_count"];
        NSString *loginPwd = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_login_pwd"];
        
        NSDictionary *dict = @{
                               @"username" : username ? username : (userName ? userName : @""),
                               @"password" : password ? password : (loginPwd ? loginPwd : @"")
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:kPresentLoginViewNotification
                                                            object:dict];
    }
    return isLogin;
}

- (BOOL)checkIsLogin:(NSString *)username and:(NSString *)password callBack:(void (^)(LOGINVIEW_STATUS))callBack
{
    BOOL isLogin = YES;
    if (![[UserManager sharedManager].userData hadUserId]) {
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_login_count"];
        NSString *loginPwd = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_login_pwd"];
        
        isLogin = NO;
        NSDictionary *dict = @{
                               @"username" : username ? username : (userName ? userName : @""),
                               @"password" : password ? password : (loginPwd ? loginPwd : @"")
                               };
        [[QSTabbarViewController sharedTabBarController] showLoginViewDict:dict Callback:callBack];
        
    } else {
    
        ///如果已经登录，直接回调
        if (callBack) {
            
            callBack(LOGINVIEW_STATUS_LOGINED);
            
        }
        
    }
    return isLogin;
}


- (void)makeCall:(NSString *)number
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
    message:[NSString stringWithFormat:@"呼叫 %@",number] delegate:self
    cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    alertView.tag = kCallAlertViewTag;
    self.phoneNumber = number;
    [alertView show];
}

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
#pragma mark - 弹出一秒钟的提示框
- (void)showTip:(UIView*)view tipStr:(NSString*)tipStr
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:tipStr delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    //显示一秒后返回
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///消失
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
    });
    
}

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
- (void)showTip:(UIView*)view tipStr:(NSString*)tipStr andCallBack:(void(^)(void))callBack
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:tipStr delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    //显示一秒后返回
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///回调
        if (callBack) {
            callBack();
        }
        
        ///消失
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
    });
    
}

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
- (void)showTip:(NSString *)confirmTitle andCancelTitle:(NSString *)cancelTitle andTipsMessage:(NSString *)tipStr andCallBack:(void (^)(UIAlertActionStyle actionStyle))callBack
{
    
    ///提示框
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:tipStr preferredStyle:UIAlertControllerStyleAlert];
    
    ///确认事件
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if (callBack) {
            callBack(UIAlertActionStyleDefault);
        }
        
    }];
    [alertView addAction:confirmAction];
    
    ///取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        if (callBack) {
            callBack(UIAlertActionStyleCancel);
        }
        
    }];
    [alertView addAction:cancelAction];
    
    ///弹出
    [self presentViewController:alertView animated:YES completion:^{
        
    }];

}

- (void)showLoadingHud
{
    [QSYCustomHUD showOperationHUD:self.view];
}

- (void)hideLoadingHud
{
    [QSYCustomHUD hiddenOperationHUD];
}

- (void)showCameraActionSheetWithCallBack:(void(^)(NSInteger))callBack;
{
    [self showActionSheet:[self cameraActionSheet] callBack:callBack];
}

- (void)showActionSheet:(UIActionSheet *)action callBack:(void (^)(NSInteger))callBack
{
    self.actionSheetCallBack = callBack;
    action.delegate = self;
    [action showInView:self.view];
    [self.tabbarViewController hideTabBar];
}

- (UIActionSheet *)cameraActionSheet
{
    UIActionSheet *ac = (UIActionSheet *)objc_getAssociatedObject(self, @"CF Tabbar Action Sheet");
    if (!ac) {
        ac = [[UIActionSheet alloc] initWithTitle:nil
                                         delegate:self
                                cancelButtonTitle:nil
                           destructiveButtonTitle:@"取消"
                                otherButtonTitles:@"相机", @"相册", nil];
        
        objc_setAssociatedObject(self, @"CF Tabbar Action Sheet", ac, OBJC_ASSOCIATION_RETAIN);
        ac.tag = 111;
    }
    return ac;
}


- (IBAction)onBackButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.actionSheetCallBack(buttonIndex);
}


#pragma mark UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kCallAlertViewTag) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
        }
    }
}

/**
 *  @author yangshengmeng, 14-12-18 16:12:33
 *
 *  @brief  如果列表数据为0，则显示暂无记录
 *
 *  @since  2.0
 */
#pragma mark - 显示暂无记录信息
- (void)showNoRecordUI:(BOOL)flag
{
    
    __block UILabel *noRecordLabel = (UILabel *)[self.view viewWithTag:344];
    
    ///判断是否是隐藏
    if (!flag) {
        
        if (noRecordLabel) {
            
            [noRecordLabel removeFromSuperview];
            
        }
        
        return;
    }
    
    ///需要显示无记录
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (nil == noRecordLabel) {
            
            noRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 160.0f, DeviceWidth-60.0f, 60.0f)];
            noRecordLabel.tag = 344;
            noRecordLabel.text = @"暂无记录";
            noRecordLabel.textAlignment = NSTextAlignmentCenter;
            noRecordLabel.textColor = kBaseGrayColor;
            noRecordLabel.font = [UIFont boldSystemFontOfSize:30.0f];
            noRecordLabel.alpha = 0.0f;
            [self.view addSubview:noRecordLabel];
            
            ///动画显示
            [UIView animateWithDuration:0.3 animations:^{
                
                noRecordLabel.alpha = 1.0f;
                
            }];
            
        }
        
        ///如果原来就存在，则不修改
        [self.view bringSubviewToFront:noRecordLabel];
        
    });
    
}

@end
