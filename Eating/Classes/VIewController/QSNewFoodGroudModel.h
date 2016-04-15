//
//  QSNewFoodGroudModel.h
//  Eating
//
//  Created by ysmeng on 14/12/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSNewFoodGroudModel : NSObject

@property (nonatomic,copy) NSString *membersSumCount;   //!<总的参团人数
@property (nonatomic,copy) NSDate *activityTime;        //!<活动时间
@property (nonatomic,copy) NSString *activityComment;   //!<备注
@property (nonatomic,retain) NSArray *tagList;          //!<标签数组

@property (nonatomic,copy) NSString *merchantName;      //!<商户名称
@property (nonatomic,copy) NSString *merchantID;        //!<商户ID

@property (nonatomic,copy) NSString *payStyle;          //!<支付方式

@property (nonatomic,copy) NSString *addLimited;        //!<参团限制
@property (nonatomic,copy) NSString *canTakeFamilies;   //!<是否可以带家属

/**
 *  @author yangshengmeng, 14-12-21 17:12:34
 *
 *  @brief  封装搭食团参数并返回
 *
 *  @return 返回新增搭食团时的参数
 *
 *  @since  2.0
 */
- (NSDictionary *)packageNewFoodGroudParams;

@end
