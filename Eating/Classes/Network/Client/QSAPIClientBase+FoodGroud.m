//
//  QSAPIClientBase+FoodGroud.m
//  Eating
//
//  Created by ysmeng on 14/12/18.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+FoodGroud.h"
#import "QSAPIModel+User.h"
#import "UserManager.h"

@implementation QSAPIClientBase (FoodGroud)

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
#pragma mark - 搭食团列表数据请求
- (void)getFoodGroudListWithPage:(int)page andUserID:(NSString *)useID andParams:(NSDictionary *)searchDict andCallBack:(void(^)(BOOL resultFlag,NSArray *foodGroudList,NSString *errorInfo,NSString *errorcode))callBack
{

    ///判断参数是否效
    if (0 >= page) {
        
        callBack(NO,nil,@"无效参数",nil);
        
        return;
        
    }
    
    ///判断是否是请求个人的列表
    if (useID) {
        
        ///进行个人的搭食团列表请求
        [self getMyFoodGroudListWithPage:page andUserID:useID andParams:searchDict andCallBack:callBack];
        
    } else {
    
        ///进行普通的列表请求
        [self getFoodGroudListWithPage:page andParams:searchDict andCallBack:callBack];
    
    }

}

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
- (void)getFoodGroudListWithPage:(int)page andUserID:(NSString *)userID andParams:(NSDictionary *)searchDict andStatus:(NSString *)status andCallBack:(void(^)(BOOL resultFlag,NSArray *foodGroudList,NSString *errorInfo,NSString *errorcode))callBack
{

    ///初步判断参数
    if ((nil == userID) || (nil == status)) {
        
        callBack(NO,nil,@"参数无效",@"ER0021");
        return;
    }
    
    NSDictionary *dict = @{@"startPage" : [NSString stringWithFormat:@"%d",page],@"pageNum" : @"10",@"user_id" : userID,@"type" : status};
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (searchDict) {
        [tempDict addEntriesFromDictionary:searchDict];
    }
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:tempDict];
    
    //请求数据
    [self.dataClient postPath:QSAPIMyFoodGroudList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已成功返回：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSMyFoodGroudListReturnData objectMapping] keyPath:nil];
        QSMyFoodGroudListReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断数据是否有效
        if (([response.foodGroupList count] > 0) && callBack) {
            
            callBack(YES,response.foodGroupList,response.errorInfo,response.errorCode);
            
        } else {
            
            callBack(NO,nil,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,nil,[NSString stringWithFormat:@"%@",error],nil);
        
    }];

}

/**
 *  @author         yangshengmeng, 14-12-21 20:12:35
 *
 *  @brief          进行个人的搭食团列表数据请求
 *
 *  @param page     页码
 *  @param useID    用户ID
 *  @param callBack 回调
 *
 *  @since          2.0
 */
- (void)getMyFoodGroudListWithPage:(int)page andUserID:(NSString *)useID andParams:(NSDictionary *)searchDict andCallBack:(void(^)(BOOL resultFlag,NSArray *foodGroudList,NSString *errorInfo,NSString *errorcode))callBack
{
    
    NSDictionary *dict = @{@"startPage" : [NSString stringWithFormat:@"%d",page],@"pageNum" : @"10",@"user_id" : useID};
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (searchDict) {
        
        [tempDict addEntriesFromDictionary:searchDict];
        
    }
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:tempDict];
    
    //请求数据
    [self.dataClient postPath:QSAPIMyFoodGroudList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已成功返回：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSMyFoodGroudListReturnData objectMapping] keyPath:nil];
        QSMyFoodGroudListReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断数据是否有效
        if (([response.foodGroupList count] > 0) && callBack) {
            
            callBack(YES,response.foodGroupList,response.errorInfo,response.errorCode);
            
        } else {
        
            callBack(NO,nil,response.errorInfo,response.errorCode);
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,nil,[NSString stringWithFormat:@"%@",error],nil);
        
    }];
    
}

/**
 *  @author         yangshengmeng, 14-12-21 20:12:33
 *
 *  @brief          进行普通的搭食团列表请求
 *
 *  @param page     页码
 *  @param callBack 回调block
 *
 *  @since          2.0
 */
- (void)getFoodGroudListWithPage:(int)page andParams:(NSDictionary *)searchDict andCallBack:(void(^)(BOOL resultFlag,NSArray *foodGroudList,NSString *errorInfo,NSString *errorcode))callBack
{
    
    //封装参数
#if 0
    ///标准请求参数
    NSDictionary *dict = @{@"startPage" : [NSString stringWithFormat:@"%d",page],@"pageNum" : @"10",@"lat" : [self getLatitudeString],@"_long" : [self getLongitudeString],@"distance" : @"100000"};
#endif

#if 1
    ///普通的列表请求
    NSDictionary *dict = @{@"startPage" : [NSString stringWithFormat:@"%d",page],@"pageNum" : @"10"};
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (searchDict) {
        
        [tempDict addEntriesFromDictionary:searchDict];
        
    }
    
#endif
    NSMutableDictionary *params = [QSAPIClientBase SetParamsWithoutUserID:tempDict];
    
    //请求数据
    [self.dataClient postPath:QSAPIFoodGroudList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodGroudListReturnData objectMapping] keyPath:nil];
        QSFoodGroudListReturnData *response = (result.dictionary)[[NSNull null]];
        
        //判断解析的数据，并回调
        if (callBack && response && response.type) {
            
            callBack(response.type,response.foodGroupList,response.errorInfo,response.errorCode);
            
        } else {
            
            ///列表获取失败
            callBack(NO,nil,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,nil,[NSString stringWithFormat:@"%@",error],@"-1");
        
    }];

}

/**
 *  @author yangshengmeng, 14-12-18 17:12:12
 *
 *  @brief  返回经度，如若当前用户坐标无效，则返回默认经度
 *
 *  @return 返回经度
 *
 *  @since  2.0
 */
- (NSString *)getLongitudeString
{

    CGFloat longitudeFloat = [UserManager sharedManager].userData.location.longitude;
    
    NSString *longitude = nil;
    
    if (longitudeFloat > 0.0f) {
        
        longitude = [NSString stringWithFormat:@"%f",longitudeFloat];
        
    } else {
    
        [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user_longitude"];
    
    }
    
    return longitude;

}

/**
 *  @author yangshengmeng, 14-12-18 17:12:12
 *
 *  @brief  返回纬度，如若当前用户坐标无效，则返回默认纬度
 *
 *  @return 返回经度
 *
 *  @since  2.0
 */
- (NSString *)getLatitudeString
{
    
    CGFloat latitudeFloat = [UserManager sharedManager].userData.location.longitude;
    
    NSString *latitude = nil;
    
    if (latitudeFloat > 0.0f) {
        latitude = [NSString stringWithFormat:@"%f",latitudeFloat];
    } else {
        
        [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user_latitude"];
        
    }
    
    return latitude;
    
}

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
#pragma mark - 搭食团详情数据请求
- (void)getFoodGroudDetailInfo:(NSString *)userID andTeamID:(NSString *)teamID andCallBack:(void(^)(BOOL resultFlag,QSFoodGroudDetailDataModel *detailModel,NSString *errorInfo,NSString *errorcode))callBack
{
    
    ///初步判断参数
    if ((nil == userID) || (0 >= [userID length])) {
        
        callBack(NO,nil,@"用户ID无效",@"ER0021");
        return;
    }
    
    if ((nil == teamID) || (0 >= [teamID length])) {
        
        callBack(NO,nil,@"搭食团ID无效",@"ER0021");
        return;
    }
    
    NSDictionary *dict = @{@"user_id" : userID,@"ta_id" : teamID};
    NSMutableDictionary *params = [QSAPIClientBase SetParamsUnchangeUserID:[dict mutableCopy]];
    
    //请求数据
    [self.dataClient postPath:QSAPIFoodGroudDetail parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已成功返回：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodGroudDetailReturnData objectMapping] keyPath:nil];
        QSFoodGroudDetailReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断数据是否有效
        if (response.detailModel && callBack) {
            
            callBack(YES,response.detailModel,response.errorInfo,response.errorCode);
            
        } else {
            
            callBack(NO,nil,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,nil,[NSString stringWithFormat:@"%@",error],nil);
        
    }];
    
}

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
#pragma mark - 参加一个搭食团
- (void)joinTeamWithID:(NSString *)teamID andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack
{

    ///初步判断参数
    if ((nil == teamID) || (0 >= [teamID length])) {
        
        callBack(NO,@"搭食团ID无效",@"ER0021");
        return;
    }
    
    NSDictionary *dict = @{@"ta_id" : teamID};
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    //请求数据
    [self.dataClient postPath:QSAPIJoinFoodGroud parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已成功返回：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSJoinFoodGroudDetailReturnData objectMapping] keyPath:nil];
        QSJoinFoodGroudDetailReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断数据是否有效
        if (response.type && callBack) {
            
            callBack(YES,response.errorInfo,response.errorCode);
            
        } else {
            
            callBack(NO,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,[NSString stringWithFormat:@"%@",error],nil);
        
    }];

}

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
- (void)outTeamWithID:(NSString *)teamID andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack
{

    ///初步判断参数
    if ((nil == teamID) || (0 >= [teamID length])) {
        
        callBack(NO,@"搭食团ID无效",@"ER0021");
        return;
    }
    
    NSDictionary *dict = @{@"ta_id" : teamID};
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    //请求数据
    [self.dataClient postPath:QSAPIOutFoodGroud parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已成功返回：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSJoinFoodGroudDetailReturnData objectMapping] keyPath:nil];
        QSJoinFoodGroudDetailReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断数据是否有效
        if (response.type && callBack) {
            
            callBack(YES,response.errorInfo,response.errorCode);
            
        } else {
            
            callBack(NO,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,[NSString stringWithFormat:@"%@",error],nil);
        
    }];

}

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
- (void)commitTeamWithID:(NSString *)ibookID andTeamID:(NSString *)teamID andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack
{

    ///初步判断参数
    if ((nil == teamID) || (0 >= [teamID length])) {
        
        callBack(NO,@"搭食团ID无效",@"ER0021");
        return;
    }
    
    if (nil == ibookID || 0 >= [ibookID length]) {
        
        callBack(NO,@"参数无效",@"ER0021");
        return;
        
    }
    
    NSDictionary *dict = @{@"iTeamId" : teamID,@"iBookId":ibookID};
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    //请求数据
    [self.dataClient postPath:QSAPICommitFoodGroud parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已成功返回：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSJoinFoodGroudDetailReturnData objectMapping] keyPath:nil];
        QSJoinFoodGroudDetailReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断数据是否有效
        if (response.type && callBack) {
            
            callBack(YES,response.errorInfo,response.errorCode);
            
        } else {
            
            callBack(NO,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,[NSString stringWithFormat:@"%@",error],nil);
        
    }];

}

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
#pragma mark - 请求搭食团聊天信息/发送信息
- (void)getTalkMessageList:(NSDictionary *)paramsDict andCallBack:(void(^)(BOOL flag,NSArray *msgList,NSString *errorInfo,NSString *errorCode))callBack
{

    ///初步判断参数
    if ((nil == paramsDict) || (0 >= [paramsDict count])) {
        
        callBack(NO,nil,@"搭食团ID无效",@"ER0021");
        return;
    }
    
    ///请求数据参数最后封装
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[paramsDict mutableCopy]];
    
    //请求数据
    [self.dataClient postPath:QSAPIFoodGroudTalkList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已成功返回：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodGroudTeamTalkMessageListReturnData objectMapping] keyPath:nil];
        QSFoodGroudTeamTalkMessageListReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断数据是否有效
        if (response.type && callBack) {
            
            callBack(YES,response.messageList,response.errorInfo,response.errorCode);
            
        } else {
            
            callBack(YES,nil,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,nil,[NSString stringWithFormat:@"%@",error],nil);
        
    }];

}

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
#pragma mark - 搭食团：团聊时的消息发送
- (void)sendFoodGroudTalkMessage:(NSDictionary *)paramsDict andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack
{

    ///初步判断参数
    if ((nil == paramsDict) || (0 >= [paramsDict count])) {
        
        callBack(NO,@"参数无效",@"ER0021");
        return;
    }
    
    ///请求数据参数最后封装
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[paramsDict mutableCopy]];
    
    //请求数据
    [self.dataClient postPath:QSAPIFoodGroudAddMessage parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已成功返回：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodGroudTeamTalkSendMessageReturnData objectMapping] keyPath:nil];
        QSFoodGroudTeamTalkSendMessageReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断数据是否有效
        if (response.type && callBack) {
            
            callBack(YES,response.errorInfo,response.errorCode);
            
        } else {
            
            callBack(NO,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,[NSString stringWithFormat:@"%@",error],nil);
        
    }];

}

@end