//
//  QSAPIModel+QSFoodDetectiveMarchAcNoticeReturnData.m
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+QSFoodDetectiveMarchAcNoticeReturnData.h"

@implementation QSAPIModel (QSFoodDetectiveMarchAcNoticeReturnData)

@end

@implementation QSFoodDetectiveMarchAcNoticeReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"foodDetectiveArray" withMapping:[QSFoodDetectiveMarchAcNoticeModel objectMapping]]];
    });
    return shared_mapping;
}

@end

@implementation QSFoodDetectiveMarchAcNoticeModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                            @"id" : @"actID",
                                  @"article_time" : @"release_time",
                                   @"modify_time" : @"update_time",
                                       @"user_id" : @"user_id",
                                     @"user_name" : @"user_name",
                                  @"account_name" : @"account_name",
                                     @"user_logo" : @"user_logo",
                                    @"follow_num" : @"follow_num",
                                      @"view_num" : @"view_num",
                                      @"love_num" : @"love_num",
                                   @"merchant_id" : @"merchant_id",
                                         @"title" : @"share_title"
                                                             }];
    });
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"image_list" toKeyPath:@"image_list" withMapping:[QSFoodDetectiveMarchAcNoticeImageModel objectMapping]]];
    return shared_mapping;
}

@end

//推荐店面的图片
@implementation QSFoodDetectiveMarchAcNoticeImageModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                @"image_link" : @"image_name"
                                                             }];
    });
    return shared_mapping;
}

@end
