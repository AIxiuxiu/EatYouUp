//
//  QSPrepaidCardNavigationBar.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//回调类型
typedef enum{
    DEFAULT_NCT = 0,
    TURNBACK_NCT,
    LEFT_VIEW_NCT,
    MIDDLEVIEW_NCT,
    RIGHTVIEW_NCT
}NAVIGATIONBAR_CALLBACK_TYPE;

@interface QSPrepaidCardNavigationBar : UIView

//回调block
@property (nonatomic,copy) void(^callBack)(NAVIGATIONBAR_CALLBACK_TYPE actionType);

//回调初始化
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(NAVIGATIONBAR_CALLBACK_TYPE actionType))callBack;

//导航栏各种视图添加
- (void)setNavigationBarTurnBackButton;

- (void)setNavigationBarLeftView:(UIView *)view;

- (void)setNavigationBarMiddleTitle:(NSString *)title;

- (void)setNavigationBarMiddleView:(UIView *)view;

- (void)setNavigationBarRightView:(UIView *)view;

@end
