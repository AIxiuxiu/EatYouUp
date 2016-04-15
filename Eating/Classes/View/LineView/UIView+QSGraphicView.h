//
//  UIView+QSGraphicView.h
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSVerticalCodeView.h"

@interface UIView (QSGraphicView)

//生成推荐分享中的分隔线
+ (UIView *)craphicFoodDetectiveNormalSepView:(CGRect)frame;

//生成验证码视图
+ (UIView *)verificationCodeView:(CGRect)frame andCallBack:(VERTICALCODEL_VIEW_CALLBACK_BLOCK)callBack;

@end
