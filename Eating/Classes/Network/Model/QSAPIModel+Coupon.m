//
//  QSAPIModel+Coupon.m
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Coupon.h"

@implementation QSAPIModel (Coupon)

@end


@implementation QSCouponListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg.records"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSCouponDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSCouponDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"goods_name",
                                                        @"goods_v_type",
                                                        @"start_time",
                                                        @"end_time", 
                                                        @"status", 
                                                        @"goods_at_num", 
                                                        @"merchant_id", 
                                                        @"coupon_id", 
                                                        @"merchant_name", 
                                                        @"coup_logo", 
                                                        @"coup_price",
                                                        @"coup_goods_list"
                                                        ]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

