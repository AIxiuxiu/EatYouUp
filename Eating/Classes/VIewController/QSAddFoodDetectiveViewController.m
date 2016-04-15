//
//  QSAddFoodDetectiveViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAddFoodDetectiveViewController.h"
#import "QSNormalNavigationBar.h"
#import "QSBlockActionButton.h"
#import "UIView+QSGraphicView.h"
#import "QSAPIClientBase+ForAGroup.h"

#import <objc/runtime.h>

//输入框tag
#define TAG_INPUTFIELD_ROOT 100

//输入框底view关联key
static char InputFieldRootViewKey;
@interface QSAddFoodDetectiveViewController ()<UITextFieldDelegate>{
    NSString *_verticalCode;//验证码
}

@end

@implementation QSAddFoodDetectiveViewController

#pragma mark - UI搭建
//创建导航栏
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setMiddleTitle:@"求探店"];
}

//创建主显示视图
- (void)createMiddleMainShowView
{
    //输入框底view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 110.0f, DeviceWidth-20.0f, 304.0f)];
    [self.view addSubview:view];
    [self createAddFoodDetectiveStore:view];
    //关联底view
    objc_setAssociatedObject(self, &InputFieldRootViewKey, view, OBJC_ASSOCIATION_ASSIGN);
    
    //注册回收键盘时的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverInputView:) name:UIKeyboardWillHideNotification object:nil];
}

//添加输入控件
- (void)createAddFoodDetectiveStore:(UIView *)view
{
    CGFloat gap = 5.0f;
    CGFloat height = 44.0f;
    CGFloat width = view.frame.size.width - 10.0f;
    NSArray *placeHoldArray = @[@"探店商家名称",@"探店商家地址",@"探店商家联系电话",@"备注信息",@"验证码"];
    for (int i = 0; i < 5; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(gap, gap*(i+1)+height*i, width, height)];
        
        //设置圆角
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        //设置白色背景
        textField.backgroundColor = [UIColor whiteColor];
        
        //place hold信息
        textField.placeholder = placeHoldArray[i];
        
        //设置代理
        textField.delegate = self;
        
        //地址输入框添加定位按钮
        if (i == 1) {
            UIButton *localButton = [UIButton createBlockActionButton:CGRectMake(textField.frame.size.width - 44.0f, 0.0f, 30.0f, 30.0f) andStyle:[QSButtonStyleModel createAddFoodStoreLocalButtonStyle] andCallBack:^(UIButton *button) {
                
            }];
            textField.rightViewMode = UITextFieldViewModeAlways;
            [textField setRightView:(UIView *)localButton];
        }
        
        //如果是电话号码输入框，则弹出数字键盘
        if (i == 2) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        //验证码输入框，添加验证码label
        if (i == 4) {
            UIView *verCodeView = [UIView verificationCodeView:CGRectMake(0.0f, 0.0f, 120.0f, 44.0f) andCallBack:^(NSString *verCode) {
                _verticalCode = [verCode copy];
            }];
            
            textField.rightViewMode = UITextFieldViewModeAlways;
            [textField setRightView:verCodeView];
            
            //设置键盘
            textField.keyboardType = UIKeyboardTypeASCIICapable;
        }
        
        //绑定tag
        textField.tag = TAG_INPUTFIELD_ROOT + i;
        
        [view addSubview:textField];
    }
    
    //提交按钮
    UIButton *signButton = [UIButton createBlockActionButton:CGRectMake(10.0f, view.frame.size.height-49.0f, view.frame.size.width-20.0f, 44.0f) andStyle:[QSButtonStyleModel createAddFoodStoreSignUpButtonStyle] andCallBack:^(UIButton *button) {
        
        //校验数据
        [self checkInputInfo:view andCallBack:^(NSArray *resultArray) {
            if ([resultArray count] == 5) {
                [[QSAPIClientBase sharedClient] forAGroupWithCondition:resultArray andSuccessCallBack:^(BOOL forResult) {
                    if (forResult) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"求探店成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        [alert show];
                        
                        //显示一秒后返回
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alert dismissWithClickedButtonIndex:0 animated:YES];
                            //推回活动主页面
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                } andFailCallBack:^(NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"求探店失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                    NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
                }];
            }
        }];
    }];
    [view addSubview:signButton];
}

//*******************************
//             导航栏事件
//*******************************
#pragma mark - 导航栏事件
- (void)navigationBarAction:(NAVIGATION_BAR_NORMAL_ACTION_TYPE)actionType
{
    switch (actionType) {
        case TURN_BACK_NBNAT:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

//*******************************
//             UITextField回收键盘
//*******************************
#pragma mark - UITextField回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = objc_getAssociatedObject(self, &InputFieldRootViewKey);
    for (UITextField *obj in [view subviews]) {
        [obj resignFirstResponder];
    }
}

//*******************************
//             弹出键盘时输入框滑动
//*******************************
#pragma mark - 弹出键盘时输入框滑动
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //大于103开始滑动
    if (textField.frame.origin.y > 103.0f) {
        UIView *rootView = objc_getAssociatedObject(self, &InputFieldRootViewKey);
        [UIView animateWithDuration:0.25 animations:^{
            rootView.frame = CGRectMake(rootView.frame.origin.x, 30.0f, rootView.frame.size.width, rootView.frame.size.height);
        }];
    }
}

//回收键盘时输入框恢复
- (void)recoverInputView:(NSNotification *)notification
{
#if 0
    NSTimeInterval anTime;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
#endif
    UIView *rootView = objc_getAssociatedObject(self, &InputFieldRootViewKey);
    [UIView animateWithDuration:0.25 animations:^{
        rootView.frame = CGRectMake(rootView.frame.origin.x, 110.0f, rootView.frame.size.width, rootView.frame.size.height);
    }];
}

//*******************************
//             结束输入时还原状态
//*******************************
#pragma mark - 结束输入时还原状态
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] > 0) {
        textField.layer.borderWidth = 0.0f;
    }
}

//*******************************
//             校验输入框信息
//*******************************
#pragma mark - 校验输入框信息
- (void)checkInputInfo:(UIView *)view andCallBack:(void(^)(NSArray *resultArray))callBack
{
    //取得输入内容
    NSMutableArray *inputInfoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        UITextField *tempField = (UITextField *)[view viewWithTag:TAG_INPUTFIELD_ROOT+i];
        if ([tempField.text length] > 0) {
            //如果是电话号码输入框需要判断位数是否为11位
            if (i == 2) {
                if ([tempField.text length] != 11) {
                    [self setTextFieldWrongStyle:tempField];
                    return;
                }
            }
            
            //判断是否验证码输入
            if (i == 4) {
                if ([tempField.text compare:_verticalCode options:NSCaseInsensitiveSearch] != NSOrderedSame) {
                    [self setTextFieldWrongStyle:tempField];
                    return;
                }
            }
            
            //普通输入框
            [inputInfoArray addObject:tempField.text];
        } else {
            [self setTextFieldWrongStyle:tempField];
            return;
        }
    }
    
    //取完输入信息后，回调
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (callBack) {
            callBack(inputInfoArray);
        }
    });
}

#pragma mark - 将输入框显示为有误状态
- (void)setTextFieldWrongStyle:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor redColor] CGColor];
    textField.layer.borderWidth = 1.0f;
    [textField becomeFirstResponder];
}

@end
