//
//  QSBlockActionButton.h
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QSButtonStyleModel.h"

//按钮回调block
typedef void (^BLOCK_BUTTON_CALLBACK)(UIButton *button);

@interface UIButton (QSBlockActionButton)

/**
 *  @author             yangshengmeng, 14-12-16 17:12:05
 *
 *  @brief              生成一个给定frame的按钮，点击时直接执行block
 *
 *  @param frame        按钮在父视图的相以位置
 *  @param buttonStyle  按钮风格
 *  @param callBack     按钮点击时的回调
 *
 *  @return             返回一个按钮
 *
 *  @since              2.0
 */
+ (UIButton *)createBlockActionButton:(CGRect)frame andStyle:(QSButtonStyleModel *)buttonStyle andCallBack:(BLOCK_BUTTON_CALLBACK)callBack;

/**
 *  @author             yangshengmeng, 14-12-16 17:12:05
 *
 *  @brief              生成一个给定frame的按钮，点击时直接执行block
 *
 *  @param buttonStyle  按钮风格
 *  @param callBack     按钮点击时的回调
 *
 *  @return             返回一个按钮
 *
 *  @since              2.0
 */
+ (instancetype)createBlockActionButton:(QSButtonStyleModel *)buttonStyle andCallBack:(BLOCK_BUTTON_CALLBACK)callBack;

@end

@interface QSBlockActionButton : UIButton

/**
 *  @author             yangshengmeng, 14-12-17 23:12:51
 *
 *  @brief              按给定的按钮风格，创建一个无frame的按钮
 *
 *  @param buttonStyle  按钮风格
 *
 *  @return             返回当前按钮
 *
 *  @since              2.0
 */
- (instancetype)initWithButtonStyle:(QSButtonStyleModel *)buttonStyle;

/**
 *  @author             yangshengmeng, 14-12-17 23:12:38
 *
 *  @brief              按给定的大小和风格创建按钮
 *
 *  @param frame        大小和位置
 *  @param buttonStyle  按钮风格
 *
 *  @return             返回当前按钮
 *
 *  @since              2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSButtonStyleModel *)buttonStyle;

@property (nonatomic,copy) BLOCK_BUTTON_CALLBACK callBack;

@end
