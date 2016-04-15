//
//  QSAPIModel+DetectiveArticle.m
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+DetectiveArticle.h"

@implementation QSAPIModel (DetectiveArticle)

@end

@implementation QSDetectiveArticleReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"articleArray" withMapping:[QSDetectiveArticleDataModel objectMapping]]];
    });
    return shared_mapping;
}

@end

@implementation QSDetectiveArticleDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                            @"id" : @"articleID",
                                       @"user_id" : @"authorID",
                                     @"user_name" : @"authorName",
                                  @"article_time" : @"releaseTime",
                                   @"modify_time" : @"modifyTime",
                                      @"view_num" : @"readCount",
                                      @"love_num" : @"interestedCount",
                                @"isLike" : @"currentUserInterestedStatu",
                                       @"conment" : @"comment",
                                   @"merchant_id" : @"marID",
                                @"image_list_new" : @"authorIconModel"
                                                             }];
    });
    return shared_mapping;
}

@end

@implementation QSDetectiveArticleAuthorIconModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                            @"image_link" : @"authorIcon"
                                                             }];
    });
    return shared_mapping;
}

@end