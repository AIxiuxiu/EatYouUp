//
//  UIView+QSGraphicView.m
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "UIView+QSGraphicView.h"
#import "QSFoodDetectiveNormalSeperateView.h"

@implementation UIView (QSGraphicView)

+ (UIView *)craphicFoodDetectiveNormalSepView:(CGRect)frame
{
    QSFoodDetectiveNormalSeperateView *view = [[QSFoodDetectiveNormalSeperateView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//生成验证码视图
+ (UIView *)verificationCodeView:(CGRect)frame andCallBack:(VERTICALCODEL_VIEW_CALLBACK_BLOCK)callBack
{
    QSVerticalCodeView *verCodeView = [[QSVerticalCodeView alloc] initWithFrame:frame];
    if (callBack) {
        verCodeView.callBack = callBack;
    }
    
    return verCodeView;
}

@end
