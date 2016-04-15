//
//  QSAPIModel+MyTask.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+MyTask.h"

@implementation QSAPIModel (MyTask)

@end

@implementation QSMyTaskListReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"myTaskList" withMapping:[QSMyTaskDataModel objectMapping]]];
    });
    return shared_mapping;
}

@end

@implementation QSMyTaskDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        NSDictionary *mappingKey = @{
                                     @"id" : @"activityID",
                                @"user_id" : @"authorID",
                          @"activity_type" : @"activityType",
                            @"merchant_id" : @"marID",
                          @"activity_name" : @"marName",
                     @"merchant_othername" : @"marNickName",
                          @"merchant_logo" : @"marLogo",
                        @"join_time_start" : @"startTime",
                          @"join_end_time" : @"endTime",
                               @"evaluate" : @"marScore",
                     @"merchant_longitude" : @"marLongitude",
                      @"merchant_latitude" : @"marLatitude",
                            @"user_status" : @"currentUserStatu",
                                 @"is_get" : @"isGet",
                                 @"status" : @"activityStatus"
                                     };
        [shared_mapping addAttributeMappingsFromDictionary:mappingKey];
    });
    return shared_mapping;
}

@end