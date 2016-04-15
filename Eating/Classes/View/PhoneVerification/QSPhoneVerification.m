//
//  QSPhoneVerification.m
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPhoneVerification.h"
#import "QSConfig.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"

#import <objc/runtime.h>

//关联手机输入框
static char PhoneInputFieldKey;
@interface QSPhoneVerification (){
    int _timeInterval;//记录
}

@property (nonatomic,strong) UILabel *remarkCount;//显示当前读秒

@end

@implementation QSPhoneVerification

//**************************************
//             初始化/UI搭建
//**************************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame andPhoneField:(UITextField *)phoneField andCallBack:(void(^)(NSString *verCode))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        //创建UI
        [self createPhoneVerificationUI];
        
        //背景
        self.backgroundColor = kBaseLightGrayColor;
        
        //添加点击事件
        [self addSingleTapGesture];
        
        //初始化记录
        _timeInterval = 0;
        
        //关联手机输入框
        objc_setAssociatedObject(self, &PhoneInputFieldKey, phoneField, OBJC_ASSOCIATION_ASSIGN);
        
    }
    
    return self;
}

//创建UI
- (void)createPhoneVerificationUI
{
    self.remarkCount = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    self.remarkCount.text = @"获取验证码";
    self.remarkCount.textColor = kBaseGrayColor;
    self.remarkCount.textAlignment = NSTextAlignmentCenter;
    self.remarkCount.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.remarkCount];
}

//**************************************
//             点击后再次发送验证码
//**************************************
#pragma mark - 点击后再次发送验证码
- (void)addSingleTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendPhoneVerification:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)sendPhoneVerification:(UITapGestureRecognizer *)tap
{
    //判断是否可以发送：定时器还在开启状态，则不可以发送
    if (_timeInterval > 0) {
        return;
    }
    
    //判断网络是否可用
    
    //获取电话号码
    NSString *phoneNumber = [self getPhoneNumber];
    if (nil == phoneNumber) {
        [self resetPhoneNumberViewWidth:90.0f];
        self.remarkCount.text = @"手机号码无效";
        return;
    }
    
    //获取手机验证码
    [self sendPhoneVerificationCode:phoneNumber];
    
}

#pragma mark - 重置view宽
- (void)resetPhoneNumberViewWidth:(CGFloat)width
{
    self.remarkCount.frame = CGRectMake(0.0f, 0.0f, width, self.remarkCount.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

#pragma mark - 获取手机验证码
- (void)sendPhoneVerificationCode:(NSString *)phoneNum
{
    //获取手机验证码
    [[QSAPIClientBase sharedClient] getVerCode:phoneNum merchantId:nil success:^(QSAPIModelString *response) {
        
        //回调
        if (self.callBack) {
            self.callBack(response.msg);
        }
        
        _timeInterval = 61;
        
        //开启定时器
        //每秒更新读数
        [self resetPhoneNumberViewWidth:60.0f];
        self.remarkCount.text = @"61秒";
        NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshCountDownUI:) userInfo:nil repeats:60];
        [tempTimer fire];
        
    } fail:^(NSError *error) {
        [self resetPhoneNumberViewWidth:105.0f];
        self.remarkCount.text = @"获取验证码失败";
    }];
}

#pragma mark - 刷新记数显示UI
- (void)refreshCountDownUI:(NSTimer *)timer
{
    _timeInterval--;
    self.remarkCount.text = [NSString stringWithFormat:@"%d秒",_timeInterval];
    if (_timeInterval == 0) {
        [self resetPhoneNumberViewWidth:105.0f];
        self.remarkCount.text = @"重新获取验证码";
        [timer invalidate];
    }
}

#pragma mark - 获取手机号码
- (NSString *)getPhoneNumber
{
    UITextField *textField =  objc_getAssociatedObject(self, &PhoneInputFieldKey);
    NSString *phoneNumber = textField.text;
    
    //如果手机号不等于11位
    if (![self isValidateMobile:phoneNumber]) {
        textField.layer.borderColor = [[UIColor redColor] CGColor];
        textField.layer.borderWidth = 1.0f;
        
        return nil;
    }
    
    textField.layer.borderWidth = 0.0f;
    
    return phoneNumber;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
