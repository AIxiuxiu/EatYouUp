//
//  QSSelectedChangeBgColorButton.h
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSButtonStyleModel.h"

//按钮回调block
typedef void (^BLOCK_BUTTON_CALLBACK)(UIButton *button);

@interface UIButton (QSSelectedChangeBgColorButton)

+ (UIButton *)createSelectedChangeBgColorButton:(CGRect)frame andStyle:(QSButtonStyleModel *)buttonStyle andCallBack:(BLOCK_BUTTON_CALLBACK)callBack;

@end

@interface QSSelectedChangeBgColorButton : UIButton

//保存普通状态和选择状态的背景颜色
@property (nonatomic,copy) UIColor *normalBGColor;
@property (nonatomic,copy) UIColor *highlightedBGColor;

- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSButtonStyleModel *)buttonStyle;

@property (nonatomic,copy) BLOCK_BUTTON_CALLBACK callBack;

@end
