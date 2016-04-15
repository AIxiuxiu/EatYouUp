//
//  QSAPIModel+User.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+User.h"

@implementation QSAPIModel (User)

@end

@implementation QSUserReturnCheckData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        [shared_mapping addAttributeMappingsFromDictionary:@{@"type" : @"type",
                                                             @"info" : @"errorInfo",
                                                             @"code" : @"errorCode"}];
        
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSUserReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"userData"
                                                                                     withMapping:[QSUserData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


@implementation QSUserData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"account_name",
                                                        @"username",
                                                        @"sex",
                                                        @"email",
                                                        @"password",
                                                        @"create_time",
                                                        @"status",
                                                        @"iphone",
                                                        @"qq",
                                                        @"type",
                                                        @"reg_time",
                                                        @"vip",
                                                        @"honour",
                                                        @"iteam_list",
                                                        @"this_login_time",
                                                        @"last_login_time",
                                                        @"this_login_ip",
                                                        @"last_login_ip",
                                                        @"merchant_id",
                                                        @"tag_list",
                                                        @"logo",
                                                        @"integrity",
                                                        @"active",
                                                        @"push_id",
                                                        @"channel_id",
                                                        @"temp_key",
                                                        @"default_address"
                                                        ]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"user_id"
                                                             }];
    });
    return shared_mapping;
}

- (BOOL)hadUserId
{
    return self.user_id && ![self.user_id isEqualToString:@""];
}

- (CLLocationCoordinate2D)location
{

    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user_latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user_longitude"];
    
    return CLLocationCoordinate2DMake(latitude ? [latitude doubleValue] : 23.144208, longitude ? [longitude doubleValue] : 113.327589);

}

@end

@implementation QSTagListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"msg" : @"data"
                                                             }];
    });
    return shared_mapping;
}


@end


