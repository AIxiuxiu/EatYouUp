//
//  QSUserActivityLogModel.m
//  Eating
//
//  Created by ysmeng on 15/1/14.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import "QSUserActivityLogModel.h"
#import "NSDate+QSDateFormatt.h"

@implementation QSUserActivityLogModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{

    if (self = [super init]) {
        
        
        
    }
    
    return self;

}

/**
 *  @author yangshengmeng, 15-01-14 16:01:42
 *
 *  @brief  返回操作日志的参数字典
 *
 *  @since  2.0
 */
#pragma mark - 返回本条操作日志的参数
- (NSDictionary *)userActivityPostParams
{
    
    /**
     *
     *  链接:otal/addLog
     *  参数:log     数组类型
     *
     *  里面的字典
     *  time        int             操作的时间
     *  type        string(3)       类型,用于区别是安卓还是iOS还是web，固定三位
     *  user_id     int             用户id
     *  key         string(固定11位) 键
     *  token       string(固定32位) 唯一标识
     *
     */

    ///临时参数
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    ///时间
    [tempDict setObject:self.activityTime ? self.activityTime : [NSDate currentDateIntegerString] forKey:@"time"];
    
    ///类型
    [tempDict setObject:self.deviceType ? self.deviceType : @"iOS" forKey:@"type"];
    
    ///用户ID
    [tempDict setObject:self.userID ? self.userID : @"0" forKey:@"user_id"];
    
    ///键值
    [tempDict setObject:self.keyString forKey:@"key"];
    
    ///token
    [tempDict setObject:self.token ? self.token : [[NSUserDefaults standardUserDefaults] objectForKey:@"app_token"] forKey:@"token"];
    
    ///类型
    [tempDict setObject:self.logType forKey:@"val_type"];
    
    ///类型ID
    [tempDict setObject:self.idString forKey:@"val"];
    
    return [NSDictionary dictionaryWithDictionary:tempDict];

}

@end
