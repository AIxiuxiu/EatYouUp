//
//  QSAPIModel+QSTryActivitiesReturnData.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+QSTryActivitiesReturnData.h"

@implementation QSAPIModel (QSTryActivitiesReturnData)

@end

@implementation QSTryActivitiesReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"tryActivitiesModel" withMapping:[QSTryActivitiesDataModel objectMapping]]];
    });
    return shared_mapping;
}

@end

@implementation QSTryActivitiesDataModel

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                             @"id" : @"activitiesID",
                                        @"user_id" : @"userID",
                                  @"activity_type" : @"activitiesType",
                                  @"activity_name" : @"activitiesName",
                                @"join_time_start" : @"startTime",
                                  @"join_end_time" : @"endTime",
                                       @"join_num" : @"joinNum",
                                      @"real_join" : @"emtyNum",
                                           @"logo" : @"headerImage",
                                    @"merchant_id" : @"marID",
                                  @"merchant_name" : @"marName",
                                  @"merchant_logo" : @"marIcon",
                                        @"address" : @"marAddress",
                                 @"add_contidtion" : @"addCondiction",
                                         @"detail" : @"activitiesDetail",
                                    @"user_status" : @"currentUserStatue",
                                         @"status" : @"activityStatu",
                                          @"isGet" : @"isGet"
                                                             }];
    });
    return shared_mapping;
}

//打印
- (NSString *)description
{
    NSString *resultString = [NSString stringWithFormat:@"\n activitiesID = %@ \n userID = %@ \n activitiesType = %@ \n activitiesName = %@ \n startTime = %@ \n endTime= %@ \n joinNum = %@ \n emtyNum = %@ \n headerImage = %@ \n marID = %@ \n marAddress = %@ \n addCondiction = %@ \n activitiesDetail = %@ \n currentUserStatue = %@",self.activitiesID,self.userID,self.activitiesType,self.activitiesName,self.startTime,self.endTime,self.joinNum,self.emtyNum,self.headerImage,self.marID,self.marAddress,self.addCondiction,self.activitiesDetail,self.currentUserStatue];
    return resultString;
}

@end