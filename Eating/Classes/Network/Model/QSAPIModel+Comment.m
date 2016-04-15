//
//  QSAPIModel+Comment.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Comment.h"

@implementation QSAPIModel (Comment)

@end


@implementation QSCommentListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSCommentDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}
@end


@implementation QSCommentDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"parent_id",
                                                        @"conment",
                                                        @"type" ,
                                                        @"article_time",
                                                        @"modify_time",
                                                        @"user_id",
                                                        @"account_name",
                                                        @"user_name",
                                                        @"follow_num",
                                                        @"per",
                                                        @"status",
                                                        @"evaluate",
                                                        @"user_link",
                                                        @"image_list",
                                                        @"image_list_new"
                                                        ]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"comment_id"
                                                             }];

    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end