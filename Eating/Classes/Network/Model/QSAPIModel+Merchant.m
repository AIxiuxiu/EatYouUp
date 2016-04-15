//
//  QSAPIModel+Merchant.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Merchant.h"
#import "QSAPIModel+Food.h"
@implementation QSAPIModel (Merchant)

@end

@implementation QSMerchantListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"msg"
                                                                                     withMapping:[QSMerchantDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


@implementation QSMerchantDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"merchant_name",@"merchant_branch",@"merchant_alias",@"merchant_logo",@"merchant_image",@"merchant_sounds",@"merchant_video",@"merchant_desc",@"taste_sec",@"environmental_sec",@"service_sec",@"longitude",@"latitude",@"altitude",@"address",@"merchant_call",@"merchant_traffic",@"merchant_wifi",@"merchant_marketing_num",@"merchant_per",@"merchant_star",@"merchant_start_time",@"merchant_end_time",@"score",@"score_taste",@"score_envirement",@"score_service",@"good_num",@"user_id",@"status",@"merchant_othername",@"merchant_manager",@"merchant_manager_phone",@"merchant_phone",@"pro",@"city",@"area",@"free_service",@"merchant_tag_old",@"merchant_tag",@"merchant_ser",@"business_type",@"business_area",@"referrals",@"metro",
                                                        @"metro_line",
                                                        @"city_sign",
                                                        @"hasTimePro",
                                                        @"hasGreensPro",
                                                        @"hasVipPro",
                                                        @"hasMoneyCoup",
                                                        @"hasDisCoup",
                                                        @"hasGreensCroup",
                                                        @"banner",
                                                        @"coupon_count",
                                                        @"team_activity_count",
                                                        @"isGood",
                                                        @"isStore",
                                                        @"merchant_image_arr",
                                                        @"menu_list",
                                                        @"coup",
                                                        @"merchant_ser_new"]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"merchant_id"
                                                             }];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"mar_menu_list"
                                                                                       toKeyPath:@"mar_menu_list"
                                                                                     withMapping:[QSFoodDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSMerchantIndexReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSMerchantDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


