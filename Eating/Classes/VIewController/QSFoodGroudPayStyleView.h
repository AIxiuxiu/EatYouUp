//
//  QSFoodGroudPayStyleView.h
//  Eating
//
//  Created by ysmeng on 14/12/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSFoodGroudPayStyleView : UIView

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
- (instancetype)initWithCallBack:(void(^)(int index))callBack;

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
- (instancetype)initWithFrame:(CGRect)frame andCurrentIndex:(int)index andCallBack:(void(^)(int index))callBack;

@end
