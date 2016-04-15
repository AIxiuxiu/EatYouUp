//
//  QSAPIModel+QSFreeActivitiesStore.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+QSFreeActivitiesStore.h"

@implementation QSAPIModel (QSFreeActivitiesStore)

@end

@implementation QSFreeActivitiesStoreReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"freeActivitiesStoreList" withMapping:[QSFreeActivitiesStoreModel objectMapping]]];
    });
    return shared_mapping;
}

@end

@implementation QSFreeActivitiesStoreModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                    @"id" : @"actID",
                                           @"merchant_id" : @"marID",
                                               @"user_id" : @"userID",
                                         @"merchant_logo" : @"storeIcon",
                                         @"merchant_name" : @"storeName",
                                    @"merchant_othername" : @"marOtherName",
                                               @"address" : @"storeAddress",
                                                 @"score" : @"starLevel",
                                       @"join_time_start" : @"startDate",
                                         @"join_end_time" : @"endDate",
                                                @"status" : @"statusCurrent",
                                                  @"long" : @"distance"
                                                             }];
    });
    return shared_mapping;
}

@end