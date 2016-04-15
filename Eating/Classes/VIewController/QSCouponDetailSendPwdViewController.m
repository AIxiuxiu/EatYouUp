//
//  QSCouponDetailSendPwdViewController.m
//  Eating
//
//  Created by ysmeng on 15/1/7.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import "QSCouponDetailSendPwdViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "AppDelegate.h"
#import "QSConfig.h"
#import "NSString+Name.h"
#import "QSBlockActionButton.h"

@interface QSCouponDetailSendPwdViewController ()<UITextFieldDelegate>

@property (nonatomic,copy) NSString *phoneNumber;//!<手机号码
@property (nonatomic,copy) NSString *sendMessage;//!<所需要发送的消息

@end

@implementation QSCouponDetailSendPwdViewController

/**
 *  @author         yangshengmeng, 15-01-07 15:01:14
 *
 *  @brief          显示发送消息窗口
 *
 *  @param phone    手机号码
 *  @param msg      消息
 *
 *  @return         返回消息窗口指针
 *
 *  @since          2.0
 */
+ (instancetype)showSendMessageWithPhone:(NSString *)phone andMessage:(NSString *)msg
{

    QSCouponDetailSendPwdViewController *sendMsgVC = [[QSCouponDetailSendPwdViewController alloc] initWithPhoneNumber:phone andMessage:msg];
    
    sendMsgVC.view.frame = CGRectMake(0.0f, DeviceHeight, DeviceWidth, DeviceHeight);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:sendMsgVC.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        sendMsgVC.view.frame = CGRectMake(0.0f, 0.0f, DeviceWidth, DeviceHeight);
        
    }];
    
    return sendMsgVC;

}

/**
 *  @author         yangshengmeng, 15-01-07 15:01:32
 *
 *  @brief          根据手机号码初始化发送密码窗口
 *
 *  @param phone    手机号码
 *
 *  @return         返回发送密码窗口
 *
 *  @since          2.0
 */
- (instancetype)initWithPhoneNumber:(NSString *)phone andMessage:(NSString *)msg
{

    if (self = [super init]) {
        
        ///保存手机号码和消息
        self.phoneNumber = phone;
        self.sendMessage = msg;
        
    }
    
    return self;

}

///加载UI
#pragma mark - 创建普通UI
- (void)viewDidLoad
{
    [super viewDidLoad];

    ///背景view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DeviceWidth, DeviceHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    [self.view addSubview:bgView];
    
    ///背景添加单点事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [bgView addGestureRecognizer:tap];
    
    ///中心功能区
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, DeviceHeight - 250.0f, DEFAULT_MAX_WIDTH, 220.0f)];
    rootView.backgroundColor = [UIColor whiteColor];
    rootView.layer.cornerRadius = 6.0f;
    rootView.tag = 601;
    [self.view addSubview:rootView];
    
    ///手机号码输入框
    UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 30.0f, rootView.frame.size.width-20.0f, 44.0f)];
    phoneField.borderStyle = UITextBorderStyleRoundedRect;
    phoneField.font = [UIFont systemFontOfSize:16.0f];
    phoneField.text = self.phoneNumber;
    phoneField.placeholder = @"手机号码";
    phoneField.delegate = self;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [rootView addSubview:phoneField];
    
    ///发送按钮
    UIButton *sendButton = [UIButton createBlockActionButton:CGRectMake(10.0f, 81.0f, rootView.frame.size.width-20.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///判断手机号码
        BOOL checkPhone = [NSString isValidateMobile:phoneField.text];
        
        ///是合法手机号码
        if (checkPhone) {
            
            [self sendMessageAction];
            return;
        }
        
        ///非法手机号码
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号码有误，请确认后再发送" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
        });
        
    }];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    sendButton.backgroundColor = kBaseGreenColor;
    sendButton.layer.cornerRadius = 4.0f;
    [rootView addSubview:sendButton];
    
    ///取消按钮
    UIButton *backButton = [UIButton createBlockActionButton:CGRectMake(10.0f, 133.0f, rootView.frame.size.width-20.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        [self.view removeFromSuperview];
        
    }];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    backButton.backgroundColor = kBaseGreenColor;
    backButton.layer.cornerRadius = 4.0f;
    [rootView addSubview:backButton];
    
    ///弹出键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUpViewAction) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveDownViewAction) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 键盘弹出时，整体的内容view上移/回收时恢复原会标
- (void)moveDownViewAction
{

    UIView *rootView = [self.view viewWithTag:601];
    if (rootView) {
        
        rootView.frame = CGRectMake(rootView.frame.origin.x, DeviceHeight- 250.0f, DEFAULT_MAX_WIDTH, 220.0f);
        
    }

}

- (void)moveUpViewAction
{

    UIView *rootView = [self.view viewWithTag:601];
    if (rootView) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            rootView.frame = CGRectMake(rootView.frame.origin.x, DeviceHeight - 250.0f - 200.0f, DEFAULT_MAX_WIDTH, 220.0f);
            
        }];
        
    }

}

#pragma mark - 点击灰色区域时，回收视图
- (void)singleTapAction:(UITapGestureRecognizer *)tap
{
    
    [self.view removeFromSuperview];

}

///发送消息事件
#pragma mark - 点击发送按钮时的事件
- (void)sendMessageAction
{
    
    ///判断参数
    if (nil == self.phoneNumber || nil == self.sendMessage) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号码有误，请确认后再发送" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
        });
        
        return;
    }

    ///将密码发送到手机
    [[QSAPIClientBase sharedClient] sendPhoneMessageForCurrentUser:self.sendMessage andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否已发送成功
        if (flag) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [self.view removeFromSuperview];
                
            });
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送失败！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
        });
        
    }];

}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.view becomeFirstResponder];

}

@end
