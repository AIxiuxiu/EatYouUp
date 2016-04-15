//
//  QSNewFoodGroudModel.m
//  Eating
//
//  Created by ysmeng on 14/12/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSNewFoodGroudModel.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"
#import "NSDate+QSDateFormatt.h"

@implementation QSNewFoodGroudModel

/**
 *  @author yangshengmeng, 14-12-21 17:12:34
 *
 *  @brief  封装搭食团参数并返回
 *
 *  @return 返回新增搭食团时的参数
 *
 *  @since  2.0
 */
- (NSDictionary *)packageNewFoodGroudParams
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    ///用户信息
    NSString *userID = [UserManager sharedManager].userData.user_id;
    NSString *userName = [UserManager sharedManager].userData.username;
    [params setObject:userID forKey:@"user_id"];
    [params setObject:userName forKey:@"user_name"];
    
    ///商户信息
    [params setObject:self.merchantID forKey:@"merchant_id"];
    
    ///搭团信息
    [params setObject:[NSString stringWithFormat:@"%@搭吃团",self.merchantName] forKey:@"team_title"];
    [params setObject:self.activityComment forKey:@"team_content"];
    [params setObject:self.membersSumCount forKey:@"join_num"];
    [params setObject:self.addLimited forKey:@"team_sex_type"];
    [params setObject:self.canTakeFamilies forKey:@"team_take_family"];
    [params setObject:[UserManager sharedManager].userData.iphone forKey:@"team_phone"];
    [params setObject:[NSDate formatDateToInterval:self.activityTime] forKey:@"start_time"];
    [params setObject:self.tagList forKey:@"team_tagArr"];
    
    return [NSDictionary dictionaryWithDictionary:params];

}

@end
