//
//  QSAPIModel+Trade.m
//  Eating
//
//  Created by System Administrator on 12/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Trade.h"

@implementation QSAPIModel (Trade)

@end

@implementation QSTradeListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg.records"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSTradeDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


@implementation QSTradeDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"parent_id",
                                                        @"order_num",
                                                        @"status",
                                                        @"time", 
                                                        @"user_id", 
                                                        @"pay_num",
                                                        @"desc", 
                                                        @"bill_num", 
                                                        @"type", 
                                                        @"pay_time",
                                                        @"indent_type",
                                                        @"indent_id"
                                                        ]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"trade_id"
                                                             }];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end