//
//  QSAPIModel+QSFoodDetectiveRecommendReturnData.m
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+QSFoodDetectiveRecommendReturnData.h"

@implementation QSAPIModel (QSFoodDetectiveRecommendReturnData)

@end

@implementation QSFoodDetectiveRecommendReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"foodDetectiveArray" withMapping:[QSFoodDetectiveRecommendModel objectMapping]]];
    });
    return shared_mapping;
}

@end

@implementation QSFoodDetectiveRecommendModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                        @"id" : @"actID",
                               @"merchant_id" : @"marID",
                                      @"logo" : @"imageName",
                             @"merchant_name" : @"marName",
                                   @"user_id" : @"userID"
                                                             }];
    });
    return shared_mapping;
}

@end
