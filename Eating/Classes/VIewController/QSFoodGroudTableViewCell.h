//
//  QSFoodGroudTableViewCell.h
//  Eating
//
//  Created by ysmeng on 14/12/18.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

///回调枚举：是否满团，当前的搭食团是否当前用户
typedef enum
{

    DEFAULT_CFST = 0,           //!<默认的状态
    ISCURRENT_COUNT_TEAM_CFST,  //!<当前的搭食团是当前用户创建的
    TEAM_ISFULL_CFST,           //!<目前已满员
    CURRENT_USER_JOINED_CFST    //!<当前用户已参团

}CHECK_FOODGROUD_STATUS_TYPE;

@class QSYFoodGroudDataModel;
@class QSYMyFoodGroudDataModel;
@interface QSFoodGroudTableViewCell : UITableViewCell

/**
 *  @author         yangshengmeng, 14-12-18 10:12:44
 *
 *  @brief          按给定的搭吃团数据模型更新UI
 *
 *  @param model    数据模型
 *
 *  @since          2.0
 */
- (void)updateFoodGroudUIWithModel:(QSYFoodGroudDataModel *)model;

/**
 *  @author         yangshengmeng, 14-12-21 21:12:38
 *
 *  @brief          更新个人的搭食团列表UI
 *
 *  @param model    个人的搭食团数据模型
 *
 *  @since          2.0
 */
- (void)updateMyFoodGroudUIWithModel:(QSYMyFoodGroudDataModel *)model;

///刷新每个搭食团时，判断搭食团相关状态时的回调
@property (nonatomic,copy) void(^callBack)(int flag,CHECK_FOODGROUD_STATUS_TYPE checkType,NSDictionary *params);
@property (nonatomic,copy) void(^clickMerchantLogoCallBack)(UIViewController *VC);

@end
