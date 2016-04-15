//
//  QSAPIModel+CouponList.m
//  Eating
//
//  Created by ysmeng on 14/12/10.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+CouponList.h"

@implementation QSAPIModel (CouponList)

@end

/**
 *  @author yangshengmeng, 14-12-10 11:12:26
 *
 *  @brief  服务端返回外层数据：成功/失败
 *
 *  @since 2.0
 */
#pragma mark - 服务端返回外层数据：成功/失败
@implementation QSMarchantCouponListReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        //获取每个商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"recordModel" withMapping:[QSMarchantListReturnData objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

/**
 *  @author yangshengmeng, 14-12-10 17:12:31
 *
 *  @brief  商户包信息数据
 *
 *  @since  2.0
 */
#pragma mark -  商户包信息数据
@implementation QSMarchantListReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"total_page" : @"totalPage",
                                      @"total_num" : @"totalNum",
                                      @"before_page" : @"beforePageNum",
                                      @"per_page" : @"currentPageNum",
                                      @"next_page" : @"nextPageNum"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
#if 1
        //获取每个商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"marList" withMapping:[QSMarchantBaseInfoDataModel objectMapping]]];
#endif
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

/**
 *  @author yangshengmeng, 14-12-10 12:12:14
 *
 *  @brief  单个商户的信息
 *
 *  @since 2.0f
 */
#pragma mark - 商户信息
@implementation QSMarchantBaseInfoDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"marID",
                                      @"merchant_name" : @"marName",
                                      @"merchant_logo" : @"marIcon",
                                      @"address" : @"marAddress",
                                      @"merchant_othername" : @"marNickName",
                                      @"longitude" : @"marLongitude",
                                      @"latitude" : @"marLatitude",
                                      @"score" : @"marRemarkScore"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
#if 1
        ///获取储值卡列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stored_card" toKeyPath:@"prepaidCardList" withMapping:[QSMarCouponDetailDataModel objectMapping]]];
        
        ///获取限时优惠列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"time_pro" toKeyPath:@"limitedTimeOfferList" withMapping:[QSMarCouponDetailDataModel objectMapping]]];
        
        ///获取菜品优惠列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"greens_pro" toKeyPath:@"foodOfferList" withMapping:[QSMarCouponDetailDataModel objectMapping]]];
        
        ///获取会员优惠列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"vip_pro" toKeyPath:@"memberDiscountList" withMapping:[QSMarCouponDetailDataModel objectMapping]]];
        
        ///获取代金券列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"money_coupon" toKeyPath:@"voucherList" withMapping:[QSMarCouponDetailDataModel objectMapping]]];
        
        ///获取折扣券列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"discount_coupon" toKeyPath:@"fasteningVolumeList" withMapping:[QSMarCouponDetailDataModel objectMapping]]];
        
        ///获取菜品兑换券列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"greens_coupon" toKeyPath:@"exchangeVolumeList" withMapping:[QSMarCouponDetailDataModel objectMapping]]];
        
        ///获取菜品兑换券列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"coupon_list" toKeyPath:@"myCouponList" withMapping:[QSMarCouponDetailDataModel objectMapping]]];
#endif
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

///重写description
- (NSString *)description
{
    return [NSString stringWithFormat:@"class is = %@\n id = %@\n name = %@\n prepaidList = %@",[self class],self.marID,self.marName,self.prepaidCardList];
}

@end

/**
 *  @author yangshengmeng, 14-12-10 12:12:12
 *
 *  @brief  优惠卷的基本信息
 *
 *  @since 2.0
 */
#pragma mark - 优惠卷的基本信息
@implementation QSMarCouponDetailDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"couponID",
                                      @"detail_id" : @"couponSubID",
                                      @"goods_name" : @"couponName",
                                      @"goods_type" : @"couponType",
                                      @"goods_v_type" : @"couponSubType",
                                      @"per_status" : @"currentUserCouponStatues",
                                      @"goods_desc" : @"des",
                                      @"varil_end_time" : @"lastTime",
                                      @"pri_time_per" : @"limitedTimeDiscount",
                                      @"pri_goods_per" : @"foodOfferDiscount",
                                      @"goods_image" : @"foodImage",
                                      @"vip_per" : @"vipDiscount",
                                      @"pri_money" : @"coucherValue",
                                      @"goods_pice" : @"prepaidCardBuyPrice",
                                      @"goods_virtual_gold" : @"prepaidCardValuePrice",
                                      @"good_num" : @"sumNumOfCoupon",
                                      @"goods_remain" : @"leftNumOfCoupon",
                                      @"status":@"couponStatus"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
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
- (MYLUNCHBOX_COUPON_TYPE)formatCouponTypeWithType
{
    
    ///优惠券大类
    NSString *bigType = self.couponType;
    NSString *subType = self.couponSubType;
    
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
 *  @author yangshengmeng, 14-12-12 09:12:13
 *
 *  @brief  返回当前优惠的状态：可退款、已使用、已过期
 *
 *  @return 返回状态代码
 *
 *  @since  2.0
 */
#pragma mark - 返回当前优惠的状态
- (MYLUNCHBOX_COUPON_STATUS)getCouponCurrentStatus
{
    
    if ([self.couponStatus isEqualToString:@"2"]) {
        
        return EXPIRED_MCS;
        
    }
    
    ///需要区分优惠券还是储值卡
    if (PREPAIDCARD_MCT == [self formatCouponTypeWithType]) {
        
        ///状态：3-可使用 1-使用完 2-购买中 5-商家取消 6-过期 7-退款中 8-已使用
        int status = [self.currentUserCouponStatues intValue];
        switch (status) {
                
            case 3:
                
                return DEFAULT_MCS;
                
                break;
                
            case 8:
                
                return USING_MCS;
                
                break;
                
                ///退款中
            case 7:
                
                return REFUNDING_MCS;
                
                break;
                
                ///退款成功
            case 4:
                
                return REFUNDED_MCS;
                
                break;
                
            case 1:
                
            case 2:
                
            case 5:
                
            case 6:
                
            default:
                
                return EXPIRED_MCS;
                
                break;
        }
        
    }
    
    ///非储值卡
    if ([self.currentUserCouponStatues isEqualToString:@"3"]) {
        
        return USING_MCS;
        
    }
    
    if ([self.currentUserCouponStatues isEqualToString:@"2"]) {
        
        return DEFAULT_MCS;
        
    }
    
    return DEFAULT_MCS;
    
}

@end