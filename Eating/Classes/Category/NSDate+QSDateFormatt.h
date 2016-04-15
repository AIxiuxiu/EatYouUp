//
//  NSDate+QSDateFormatt.h
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (QSDateFormatt)

+ (NSString *)currentDateWithFormattYYYMMDD;

+ (NSString *)currentDateWithFormattHHMM;

+ (NSString *)currentDateWithFormattHHMMSecondsLater:(NSTimeInterval)seconds;

/**
 *  @author yangshengmeng, 14-12-11 13:12:33
 *
 *  @brief  将整形数据串日期转换为有效的日期格式并返回
 *
 *  @param  interval 日期整数串
 *
 *  @return 以yyyy-mm-dd的格式返回日期字符串
 *
 *  @since  2.0
 */
+ (NSString *)formatIntegerIntervalToDateString:(NSString *)interval;

/**
 *  @author yangshengmeng, 14-12-11 13:12:33
 *
 *  @brief  将整形数据串日期转换为有效的日期格式并返回
 *
 *  @param  interval 日期整数串
 *
 *  @return 以yyyy-mm-dd HH:mm:ss的格式返回日期字符串
 *
 *  @since  2.0
 */
+ (NSString *)formatIntegerIntervalToDateAndTimeString:(NSString *)interval;

/**
 *  @author         yangshengmeng, 14-12-25 15:12:25
 *
 *  @brief          将给定的整数形字符串转换为为24小时制的时间点字符串半返回
 *
 *  @param interval 整数字符串
 *
 *  @return         返回小时.分的字符串
 *
 *  @since          2.0
 */
+ (NSString *)formatIntegerIntervalToTime_YYMMDD_HHMM:(NSString *)interval;

/**
 *  @author         yangshengmeng, 14-12-25 15:12:25
 *
 *  @brief          将给定的整数形字符串转换为为24小时制的时间点字符串半返回
 *
 *  @param interval 整数字符串
 *
 *  @return         返回小时.分的字符串
 *
 *  @since          2.0
 */
+ (NSString *)formatIntegerIntervalToTime_HHMM:(NSString *)interval;

/**
 *  @author yangshengmeng, 14-12-11 13:12:33
 *
 *  @brief  将整形数据串日期转换为有效的日期格式并返回
 *
 *  @param  interval 日期整数串
 *
 *  @return 以yyyy-mm-dd AM/PM hh:mm的格式返回日期字符串
 *
 *  @since  2.0
 */
+ (NSString *)formatIntegerIntervalToDateAMPMString:(NSString *)interval;

/**
 *  @author yangshengmeng, 14-12-13 12:12:23
 *
 *  @brief  将当前日期(到秒)转为毫秒整数串并返回
 *
 *  @return 返回整数串
 *
 *  @since  2.0
 */
+ (NSString *)currentDateIntegerString;

/**
 *  @author     yangshengmeng, 14-12-21 17:12:46
 *
 *  @brief      将给定的日期，转换为整数字符串
 *
 *  @param date 给定的日期
 *
 *  @return     返回整数字符串
 *
 *  @since      2.0
 */
+ (NSString *)formatDateToInterval:(NSDate *)date;

/**
 *  @author         yangshengmeng, 14-12-21 19:12:43
 *
 *  @brief          将给定的整数串日期，转化为NSDate
 *
 *  @param interval 整数串的日期
 *
 *  @return         返回一个NSDate对象
 *
 *  @since          2.0
 */
+ (NSDate *)formatIntervalDateToDate:(NSString *)interval;

@end
