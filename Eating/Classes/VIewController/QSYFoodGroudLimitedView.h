//
//  QSYFoodGroudLimitedView.h
//  Eating
//
//  Created by ysmeng on 14/12/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYFoodGroudLimitedView : UIView

/**
 *  @author         yangshengmeng, 14-12-19 12:12:35
 *
 *  @brief          创建一个搭食团限制条件选择视图，同时给定一个默认的选择下标按钮
 *
 *  @param callBack 当前选择的回调
 *
 *  @return         返回当前对象
 *
 *  @since          2.0
 */
- (instancetype)initWithCallBack:(int)defaultSelected andCallBack:(void(^)(int index))callBack;

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
- (instancetype)initWithFrame:(CGRect)frame andCurrentSelectedIndex:(int)defaultSelected andCallBack:(void(^)(int index))callBack;

@end
