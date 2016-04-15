//
//  QSAPIClientBase+FoodGroud.h
//  Eating
//
//  Created by ysmeng on 14/12/18.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+FoodGroud.h"

@interface QSAPIClientBase (FoodGroud)

/**
 *  @author yangshengmeng, 14-12-18 12:12:03
 *
 *  @brief          请求搭吃团列表
 *
 *  @param page     页码
 *  @param useID    用户ID，不传则表示请求的是普通搭食团列表
 *  @param callBack 回调
 *
 *  @since          2.0
 */
- (void)getFoodGroudListWithPage:(int)page andUserID:(NSString *)useID andParams:(NSDictionary *)searchDict andCallBack:(void(^)(BOOL resultFlag,NSArray *foodGroudList,NSString *errorInfo,NSString *errorcode))callBack;

/**
 *  @author         yangshengmeng, 15-12-29 10:12:17
 *
 *  @brief          请给定状态的搭食团列表
 *
 *  @param page     请求第几页
 *  @param useID    用户ID
 *  @param status   搭食团的状态：一般是请求未成团状态
 *  @param callBack 请求成功/失败时的回调
 *
 *  @since          2.0
 */
- (void)getFoodGroudListWithPage:(int)page andUserID:(NSString *)useID andParams:(NSDictionary *)searchDict andStatus:(NSString *)status andCallBack:(void(^)(BOOL resultFlag,NSArray *foodGroudList,NSString *errorInfo,NSString *errorcode))callBack;

/**
 *  @author         yangshengmeng, 14-12-24 15:12:04
 *
 *  @brief          请求搭食团详情信息
 *
 *  @param userID   团长ID
 *  @param teamID   搭食团ID
 *  @param callBack 请求成功时的回调
 *
 *  @since          2.0
 */
- (void)getFoodGroudDetailInfo:(NSString *)userID andTeamID:(NSString *)teamID andCallBack:(void(^)(BOOL resultFlag,QSFoodGroudDetailDataModel *detailModel,NSString *errorInfo,NSString *errorcode))callBack;

/**
 *  @author         yangshengmeng, 14-12-25 11:12:37
 *
 *  @brief          参加一个团
 *
 *  @param teamID   团ID
 *  @param callBack 参团成功失败的回调
 *
 *  @since          2.0
 */
- (void)joinTeamWithID:(NSString *)teamID andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

/**
 *  @author         yangshengmeng, 14-12-25 11:12:37
 *
 *  @brief          退出一个团
 *
 *  @param teamID   团ID
 *  @param callBack 退团成功失败的回调
 *
 *  @since          2.0
 */
- (void)outTeamWithID:(NSString *)teamID andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

/**
 *  @author         yangshengmeng, 14-12-25 19:12:48
 *
 *  @brief          点击成团
 *
 *  @param ibookID  预约订单的ID
 *  @param teamID   团ID
 *  @param callBack 成团的回调
 *
 *  @since          2.0
 */
- (void)commitTeamWithID:(NSString *)ibookID andTeamID:(NSString *)teamID andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

/**
 *  @author             yangshengmeng, 14-12-26 12:12:47
 *
 *  @brief              请求搭食团聊天信息列表
 *
 *  @param paramsDict   请求参数：页码，每页数量
 *  @param callBack     请求成功后的回调
 *
 *  @since              2.0
 */
- (void)getTalkMessageList:(NSDictionary *)paramsDict andCallBack:(void(^)(BOOL flag,NSArray *msgList,NSString *errorInfo,NSString *errorCode))callBack;

/**
 *  @author             yangshengmeng, 14-12-26 14:12:59
 *
 *  @brief              搭食团：团聊时的消息发送
 *
 *  @param paramsDict   发送的消息及团ID
 *  @param callBack     发送成功后的回调
 *
 *  @since              2.0
 */
- (void)sendFoodGroudTalkMessage:(NSDictionary *)paramsDict andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

@end
