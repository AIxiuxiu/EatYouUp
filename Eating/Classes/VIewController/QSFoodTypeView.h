//
//  QSFoodTypeView.h
//  Eating
//
//  Created by ysmeng on 14/11/29.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSFoodTypeView : UIView

/**
 *  @author         yangshengmeng, 14-12-17 23:12:18
 *
 *  @brief          创建一个菜品选择视图，加载到目标视图之上
 *
 *  @param target   目标视图
 *  @param callBack 回调
 *
 *  @return         返回当前视图
 *
 *  @since          2.0
 */
+ (instancetype)showFoodTypeView:(UIView *)target andCallBack:(void(^)(NSString *type,int index))callBack;

/**
 *  @author             yangshengmeng, 14-12-17 23:12:44
 *
 *  @brief              返回一个菜品选择视图，视图的菜品项y坐标从0开始
 *
 *  @param target       目标视图
 *  @param aboveView    是否需要在某个视图之上
 *  @param callBack     回调
 *
 *  @return             返回当前视图
 *
 *  @since              2.0
 */
+ (instancetype)showFoodTypeView:(UIView *)target andAboveView:(UIView *)aboveView andCallBack:(void (^)(NSString *type,int index))callBack;

/**
 *  @author             yangshengmeng, 14-12-17 22:12:22
 *
 *  @brief              创建一个默认的菜品选择窗口
 *
 *  @param target       目标视图
 *  @param ypoint       菜品选择的开始坐标
 *  @param aboveView    是否需要在某个view之上
 *  @param callBack     回调
 *
 *  @return             返回当前视图
 *
 *  @since              2.0
 */
+ (instancetype)showFoodTypeView:(UIView *)target andYPoint:(CGFloat)ypoint andAboveView:(UIView *)aboveView andCallBack:(void (^)(NSString *type,int index))callBack;

/**
 *  @author             yangshengmeng, 14-12-17 22:12:23
 *
 *  @brief              显示一个当前选中第一项的菜品选择窗口
 *
 *  @param target       目标视图
 *  @param array        数据源
 *  @param ypoint       菜品选择开始坐标
 *  @param aboveView    是否需要在某个view之上
 *  @param callBack     回调
 *
 *  @return             返回当前对象
 *
 *  @since              2.0
 */
+ (instancetype)showFoodTypeView:(UIView *)target andDataSource:(NSArray *)array andYPoint:(CGFloat)ypoint andAboveView:(UIView *)aboveView andCallBack:(void (^)(NSString *type,int index))callBack;

/**
 *  @author yangshengmeng, 14-12-11 10:12:18
 *
 *  @brief               根据给定的数据源生成对应的选择视图，并显示在对应视图之上
 *
 *  @param target        目标视图：将选择窗口加载在的目标视图
 *  @param array         选择视图的数据源
 *  @param ypoint        数据源的起始坐标
 *  @param aboveView     选择视图的底下视图：需要遮盖的视图
 *  @param currentIndext 当前处于选择状态的下标
 *  @param callBack      回调
 *
 *  @return              返回一个选择视图
 *
 *  @since               2.0
 */
+ (instancetype)showFoodTypeView:(UIView *)target andDataSource:(NSArray *)array andYPoint:(CGFloat)ypoint andAboveView:(UIView *)aboveView andCurrentIndex:(int)currentIndext andCallBack:(void (^)(NSString *type,int index))callBack;

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(NSString *type,int index))callBack;

/**
 *  @author yangshengmeng, 14-12-11 12:12:40
 *
 *  @brief  提供给外部访问的隐藏选择窗口控件
 *
 *  @since  2.0
 */
- (void)hiddenFoodTypeView;

/**
 *  回调，告知当前选择的内容
 */
@property (nonatomic,copy) void(^callBack)(NSString *type,int index);

@end
