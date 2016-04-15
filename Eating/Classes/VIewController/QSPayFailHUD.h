//
//  QSPayFailHUD.h
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//支付失败回调类型
typedef enum
{
    DEFAULT_QSPCT = 0,
    FAIL_QSPCT,
    SUCCESS_QSPCT
}QSPAYFAILHUD_CALLBACK_TYPE;

@interface QSPayFailHUD : UIView

/**
 *  在目标视图加载显示支付失败的询问页
 *
 *  @param target       目标视图
 *  @param callBack     回调block：点击支付失败视图上的按钮，回调对应事件
 *  @param QSPAYFAILHUD_CALLBACK_TYPE : FAIL_QSPCT-支付失败 SUCCESS_QSPCT-支付成功
 */
+ (instancetype)showPaidFailHUD:(UIView *)target andCallBack:(void(^)(QSPAYFAILHUD_CALLBACK_TYPE actionType))callBack;

/**
 *  支付失败的询问页初始化方法
 *
 *  @param frame        相对于父视图的位置/大小
 *  @param callBack     回调block：点击支付失败视图上的按钮，回调对应事件
 *  @param QSPAYFAILHUD_CALLBACK_TYPE : FAIL_QSPCT-支付失败 SUCCESS_QSPCT-支付成功
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(QSPAYFAILHUD_CALLBACK_TYPE))callBack;

@property (nonatomic,copy) void(^callBack)(QSPAYFAILHUD_CALLBACK_TYPE actionType);

@end
