//
//  QSAPIModel+StoreCard.m
//  Eating
//
//  Created by AYG on 14-12-25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+StoreCard.h"

@implementation QSAPIModel (StoreCard)

@end



@implementation QSStoreCardListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg.records"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSStoreCardDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


@implementation QSStoreCardDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"number",
                                                        @"psw",
                                                        @"user_id",
                                                        @"status",
                                                        @"add_time",
                                                        @"limit_val",
                                                        @"val",
                                                        @"mer_id",
                                                        @"parent_id",
                                                        @"storeCardMsg"]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"card_id"
                                                             }];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end