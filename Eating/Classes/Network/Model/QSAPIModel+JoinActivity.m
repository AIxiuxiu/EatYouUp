//
//  QSAPIModel+JoinActivity.m
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+JoinActivity.h"

@implementation QSAPIModel (JoinActivity)

@end

@implementation QSJoinActivityReturnData

+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"type" : @"type",
                                                             @"msg" : @"infoArray"
                                                             }];
    });
    return shared_mapping;
}

@end