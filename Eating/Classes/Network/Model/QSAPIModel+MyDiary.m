//
//  QSAPIModel+MyDiary.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+MyDiary.h"

@implementation QSAPIModel (MyDiary)

@end

@implementation QSMyDiaryListReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"myDiaryList" withMapping:[QSMyDiaryDataModel objectMapping]]];
    });
    return shared_mapping;
}

@end

@implementation QSMyDiaryDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        NSDictionary *mappingKey = @{
                                     @"id" : @"diaryID",
                                     @"user_id" : @"authorID",
                                     @"merchant_id" : @"marID",
                                     @"user_name" : @"userName",
                                     @"id" : @"userIcon",
                                     @"id" : @"diaryTitle",
                                     @"article_time" : @"releaseTime",
                                     @"modify_time" : @"lastUpdateTime",
                                     @"view_num" : @"readCount",
                                     @"love_num" : @"interestedCount",
                                     @"id" : @"diaryComment"
                                     };
        //image_list
        [shared_mapping addAttributeMappingsFromDictionary:mappingKey];
        
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"image_list" toKeyPath:@"imageList" withMapping:[QSMyDiaryImageModel objectMapping]]];
    });
    return shared_mapping;
}

@end

@implementation QSMyDiaryImageModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        NSDictionary *mappingKey = @{
                                     @"id" : @"diaryID",
                                     @"user_id" : @"authorID",
                                     @"merchant_id" : @"marID",
                                     @"user_name" : @"userName",
                                     @"user_logo" : @"userIcon",
                                     @"merchant_name" : @"marName",
                                     @"article_time" : @"releaseTime",
                                     @"modify_time" : @"lastUpdateTime",
                                     @"view_num" : @"readCount",
                                     @"love_num" : @"interestedCount",
                                     @"address" : @"diaryComment",
                                     @"image_list" : @"imageList",
                                     @"merchant_longitude" : @"merchantLongitude",
                                     @"merchant_latitude" : @"merchantLatitude",
                                     @"merchant_othername" : @"marNickName"
                                     };
        [shared_mapping addAttributeMappingsFromDictionary:mappingKey];
    });
    return shared_mapping;
}

@end