//
//  QSUserActivityLogModel.h
//  Eating
//
//  Created by ysmeng on 15/1/14.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSUserActivityLogModel : NSObject <NSCoding>

@property (nonatomic,copy) NSString *activityTime;  //!<操作时间
@property (nonatomic,copy) NSString *deviceType;    //!<设备类型:本应用统一为iOS
@property (nonatomic,copy) NSString *userID;        //!<用户ID
@property (nonatomic,copy) NSString *keyString;     //!<操作编码
@property (nonatomic,copy) NSString *token;         //!<当前的token
@property (nonatomic,copy) NSString *logType;       //!<当前的日志对应的类型：比如商户
@property (nonatomic,copy) NSString *idString;      //!<附加的ID信息：用于区分商户

/**
 *  @author yangshengmeng, 15-01-14 16:01:42
 *
 *  @brief  返回操作日志的参数字典
 *
 *  @since  2.0
 */
- (NSDictionary *)userActivityPostParams;

@end
