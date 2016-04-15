//
//  NSDate+QSDateFormatt.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "NSDate+QSDateFormatt.h"

@implementation NSDate (QSDateFormatt)

+ (NSString *)currentDateWithFormattYYYMMDD
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)currentDateWithFormattHHMM
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)currentDateWithFormattHHMMSecondsLater:(NSTimeInterval)seconds
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:seconds]];
}

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
#pragma mark - 将整形数据串日期转换为yyyy-MM-dd格式字符串
+ (NSString *)formatIntegerIntervalToDateString:(NSString *)interval
{
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[interval intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

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
+ (NSString *)formatIntegerIntervalToDateAndTimeString:(NSString *)interval
{
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[interval intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

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
+ (NSString *)formatIntegerIntervalToTime_YYMMDD_HHMM:(NSString *)interval
{
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[interval intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

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
+ (NSString *)formatIntegerIntervalToTime_HHMM:(NSString *)interval
{
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[interval intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return [confromTimespStr substringWithRange:NSMakeRange(11, 5)];
}

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
#pragma mark - 将整形数据串日期转换为yyyy-MM-dd格式字符串
+ (NSString *)formatIntegerIntervalToDateAMPMString:(NSString *)interval
{
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"YYYY-MM-dd aa hh:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[interval intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

/**
 *  @author yangshengmeng, 14-12-13 12:12:23
 *
 *  @brief  将当前日期(到秒)转为毫秒整数串并返回
 *
 *  @return 返回整数串
 *
 *  @since  2.0
 */
#pragma mark - 将当前日期转为整数串
+ (NSString *)currentDateIntegerString
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceReferenceDate];
    return [NSString stringWithFormat:@"%.0f",interval];
}

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
+ (NSString *)formatDateToInterval:(NSDate *)date
{

    NSTimeInterval interval = [date timeIntervalSinceReferenceDate];
    return [NSString stringWithFormat:@"%.0f",interval];

}

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
+ (NSDate *)formatIntervalDateToDate:(NSString *)interval
{

    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[interval intValue]];
    
    return confromTimesp;

}

@end
