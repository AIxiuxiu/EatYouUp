//
//  QSYFoodDiscountFoodImageTableViewCell.h
//  Eating
//
//  Created by System Administrator on 12/27/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSYFoodOfferFoodDiscountDataModel;
@interface QSYFoodDiscountFoodImageTableViewCell : UITableViewCell

/**
 *  @author             wangshupeng, 14-12-27 10:12:33
 *
 *  @brief              根据给定的数据模型更新每个菜品的信息
 *
 *  @param imageModel   菜品优惠数据模型
 *
 *  @since              2.0
 */
- (void)updateFoodImageInfoWithModel:(QSYFoodOfferFoodDiscountDataModel *)imageModel  andDiscount:(NSString *)discount;

@end
