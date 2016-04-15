//
//  QSYFoodGroudLimitedView.m
//  Eating
//
//  Created by ysmeng on 14/12/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSYFoodGroudLimitedView.h"
#import "QSResetImageFrameButton.h"
#import "QSConfig.h"

@interface QSYFoodGroudLimitedView (){

    int _selectedIndex;//!<选择状态的下标

}

@property (nonatomic,copy) void(^callBack)(int index);//!<搭食团限制回调

@end

@implementation QSYFoodGroudLimitedView

/**
 *  @author         yangshengmeng, 14-12-19 12:12:35
 *
 *  @brief          创建一个搭食团限制条件选择视图
 *
 *  @param callBack 当前选择的回调
 *
 *  @return         返回当前对象
 *
 *  @since          2.0
 */
- (instancetype)initWithCallBack:(int)defaultSelected andCallBack:(void(^)(int index))callBack
{

    if (self = [super init]) {
        
        ///保存选择状态的下标
        _selectedIndex = (defaultSelected >= 0 && defaultSelected <= 3) ? defaultSelected : 0;
        
        if (callBack) {
            self.callBack = callBack;
        }
        
        ///创建UI
        [self createFoodGroudLimitedChoiceUI];
        
    }
    
    return self;

}

/**
 *  @author         yangshengmeng, 14-12-19 12:12:35
 *
 *  @brief          按给定的坐标和大小创建一个搭食团限制条件选择视图，同时给定一个默认的选择下标按钮
 *
 *  @param callBack 当前选择的回调
 *
 *  @return         返回当前对象
 *
 *  @since          2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCurrentSelectedIndex:(int)defaultSelected andCallBack:(void(^)(int index))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        if (callBack) {
            self.callBack = callBack;
        }
        
        ///保存选择状态的下标
        _selectedIndex = (defaultSelected >= 0 && defaultSelected <= 3) ? defaultSelected : 0;
        
        ///创建UI
        [self createFoodGroudLimitedChoiceUI];
        
    }
    
    return self;

}

/**
 *  @author yangshengmeng, 14-12-19 17:12:09
 *
 *  @brief  创建选择的UI
 *
 *  @since  2.0
 */
- (void)createFoodGroudLimitedChoiceUI
{
    
    ///创建选择按钮
    UIButton *unLimitedButton = [UIButton createRightTitleButton:^(UIButton *button) {
        
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
    [unLimitedButton setTitle:@"不限" forState:UIControlStateNormal];
    [unLimitedButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [unLimitedButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    unLimitedButton.translatesAutoresizingMaskIntoConstraints = NO;
    unLimitedButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [unLimitedButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    unLimitedButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [unLimitedButton addTarget:self action:@selector(foodGroudLimitedChoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:unLimitedButton];
    
    UIButton *ladiesButton = [UIButton createRightTitleButton:^(UIButton *button) {
        
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
    [ladiesButton setTitle:@"限女" forState:UIControlStateNormal];
    [ladiesButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [ladiesButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    ladiesButton.translatesAutoresizingMaskIntoConstraints = NO;
    ladiesButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [ladiesButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    ladiesButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [ladiesButton addTarget:self action:@selector(foodGroudLimitedChoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ladiesButton];
    
    UIButton *manButton = [UIButton createRightTitleButton:^(UIButton *button) {
        
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
    [manButton setTitle:@"限男" forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    manButton.translatesAutoresizingMaskIntoConstraints = NO;
    manButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    manButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [manButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [manButton addTarget:self action:@selector(foodGroudLimitedChoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:manButton];
    
    ///设置选择状态
    NSArray *array = @[unLimitedButton,ladiesButton,manButton];
    ((UIButton *)array[_selectedIndex]).selected = YES;
    
    ///结束字符串
    NSString *___hVFL_allButton = @"H:|-10-[unLimitedButton]-(>=10)-[ladiesButton]-(>=10)-[manButton]-10-|";
    NSString *___vVFL_unLimitedButton = @"V:[unLimitedButton(20)]";
    
    ///添加约束
    [self addConstraint:[NSLayoutConstraint constraintWithItem:unLimitedButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_allButton options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(unLimitedButton,ladiesButton,manButton)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_unLimitedButton options:0 metrics:nil views:NSDictionaryOfVariableBindings(unLimitedButton)]];

}

/**
 *  @author         yangshengmeng, 14-12-19 15:12:11
 *
 *  @brief          按钮点击事件
 *
 *  @param button   当前点击的按钮
 *
 *  @since          2.0
 */
- (void)foodGroudLimitedChoiceButtonAction:(UIButton *)button
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
