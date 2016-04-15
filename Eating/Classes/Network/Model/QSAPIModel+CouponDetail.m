//
//  QSAPIModel+CouponDetail.m
//  Eating
//
//  Created by ysmeng on 14/12/12.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+CouponDetail.h"

@implementation QSAPIModel (CouponDetail)

@end

/**
 *  @author yangshengmeng, 15-01-08 01:01:55
 *
 *  @brief  储值卡退款时返回的数据
 *
 *  @since  2.0
 */
@implementation QSPrepaidCardRefundReturdData

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
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

@implementation QSYCouponDetailReturnData

/**
 *  @author yangshengmeng, 14-12-12 12:12:03
 *
 *  @brief  优惠详情服务端返回信息，第一层数据模型
 *
 *  @return 返回mapping的结果
 *
 *  @since  2.0
 */
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
        ///第一层中的字典直接解,其它就用给个模型定义
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        //获取每个商户信息（返回数据第一层中的数组解析），msg是第一层中的数组名，detaiModel是继承了食物组中QSFoodGroudDetailDataModel *detailModel的数据，代表msg，用QSYCouponDetailDataModel模型解析第二层的数据,其中里面有字典跟数组，数组要放到第三层中，例如菜品优惠数组，用QSYFoodOfferFoodDiscountDataModel模型解析
        
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"detailModel" withMapping:[QSYCouponDetailDataModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

@implementation QSYCouponDetailDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典，即detailModel中的成员变量
        NSDictionary *mappingDict = @{
                                      @"id" : @"couponID",
                                      @"goods_name" : @"couponName",
                                      @"goods_type" : @"couponType",
                                      @"goods_v_type" : @"couponSubType",
                                      @"goods_desc" : @"des",
                                      @"varil_begin_time" : @"startTime",
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
                                      @"goods_tag" : @"cardInfoList",
                                      @"is_good" : @"currentUserInterestedStatus"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        ///解析更多详情信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"detail_msg" toKeyPath:@"moreDetailInfoModel" withMapping:[QSYCouponMoreDetailInfoDataModel objectMapping]]];
        
        ///商户信息模型
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"merchant_msg" toKeyPath:@"marchantBaseInfoModel" withMapping:[QSYMarchantBaseInfoDataModel objectMapping]]];
        
        ///个人领取优惠券信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"per_data" toKeyPath:@"personCouponInfoModel" withMapping:[QSYCouponPersonDataModel objectMapping]]];
        
        ///菜品优惠的每样菜图片信息数组，这是第二层解析中的数组，要放到第三层解析，用QSYFoodOfferFoodDiscountDataModel解析（foodImageList里的成员）
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"greens_list" toKeyPath:@"foodImageList" withMapping:[QSYFoodOfferFoodDiscountDataModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end


/*!
 *  @author wangshupeng, 15-01-11 17:01:48
 *
 *  @brief  菜品优惠数组（第三层）的解析模型
 *
 *  @since 2.0
 */
@implementation QSYFoodOfferFoodDiscountDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{
                                      @"id" : @"foodID",        ///与模型成员变量一一对应
                                      @"goods_name" : @"foodTitle",
                                      @"goods_pice" : @"foodOriginalPrice",
                                      @"goods_image" : @"foodImageURLString"};
        ///
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end

/**
 *  @author yangshengmeng, 14-12-12 13:12:08
 *
 *  @brief  优惠券的附加信息，比如使用规则，预约流程等
 *
 *  @since  2.0
 */
@implementation QSYCouponMoreDetailInfoDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{
                                      @"id" : @"detailID",
                                      @"mer_desc" : @"marchantDes",
                                      @"mer_activity_desc" : @"activityDes",
                                      @"promotion_desc" : @"favourableDes",
                                      @"book_desc" : @"subscribeDes",
                                      @"use_rule" : @"useNotice"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

/**
 *  @author yangshengmeng, 14-12-12 13:12:11
 *
 *  @brief  优惠券发行商户的基本信息
 *
 *  @since  2.0
 */
@implementation QSYMarchantBaseInfoDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{
                                      @"id" : @"marID",
                                      @"merchant_name" : @"marName",
                                      @"merchant_logo" : @"marIcon",
                                      @"merchant_othername" : @"marNickName",
                                      @"free_service" : @"marFreeServicesList",
                                      @"address" : @"merAddress",
                                      @"longitude" : @"merchantLongitude",
                                      @"latitude" : @"merchantLatitude"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

@implementation QSYCouponPersonDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"userCardID",
                                      @"serial_num" : @"serielNumber",
                                      @"goods_at_num" : @"dynamicPassWord",
                                      @"val" : @"valuePrice",
                                      @"limit_val" : @"leftValue"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end