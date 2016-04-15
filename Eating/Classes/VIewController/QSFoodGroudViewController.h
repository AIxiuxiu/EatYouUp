//
//  QSFoodGroudViewController.h
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSCreateTabbarViewController.h"

///搭食团列表的类型：个人/普通
typedef enum
{
    
    DEFAULT_FLT = 0,        //!<默认列表
    PRIVATE_FLT,            //!<个人搭食团列表
    PRIVATE_UNCOMMMITED_FLT,//!<个人未成团的搭食团
    
    MERCHANT_ALL_FLT        //!<单个商户的搭食团列表

}FOODGROUD_LIST_TYPE;

@interface QSFoodGroudViewController : QSCreateTabbarViewController

/**
 *  @author         yangshengmeng, 14-12-21 20:12:22
 *
 *  @brief          根据传入的列表类型(个人/普通)创建列表类型
 *
 *  @param listType 列表类型：个人/默认
 *
 *  @return         返回搭食团列表
 *
 *  @since          2.0
 */
- (instancetype)initWithType:(FOODGROUD_LIST_TYPE)listType;

/**
 *  @author             yangshengmeng, 15-01-04 13:01:23
 *
 *  @brief              获取指定商户的搭食团列表
 *
 *  @param listType     列表类型
 *  @param merchantID   商户的ID
 *
 *  @return             返回当前列表
 *
 *  @since              2.0
 */
- (instancetype)initWithType:(FOODGROUD_LIST_TYPE)listType andMerchantID:(NSString *)merchantID;

@end
