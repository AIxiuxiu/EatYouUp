//
//  QSJoinActivityViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSJoinActivityViewController.h"
#import "QSBlockActionButton.h"
#import "UIView+QSGraphicView.h"
#import "QSAPIClientBase+JoinActivity.h"
#import "QSMyDetectiveViewController.h"

#import <objc/runtime.h>

//输入框tag
#define TAG_INPUTFIELD_ROOT 200

@interface QSJoinActivityViewController () <UITextFieldDelegate>{
    NSString *_verticalCode;//验证码
    NSString *_activityID;//活动ID
}

@end

//关联
static char InputFieldRootViewKey;
@implementation QSJoinActivityViewController

//创建导航栏
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setMiddleTitle:@"参加任务"];
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
    NSArray *placeHoldArray = @[@"真实性名",@"电话号码",@"邮箱地址",@"QQ/微信",@"验证码"];
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
        
        //如果是输入电话号码，键盘为数字键盘
        if (i == 1) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        //如果是邮箱输入框，键盘为邮箱键盘
        if (i == 2) {
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            //取消首字母大写
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        }
        
        //如果是QQ输入框，键盘为asc键盘
        if (i == 3) {
            //设置键盘
            textField.keyboardType = UIKeyboardTypeASCIICapable;
        }
        
        //验证码输入框，添加验证码label
        if (i == 4) {
            UIView *verCodeView = [UIView verificationCodeView:CGRectMake(0.0f, 0.0f, 120.0f, 44.0f) andCallBack:^(NSString *verCode) {
                if (verCode) {
                    _verticalCode = [verCode copy];
                }
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
    UIButton *signButton = [UIButton createBlockActionButton:CGRectMake(10.0f, view.frame.size.height-49.0f, view.frame.size.width-20.0f, 44.0f) andStyle:[QSButtonStyleModel createJoinFreeActivityButtonStyle] andCallBack:^(UIButton *button) {
        
        //校验数据
        [self checkInputInfo:view andCallBack:^(NSArray *resultArray) {
#if 1
            if ([resultArray count] == 5) {
                //重新封装数组
                NSMutableArray *requestArray = [[NSMutableArray alloc] initWithArray:resultArray];
                [requestArray removeLastObject];
                [requestArray addObject:_activityID];
                
                [[QSAPIClientBase sharedClient] joinActivityWithCondition:requestArray andSuccessCallBack:^(BOOL forResult,NSString *info) {
                    if (forResult) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"加入活动成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        [alert show];
                        
                        //显示一秒后返回
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alert dismissWithClickedButtonIndex:0 animated:YES];
                            //推回活动主页面
                            QSMyDetectiveViewController *src = [[QSMyDetectiveViewController alloc] init];
                            [src setValue:@"jointActivity" forKey:@"turnBackInfo"];
                        });
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        [alert show];
                        
                        //显示一秒后返回
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alert dismissWithClickedButtonIndex:0 animated:YES];
                        });
                    }
                    
                } andFailCallBack:^(NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"加入活动失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                    NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
                }];
            }
#endif
        }];
    }];
    [view addSubview:signButton];
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
            if (i == 1) {
                BOOL mobilCheck = [self isValidateMobile:tempField.text];
                if (!mobilCheck) {
                    [self setTextFieldWrongStyle:tempField];
                    return;
                }
            }
            
            //如果邮箱，判断是否合法
            if (i == 2) {
                BOOL emailCheck = [self isValidateEmail:tempField.text];
                if (!emailCheck) {
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

/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - 将输入框显示为有误状态
- (void)setTextFieldWrongStyle:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor redColor] CGColor];
    textField.layer.borderWidth = 1.0f;
    [textField becomeFirstResponder];
}

@end
