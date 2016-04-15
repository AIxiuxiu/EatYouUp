//
//  NSString+Name.h
//  Eating
//
//  Created by System Administrator on 11/13/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Name)

- (NSString *)imageUrl;

- (NSString *)foodMenuUrl;

/**
 *  @author yangshengmeng, 14-12-09 15:12:20
 *
 *  @brief  根据给定的宽度，计算内容显示所需高度
 *
 *  @param width    固定的宽
 *  @param fontSize 字体大小
 *
 *  @return 返回给定宽度下显示当前内容需要的高度
 *
 *  @since eating-2.0
 */
- (CGFloat)calculateStringHeightByFixedWidth:(CGFloat)width andFontSize:(CGFloat)fontSize;

/**
 *  @author yangshengmeng, 14-12-09 15:12:20
 *
 *  @brief  根据给定的高度，计算内容显示所需宽度
 *
 *  @param width    固定的高
 *  @param fontSize 字体大小
 *
 *  @return 返回给定高度下显示当前内容需要的宽度
 *
 *  @since eating-2.0
 */
- (CGFloat)calculateStringHeightByFixedHeight:(CGFloat)height andFontSize:(CGFloat)fontSize;

/**
 *  @author yangshengmeng, 14-12-11 15:12:08
 *
 *  @brief  将百分比折扣转换为十进制折扣
 *
 *  @param  percent 百分比折扣字符串
 *
 *  @return 返回十进制的折扣说明
 *
 *  @since  2.0
 */
- (NSString *)formatDiscountWithPercent:(NSString *)percent;

/**
 *  @author         yangshengmeng, 14-12-15 10:12:30
 *
 *  @brief          验证邮箱是否合法
 *
 *  @param email    邮箱字符串
 *
 *  @return         返回是否合法：YES-邮箱地址合法
 *
 *  @since          2.0
 */
 + (BOOL)isValidateEmail:(NSString *)email;

/**
 *  @author         yangshengmeng, 14-12-15 10:12:10
 *
 *  @brief          验证手机是否合法
 *
 *  @param mobile   手机号码串
 *
 *  @return         返回验证结果
 *
 *  @since          2.0
 */
 + (BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  @author yangshengmeng, 14-12-11 15:12:24
 *
 *  @brief  根据优惠券大小类，格式化为代码定义的优惠券类型并返回类型编码
 *
 *  @param  bigType 优惠券类型
 *  @param  subType 优惠类小类
 *
 *  @return 返回编码实现中的优惠券编码
 *
 *  @since  2.0
 */
+ (MYLUNCHBOX_COUPON_TYPE)formatCouponTypeWithType:(NSString *)bigType andSubType:(NSString *)subType;

/**
 *  @author                 yangshengmeng, 14-12-23 09:12:42
 *
 *  @brief                  根据不同的卡类型，转换为中文描述的券类名
 *
 *  @param couponTypeCode   客户端的优惠券类型代码
 *
 *  @return                 返回当前优惠券类型中文描述
 *
 *  @since                  2.0
 */
+ (NSString *)getCouponTypeChineseName:(MYLUNCHBOX_COUPON_TYPE)couponTypeCode;

@end
