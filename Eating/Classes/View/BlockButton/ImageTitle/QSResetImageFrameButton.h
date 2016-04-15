//
//  QSResetImageFrameButton.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (QSResetImageFrameButton)

/**
 *  @author         yangshengmeng, 14-12-19 12:12:58
 *
 *  @brief          创建一个图片在左侧，标题在右侧的按钮
 *
 *  @param frame    在父视图中的大小
 *  @param callBack 点击时的回调
 *
 *  @return         返回当前创建的按钮
 *
 *  @since          1.0
 */
+ (UIButton *)createImageAndTitleButton:(CGRect)frame andCallBack:(void(^)(UIButton *button))callBack;

/**
 *  @author         yangshengmeng, 14-12-19 12:12:39
 *
 *  @brief          创建一个标题在右侧的按钮，同时不设置frame
 *
 *  @param callBack 单击时的回调
 *
 *  @return         返回当前按钮对象
 *
 *  @since          2.0
 */
+ (UIButton *)createRightTitleButton:(void(^)(UIButton *button))callBack;

@end

@interface QSResetImageFrameButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(UIButton *))callBack;

@property (nonatomic,copy) void(^callBack)(UIButton *button);

@end