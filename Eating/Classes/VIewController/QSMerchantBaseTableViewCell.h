//
//  QSMerchantBaseTableViewCell.h
//  Eating
//
//  Created by ysmeng on 14/12/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSMerchantDetailData;
@interface QSMerchantBaseTableViewCell : UITableViewCell

/**
 *  @author         yangshengmeng, 14-12-20 17:12:43
 *
 *  @brief          根据给定的商户信息模型，更新UI
 *
 *  @param model    商户信息模型
 *
 *  @since          2.0
 */
- (void)updateMerchantBaseTableViewWithModel:(QSMerchantDetailData *)model;

@end
