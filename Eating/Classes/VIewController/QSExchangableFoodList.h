//
//  QSExchangableFoodList.h
//  Eating
//
//  Created by ysmeng on 14/12/8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSExchangableFoodList : UIView

/**
 *  按给定的数据源创建可兑菜品列表视图
 *
 *  @param dataSource       可兑换菜品数组
 *  @param frame            在父视图中的坐标
 *  @param return           返回菜品列表视图
 */
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)dataSource;

/**
 *  刷新可兑换菜品列表
 *
 *  @param foodList     可兑换菜品数组
 */
- (void)updateExchangableFoodList:(NSArray *)foodList;

@end
