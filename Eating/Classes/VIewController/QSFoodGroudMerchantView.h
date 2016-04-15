//
//  QSFoodGroudMerchantView.h
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSFoodGroudMerchantDataModel;
@interface QSFoodGroudMerchantView : UIView

/**
 *  @author         yangshengmeng, 14-12-25 11:12:00
 *
 *  @brief          创建一个商户信息的view
 *
 *  @param frame    在父视图中位置和大小
 *  @param callBack 点击商户时的回调
 *
 *  @return         返回一个商户基本信息view
 *
 *  @since          2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(NSString *merchantID,NSString *merchantName))callBack;

/**
 *  @author         yangshengmeng, 14-12-24 12:12:38
 *
 *  @brief          根据数据模型更新商户信息
 *
 *  @param model    数据模型
 *
 *  @since          2.0
 */
- (void)updateMerchantInfoView:(QSFoodGroudMerchantDataModel *)model;

@end
