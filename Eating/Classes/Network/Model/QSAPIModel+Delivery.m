//
//  QSAPIModel+Delivery.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Delivery.h"

@implementation QSAPIModel (Delivery)

@end


@implementation QSDeliveryListReutrnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSDeliveryDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


@implementation QSDeliveryDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"address",
                                                        @"phone",
                                                        @"name",
                                                        @"other_phone",
                                                        @"user_id",
                                                        @"account_name",
                                                        @"ad_time",
                                                        @"modify_time",
                                                        @"status",
                                                        @"area",
                                                        @"pro",
                                                        @"city"
                                                        ]];
    });
    [shared_mapping addAttributeMappingsFromDictionary:@{@"id" : @"delivery_id"}];
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}
@end