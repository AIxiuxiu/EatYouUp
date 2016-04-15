//
//  NSString+Name.m
//  Eating
//
//  Created by System Administrator on 11/13/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "NSString+Name.h"
#import "QSConfig.h"

@implementation NSString (Name)

- (NSString *)imageUrl
{
    if ([self rangeOfString:@"http://"].location == NSNotFound) {
        NSString *temp = [NSString stringWithFormat:@"http://117.41.235.110:8888/files/%@",self];
        return temp;
    }
    else{
        return self;
    }
}

- (NSString *)foodMenuUrl
{
    if ([self rangeOfString:@"http://"].location == NSNotFound) {
        NSString *temp = [NSString stringWithFormat:@"http://117.41.235.110:800%@",self];
        return temp;
    }
    else{
        return self;
    }
}

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
#pragma mark - 根据给定的宽度，计算内容显示所需高度
- (CGFloat)calculateStringHeightByFixedWidth:(CGFloat)width andFontSize:(CGFloat)fontSize
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize resultSize = [self boundingRectWithSize:CGSizeMake(width, 999.0) options:NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGFloat height = resultSize.height + 10.0f;
    return height;
}

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
#pragma mark - 根据给定的高度，计算内容显示所需宽度
- (CGFloat)calculateStringHeightByFixedHeight:(CGFloat)height andFontSize:(CGFloat)fontSize
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize resultSize = [self boundingRectWithSize:CGSizeMake(DeviceWidth-20.0f, height) options:NSStringDrawingTruncatesLastVisibleLine |
                         NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGFloat width = resultSize.width + 10.0f;
    return width;
}

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
#pragma mark - 将百分比折扣转换为十进制折扣
- (NSString *)formatDiscountWithPercent:(NSString *)percent
{
    ///将百分数转为整形
    int disNum = [percent intValue];
    
    ///如果是整十的整数
    if ((disNum % 10) == 0) {
        return [NSString stringWithFormat:@"%d",disNum/10];
    }
    
    return [NSString stringWithFormat:@"%.1f",0.1 * disNum];
}

/*邮箱验证 MODIFIED BY HELENSONG*/
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
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
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
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

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
#pragma mark - 将服务端返回的优惠券类型转为类型代码
+ (MYLUNCHBOX_COUPON_TYPE)formatCouponTypeWithType:(NSString *)bigType andSubType:(NSString *)subType
{
    
    ///返回储值卡类型
    if ([bigType isEqualToString:@"5"]) {
        return PREPAIDCARD_MCT;
    }
    
    ///判断是否促销优惠
    if ([bigType isEqualToString:@"2"]) {
        
        //是否限时优惠
        if ([subType isEqualToString:@"1"]) {
            return TIMELIMITEDOFF_MCT;
        }
        
        //是否菜品优惠
        if ([subType isEqualToString:@"2"]) {
            return FOODOFF_MCT;
        }
        
        //是否vip优惠
        if ([subType isEqualToString:@"3"]) {
            return MEMBERDISCOUNT_MCT;
        }
        
    }
    
    ///是否优惠券
    if ([bigType isEqualToString:@"3"]) {
        
        //是否代金卷
        if ([subType isEqualToString:@"1"]) {
            return VOUCHER_MCT;
        }
        
        //是否折扣卷
        if ([subType isEqualToString:@"2"]) {
            return FASTENING_VOLUME_MCT;
        }
        
        //是否菜品兑换券
        if ([subType isEqualToString:@"3"]) {
            return EXCHANGE_VOLUME_MCT;
        }
        
    }
    
    ///返回默认类型
    return DEFAULT_MCT;
}

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
+ (NSString *)getCouponTypeChineseName:(MYLUNCHBOX_COUPON_TYPE)couponTypeCode
{

    switch (couponTypeCode) {
            ///储值卡
        case PREPAIDCARD_MCT:
            
            return @"储值卡";
            
            break;
            
            ///储值卡
        case TIMELIMITEDOFF_MCT:
            
            return @"限时优惠";
            
            break;
            
            ///储值卡
        case FOODOFF_MCT:
            
            return @"菜品优惠";
            
            break;
            
            ///储值卡
        case MEMBERDISCOUNT_MCT:
            
            return @"会员优惠";
            
            break;
            
            ///储值卡
        case VOUCHER_MCT:
            
            return @"代金券";
            
            break;
            
            ///储值卡
        case FASTENING_VOLUME_MCT:
            
            return @"折扣券";
            
            break;
            
            ///储值卡
        case EXCHANGE_VOLUME_MCT:
            
            return @"菜品兑换券";
            
            break;
            
        default:
            break;
    }
    
    return @"待定";

}

@end
