//
//  QSAPIModel+Takeout.m
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Takeout.h"

@implementation QSAPIModel (Takeout)

@end


@implementation QSTakeoutListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg.records"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSTakeoutDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSTakeoutDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"take_out_num",
                                                        @"user_id",
                                                        @"account_name",
                                                        @"user_name",
                                                        @"user_phone",
                                                        @"order_num",
                                                        @"price_count",
                                                        @"take_num_count",
                                                        @"take_outcol",
                                                        @"take_time",
                                                        @"pro_time",
                                                        @"out_time",
                                                        @"get_time",
                                                        @"merchant_id",
                                                        @"status",
                                                        @"add_time",
                                                        @"take_out_name",
                                                        @"take_out_type",
                                                        @"favorable_id",
                                                        @"pay_type",
                                                        @"pay_status",
                                                        @"add",
                                                        @"take_out_status",
                                                        @"super_need", 
                                                        @"take_num",
                                                        @"take_out_date",
                                                        @"take_out_time",
                                                        @"take_out_phone",
                                                        @"common_id", 
                                                        @"order_id",
                                                        @"customer_id",
                                                        @"merchant_name",
                                                        @"merchant_call",
                                                        @"detail",
                                                        @"merchant_msg"
                                                        ]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"takeout_id"
                                                             }];
    });
    
    return shared_mapping;
}

@end

@implementation QSTakeoutDetailDataCouponInfoDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"couponID",
                                                             @"goods_name" : @"couponName",
                                                             @"" : @"couponPrice"
                                                             }];
    });
    
    return shared_mapping;

}

@end

@implementation QSTakeoutOrderListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSTakeoutDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSTakeoutDetailReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"data" withMapping:[QSTakeoutDetailData objectMapping]]];
        
    });
    
    return shared_mapping;
}

@end