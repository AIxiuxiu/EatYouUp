//
//  QSPayFailHUD.m
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPayFailHUD.h"
#import "QSConfig.h"
#import "QSBlockActionButton.h"

@implementation QSPayFailHUD

/**
 *  在目标视图加载显示支付失败的询问页
 *
 *  @param target       目标视图
 *  @param callBack     回调block：点击支付失败视图上的按钮，回调对应事件
 *  @param QSPAYFAILHUD_CALLBACK_TYPE : FAIL_QSPCT-支付失败 SUCCESS_QSPCT-支付成功
 *  @return 返回当前显示对象
 */
+ (instancetype)showPaidFailHUD:(UIView *)target andCallBack:(void (^)(QSPAYFAILHUD_CALLBACK_TYPE))callBack
{
    QSPayFailHUD *payHUD = [[QSPayFailHUD alloc] initWithFrame:CGRectMake(0.0f, 0.0f, target.frame.size.width, target.frame.size.height) andCallBack:callBack];
    [target addSubview:payHUD];
    
    //动画显示
    [UIView animateWithDuration:0.3 animations:^{
        payHUD.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
    return payHUD;
}

/**
 *  支付失败的询问页初始化方法
 *
 *  @param frame        相对于父视图的位置/大小
 *  @param callBack     回调block：点击支付失败视图上的按钮，回调对应事件
 *  @param QSPAYFAILHUD_CALLBACK_TYPE : FAIL_QSPCT-支付失败 SUCCESS_QSPCT-支付成功
 *  @return 返回当前显示对象
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(QSPAYFAILHUD_CALLBACK_TYPE))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        //创建UI
        [self createAlixPayFailHUDUI];
        
        //添加点击事件，当点击非功能区域时，自动回收
        
    }
    
    return self;
}

//UI搭建
- (void)createAlixPayFailHUDUI
{
    //背景
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    self.alpha = 0.0f;
    
    //底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(40.0f, 160.0f, self.frame.size.width-80.0f, 120.0f)];
    rootView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rootView];
    
    //支付成功，或者失败
    UIButton *paySuccess = [UIButton createBlockActionButton:CGRectMake(15.0f, 15.0f, rootView.frame.size.width-30.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        //回调：支付成功
        if (self.callBack) {
            self.callBack(SUCCESS_QSPCT);
        }
        
    }];
    [paySuccess addTarget:self action:@selector(payHUDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [paySuccess setTitle:@"支付成功" forState:UIControlStateNormal];
    [paySuccess setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
    [paySuccess setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rootView addSubview:paySuccess];
    
    //分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, rootView.frame.size.height/2.0f-0.25f, rootView.frame.size.width-20.0f, 0.5f)];
    sepLabel.backgroundColor = kBaseLightGrayColor;
    sepLabel.alpha = 0.5f;
    [rootView addSubview:sepLabel];
    
    //支付失败
    UIButton *payFail = [UIButton createBlockActionButton:CGRectMake(15.0f, rootView.frame.size.height-15.0f-44.0f, rootView.frame.size.width-30.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        //回调：支付成功
        if (self.callBack) {
            self.callBack(FAIL_QSPCT);
        }
        
    }];
    [payFail setTitle:@"支付失败" forState:UIControlStateNormal];
    [payFail setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [payFail setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
    [payFail addTarget:self action:@selector(payHUDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:payFail];
}

#pragma mark - 回调按钮事件
- (void)payHUDButtonAction:(UIButton *)button
{
    [self hiddenPayHUD];
}

#pragma mark - 移除动画
- (void)hiddenPayHUD
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
