//
//  QSPrepaidCardNavigationBar.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidCardNavigationBar.h"
#import "QSConfig.h"
#import "QSBlockActionButton.h"

#import <objc/runtime.h>

//自定义坐标
#define LEFTVIEW_FRAME CGRectMake(10.0f, 27.0f, 30.0f, 30.0f)
#define MIDDLE_FRAME CGRectMake(50.0f, 27.0f, DeviceWidth-100.0f, 30.0f)
#define RIGHTVIEW_FRAME CGRectMake(DeviceWidth-40.0f, 27.0f, 30.0f, 30.0f)
#define CENTOR_MIDDLE_POINT CGPointMake(DeviceWidth/2.0f,42.0f)

//关联
static char MiddleViewTouchEventKey;
@implementation QSPrepaidCardNavigationBar

//*******************************
//             初始化
//*******************************
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(NAVIGATIONBAR_CALLBACK_TYPE actionType))callBack
{
    if (self = [super initWithFrame:frame]) {
        //设置背景颜色
        self.backgroundColor = kBaseOrangeColor;
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
    }
    
    return self;
}

//*******************************
//             设置导航栏不同的UI
//*******************************
#pragma mark - 设置导航栏不同的UI
- (void)setNavigationBarTurnBackButton
{
    UIButton *turnBack = [UIButton createBlockActionButton:LEFTVIEW_FRAME andStyle:nil andCallBack:^(UIButton *button) {
        if (self.callBack) {
            self.callBack(TURNBACK_NCT);
        }
    }];
    [turnBack setImage:[UIImage imageNamed:@"prepaidcard_turnback_normal"] forState:UIControlStateNormal];
    [turnBack setImage:[UIImage imageNamed:@"prepaidcard_turnback_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:turnBack];
}

- (void)setNavigationBarLeftView:(UIView *)view
{
    
    
    
}

- (void)setNavigationBarMiddleTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:MIDDLE_FRAME];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleLabel];
}

- (void)setNavigationBarMiddleView:(UIView *)view
{
    view.center = CENTOR_MIDDLE_POINT;
    [self addSubview:view];
    objc_setAssociatedObject(self, &MiddleViewTouchEventKey, view, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setNavigationBarRightView:(UIView *)view
{
    view.frame = RIGHTVIEW_FRAME;
    [self addSubview:view];
}

#pragma mark - 触摸事件
#if 0
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = objc_getAssociatedObject(self, &MiddleViewTouchEventKey);
    if (view) {
        
        [view touchesBegan:touches withEvent:event];
        
    }
}
#endif

@end
