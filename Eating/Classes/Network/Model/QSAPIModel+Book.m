//
//  QSAPIModel+Book.m
//  Eating
//
//  Created by System Administrator on 12/2/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Book.h"
#import "QSAPIModel+Takeout.h"

@implementation QSAPIModel (Book)

@end


@implementation QSBookListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg.records"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSBookDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end



@implementation QSBookDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"user_id",
                                                        @"account_name",
                                                        @"user_name",
                                                        @"merchange_id",
                                                        @"book_time",
                                                        @"book_desc",
                                                        @"book_phone",
                                                        @"book_name",
                                                        @"book_num",
                                                        @"book_no",
                                                        @"order_num",
                                                        @"status",
                                                        @"book_or_num",
                                                        @"reserve_time",
                                                        @"reach_time",
                                                        @"begin_time",
                                                        @"over_time",
                                                        @"book_type",
                                                        @"add_user_id",
                                                        @"book_date",
                                                        @"book_sex",
                                                        @"commit_time",
                                                        @"add_time",
                                                        @"book_seat_type",
                                                        @"book_seat_num",
                                                        @"book_source_type",
                                                        @"merchant_name",
                                                        @"merchant_msg"
                                                        ]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"book_id"
                                                             }];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}


@end


@implementation QSBookDetailReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSBookDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

