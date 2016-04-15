//
//  QSAPIModel+AlixPay.m
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+AlixPay.h"

@implementation QSAPIModel (AlixPay)

@end

@implementation QSAlixPayServerHeaderReturnData

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

/**
 *  @author yangshengmeng, 14-12-14 14:12:58
 *
 *  @brief  服务端返回数据的头信息
 *
 *  @since  2.0
 */
@implementation QSAlixPayReturnData

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
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"orderFormList" withMapping:[QSAlixPayModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

@implementation QSAlixPayTakeoutReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        ///mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        ///获取每个商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"payModelList" withMapping:[QSAlixPayModel objectMapping]]];
        
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"orderModel" withMapping:[QSAlixPayModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

/**
 *  @author yangshengmeng, 14-12-14 15:12:08
 *
 *  @brief  数字签名订单数据模型
 *
 *  @since  2.0
 */
@implementation QSAlixPayModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"order_id" : @"orderFormID",
                                      @"sign" : @"signedRSAString",
                                      @"pri_key" : @"priKey",
                                      @"pri_pkcs8_key" : @"priPKCS8Key",
                                      @"order_num" : @"orderNum",
                                      @"bill_num" : @"billNum"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        ///获取订单
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"form_data" toKeyPath:@"orderModel" withMapping:[QSOrderFormFromServerModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end

@implementation QSOrderFormFromServerModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        [shared_mapping addAttributeMappingsFromArray:@[@"partner",
                                                       @"seller_id",
                                                       @"out_trade_no",
                                                       @"subject",
                                                       @"body",
                                                       @"total_fee",
                                                       @"notify_url",
                                                       @"service",
                                                       @"_input_charset",
                                                       @"it_b_pay",
                                                       @"show_url"]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end