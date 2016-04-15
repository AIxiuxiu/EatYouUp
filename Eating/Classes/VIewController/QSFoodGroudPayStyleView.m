//
//  QSFoodGroudPayStyleView.m
//  Eating
//
//  Created by ysmeng on 14/12/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodGroudPayStyleView.h"
#import "QSConfig.h"
#import "QSResetImageFrameButton.h"

@interface QSFoodGroudPayStyleView (){
    
    int _currentIndex;//!<当前处于选择状态的按钮下标

}

@property (nonatomic,copy) void(^callBack)(int index);//!<选择支付方式时回调

@end

@implementation QSFoodGroudPayStyleView

/**
 *  @author         yangshengmeng, 14-12-19 16:12:21
 *
 *  @brief          返回一个搭食团支付方式选择窗口
 *
 *  @param callBack 选择回调
 *
 *  @return         返回当前对象
 *
 *  @since          2.0
 */
- (instancetype)initWithCallBack:(void(^)(int index))callBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        ///创建UI
//        [self createFoodGroudPayStyleUI];
        
    }
    
    return self;

}

/**
 *  @author         yangshengmeng, 14-12-19 16:12:21
 *
 *  @brief          返回一个搭食团支付方式选择窗口
 *
 *  @param callBack 选择回调
 *
 *  @return         返回当前对象
 *
 *  @since          2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCurrentIndex:(int)index andCallBack:(void(^)(int index))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        ///保存选择状态的下标
        _currentIndex = (index >=0 && index < 3) ? index : 0;
        
        ///创建UI
        [self createFoodGroudPayStyleUI];
        
    }
    
    return self;

}

/**
 *  @author yangshengmeng, 14-12-19 16:12:25
 *
 *  @brief  创建支付方式UI
 *
 *  @since  2.0
 */
- (void)createFoodGroudPayStyleUI
{

    ///创建选择按钮
    UIButton *commderPayButton = [UIButton createRightTitleButton:^(UIButton *button) {
        
        ///如果本来就是选择状态，不回调
        if (button.selected) {
            return;
        }
        
        ///回调
        if (self.callBack) {
            self.callBack(0);
        }
        
    }];
    ///设置标题
    [commderPayButton setTitle:@"我请客" forState:UIControlStateNormal];
    [commderPayButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [commderPayButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    commderPayButton.translatesAutoresizingMaskIntoConstraints = NO;
    commderPayButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [commderPayButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    commderPayButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [commderPayButton addTarget:self action:@selector(foodGroudPayStyleChoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commderPayButton];
    
    UIButton *aaButton = [UIButton createRightTitleButton:^(UIButton *button) {
        
        ///如果本来就是选择状态，不回调
        if (button.selected) {
            return;
        }
        
        ///回调
        if (self.callBack) {
            self.callBack(1);
        }
        
    }];
    ///设置标题
    [aaButton setTitle:@"AA" forState:UIControlStateNormal];
    [aaButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [aaButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    aaButton.translatesAutoresizingMaskIntoConstraints = NO;
    aaButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [aaButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    aaButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [aaButton addTarget:self action:@selector(foodGroudPayStyleChoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:aaButton];
    
    UIButton *memberPayButton = [UIButton createRightTitleButton:^(UIButton *button) {
        
        ///如果本来就是选择状态，不回调
        if (button.selected) {
            return;
        }
        
        ///回调
        if (self.callBack) {
            self.callBack(2);
        }
        
    }];
    ///设置标题
    [memberPayButton setTitle:@"对方支付" forState:UIControlStateNormal];
    [memberPayButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [memberPayButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    memberPayButton.translatesAutoresizingMaskIntoConstraints = NO;
    memberPayButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    memberPayButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [memberPayButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [memberPayButton addTarget:self action:@selector(foodGroudPayStyleChoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:memberPayButton];
    
    ///设置选择状态
    NSArray *buttonArray = @[commderPayButton,aaButton,memberPayButton];
    ((UIButton *)buttonArray[_currentIndex]).selected = YES;
    
    ///结束字符串
    NSString *___hVFL_aaButton = @"H:[aaButton]";
    NSString *___vVFL_aaButton = @"V:[aaButton(20)]";
    NSString *___hVFL_commderPayButton = @"|-10-[commderPayButton]-(>=10)-[aaButton]-(>=10)-[memberPayButton]-10-|";
    
    ///添加约束
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_aaButton options:0 metrics:nil views:NSDictionaryOfVariableBindings(commderPayButton,aaButton,memberPayButton)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_aaButton options:0 metrics:nil views:NSDictionaryOfVariableBindings(aaButton)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:aaButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:aaButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_commderPayButton options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(commderPayButton,aaButton,memberPayButton)]];

}

/**
 *  @author         yangshengmeng, 14-12-19 16:12:00
 *
 *  @brief          选择支付方式时的事件
 *
 *  @param button   当前点击的按钮
 *
 *  @since          2.0
 */
- (void)foodGroudPayStyleChoiceButtonAction:(UIButton *)button
{

    if (button.selected) {
        return;
    }
    
    for (UIButton *obj in [self subviews]) {
        
        obj.selected = NO;
        
    }
    
    button.selected = YES;

}

@end
