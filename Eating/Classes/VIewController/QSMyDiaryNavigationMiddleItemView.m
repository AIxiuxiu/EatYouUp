//
//  QSMyDiaryNavigationMiddleItemView.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyDiaryNavigationMiddleItemView.h"
#import "QSSelectedChangeBgColorButton.h"

@implementation QSMyDiaryNavigationMiddleItemView

//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame andLeftTitle:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle andCallBack:(MYDETICTIVE_NAVIGATION_MIDDLEITEM_CALLBACK)callBack
{
    if (self = [super initWithFrame:frame]) {
        
        //创建UI
        [self createMyDetectiveNavigationMiddleItemUI:leftTitle andRightTitle:rightTitle];
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //创建UI
        [self createMyDetectiveNavigationMiddleItemUI];
    }
    
    return self;
}

- (void)createMyDetectiveNavigationMiddleItemUI
{
    [self createMyDetectiveNavigationMiddleItemUI:@"我的任务" andRightTitle:@"美食日志"];
}

//创建UI
- (void)createMyDetectiveNavigationMiddleItemUI:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle
{
    //尺寸
    CGFloat width = (self.frame.size.width - 10.0f)/2.0f;
    
    //我的任务按钮:20 14
    UIButton *taskButton = [UIButton createSelectedChangeBgColorButton:CGRectMake(0.0f, (self.frame.size.height-20.0f)/2.0f, width, 20.0f) andStyle:[QSButtonStyleModel createMyDetectiveNavigationMiddleItemStyle] andCallBack:^(UIButton *button) {
        if (taskButton.selected) {
            return;
        }
        
        if (self.callBack) {
            self.callBack(MYTASK_ACTIONTYPE);
        }
    }];
    taskButton.selected = YES;
    [taskButton setTitle:leftTitle forState:UIControlStateNormal];
    [taskButton addTarget:self action:@selector(myDetectiveMiddleItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:taskButton];
    
    //我的日记按钮
    UIButton *diaryButton = [UIButton createSelectedChangeBgColorButton:CGRectMake(width+10.0f, (self.frame.size.height-20.0f)/2.0f, width, 20.0f) andStyle:[QSButtonStyleModel createMyDetectiveNavigationMiddleItemStyle] andCallBack:^(UIButton *button) {
        if (diaryButton.selected) {
            return;
        }
        
        if (self.callBack) {
            self.callBack(MYDIARY_ACTIONTYPE);
        }
    }];
    diaryButton.selected = NO;
    [diaryButton setTitle:rightTitle forState:UIControlStateNormal];
    [diaryButton addTarget:self action:@selector(myDetectiveMiddleItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:diaryButton];
}

#pragma mark - 左右按钮状态转换
- (void)myDetectiveMiddleItemAction:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    for (UIButton *obj in [self subviews]) {
        obj.selected = NO;
    }
    
    button.selected = YES;
}

#pragma mark - 接收外部消息切换选择状态
- (void)resetTopicButtonSelectedStyle
{
    for (UIButton *obj in  [self subviews]) {
        obj.selected = !obj.selected;
    }
}

@end
