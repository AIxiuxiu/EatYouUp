//
//  QSNormalNavigationBar.m
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSNormalNavigationBar.h"
#import "QSBlockActionButton.h"
#import "QSConfig.h"

#import <objc/runtime.h>

//关联key
static char ChannelButtonRootViewKey;
@implementation QSNormalNavigationBar

//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        ///设置用户交互
        self.userInteractionEnabled = YES;
        
        ///创建UI
        [self createNormalNavigationBarUI];
    }
    
    return self;
}

- (void)createNormalNavigationBarUI
{
    //背景颜色
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 64.0f)];
    headerView.backgroundColor = kBaseOrangeColor;
    [self addSubview:headerView];
    
    //底图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1.0f, 64.0f, self.frame.size.width+1.0f, 35.0f)];
    imageView.image = [UIImage imageNamed:@"foodgroud_header_default_bg"];
    [self addSubview:imageView];
}

//*******************************
//             导航栏添加左中右子视图
//*******************************
#pragma mark - 导航栏添加左中右子视图
- (void)addTurnBackButton
{
    //返回按钮风格
    QSButtonStyleModel *buttonStyle = [QSButtonStyleModel createTurnBackButtonStyle];
    
    //返回按钮:10,37,18
    UIButton *button = [UIButton createBlockActionButton:CGRectMake(10.0f, 37.0f, 18.0f, 18.0f) andStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.callBack) {
            self.callBack(TURN_BACK_NBNAT,YES);
        }
        
    }];
    [self addSubview:button];
}

- (void)setLeftView:(UIView *)view
{
    
}

- (void)setMiddleView:(UIView *)view
{
    view.frame = fNavigationBarMiddleTitleLabelFrame;
    [self addSubview:view];
}

- (void)setMiddleTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:fNavigationBarMiddleTitleLabelFrame];
    titleLabel.center = CGPointMake(self.frame.size.width/2.0f, 45.5f);
    titleLabel.text = title;
    titleLabel.font = fNavigationBarMiddleTitleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleLabel];
}

- (void)setRightView:(UIView *)view
{
//    view.frame = fNavigationBarRightViewFrame;
    CGRect frame = CGRectMake(self.frame.size.width - view.frame.size.width - 10.0f, 46.0f - view.frame.size.height/2.0f, view.frame.size.width, view.frame.size.height);
    view.frame = frame;
    [self addSubview:view];
}

//*******************************
//           添加最部功能按钮
//*******************************
#pragma mark - 添加最部功能按钮
- (void)setChannelBarWithType:(NAVIGATION_BAR_NORMAL_CHANNEL_TYPE)channelType
{
    switch (channelType) {
        case FOODGROUD_NBNCT:
            [self createFoodGroudChannelBar];
            break;
            
        default:
            break;
    }
}

//创建搭吃团的channelBar
- (void)createFoodGroudChannelBar
{
    ///获取按钮风格
    NSArray *buttStyleArray = [QSButtonStyleModel createFoodGroudButtonStyleArray];
    
    ///放置button的底view
    CGFloat gap = (self.frame.size.width - 44.0f * 4) / 5.0f;
    CGFloat widthTemp = self.frame.size.width - 2.0f * gap;
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(gap, 67.0f, widthTemp, 53.0f)];
    [self addSubview:tempView];
    objc_setAssociatedObject(self, &ChannelButtonRootViewKey, tempView, OBJC_ASSOCIATION_ASSIGN);
    
    ///循环创建按钮
    for (int i = 0;i < [buttStyleArray count];i++) {
        
        QSButtonStyleModel *obj = buttStyleArray[i];
        
        ///每个按钮的y坐标
        CGFloat ypoint = 9.0f;
        if ((i == 0) || (i == ([buttStyleArray count] - 1))) {
            ypoint = 0.0f;
        }
        UIButton *button = [UIButton createBlockActionButton:CGRectMake(i * (44.0f+gap), ypoint, 44.0f, 44.0f) andStyle:obj andCallBack:^(UIButton *button) {
            
            ///如果点击的按钮当前就是选中状态，则直接返回
            if (button.selected) {
                
                ///如果点击的是非选中状态的按钮，回调事件
                if (self.callBack) {
                    self.callBack(i + LOCATION_NBNAT,NO);
                }
                
                button.selected = NO;
                return;
            }
            
            ///如果点击的是非选中状态的按钮，回调事件
            if (self.callBack) {
                
                self.callBack(i + LOCATION_NBNAT,YES);
                
            }
            button.selected = YES;
            
        }];
        
        //添加导航栏的点击事件
        [button addTarget:self action:@selector(navigationBarChannelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //将按钮添加到视图上
        [tempView addSubview:button];
    }
}

//*******************************
//    channel按钮点击后切换选择状态
//*******************************
#pragma mark - channel按钮点击后切换选择状态
- (void)navigationBarChannelButtonAction:(UIButton *)button
{
    
    //切换选中状态
    UIView *view = objc_getAssociatedObject(self, &ChannelButtonRootViewKey);
    for (UIButton *obj in [view subviews]) {
        
        obj.selected = NO;
        if (self.callBack) {
            
            self.callBack(0,NO);
            
        }
        
    }
    
    button.selected = YES;
}

@end
