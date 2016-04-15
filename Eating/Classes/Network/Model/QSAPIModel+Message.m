//
//  QSAPIModel+Message.m
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Message.h"

@implementation QSAPIModel (Message)

@end

@implementation QSUserTalkListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSUserTalkListDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSUserTalkListDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"from_user_id",
                                                        @"to_user_id",
                                                        @"to_merchant_id",
                                                        @"add_time",
                                                        @"status", 
                                                        @"parent_id",
                                                        @"first_id",
                                                        @"from_user_name",
                                                        @"to_name",
                                                        @"content",
                                                        @"get_time",
                                                        @"reply_time",
                                                        @"send_time",
                                                        @"reply_content",
                                                        @"merchant_logo",
                                                        @"merchant_name",
                                                        ]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"message_id"
                                                             }];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


@implementation QSMerchantChatListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSMerchantChatDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


@implementation QSMerchantChatDetailData


+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"from_user_id",
                                                        @"to_user_id",
                                                        @"to_merchant_id",
                                                        @"add_time",
                                                        @"status",
                                                        @"parent_id",
                                                        @"first_id",
                                                        @"from_user_nam",
                                                        @"to_name",
                                                        @"content",
                                                        @"get_time",
                                                        @"reply_time",
                                                        @"send_time",
                                                        @"reply_content",
                                                        @"merchant_logo",
                                                        @"merchant_name",
                                                        ]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"message_id"
                                                             }];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}


@end