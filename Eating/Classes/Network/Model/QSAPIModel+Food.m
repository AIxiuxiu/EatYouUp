//
//  QSAPIModel+Food.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Food.h"

@implementation QSAPIModel (Food)

@end


@implementation QSFoodListReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSFoodDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSFoodDetailReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
                                                                                       toKeyPath:@"data"
                                                                                     withMapping:[QSFoodDetailData objectMapping]]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end


@implementation QSFoodDetailData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[
                                                        @"goods_name",
                                                        @"goods_pice",
                                                        @"goods_real_pice",
                                                        @"goods_style",
                                                        @"goods_taste",
                                                        @"goods_evaluation",
                                                        @"goods_desc",
                                                        @"goods_image",
                                                        @"goods_up_time",
                                                        @"goods_modify_time",
                                                        @"goods_comment_num",
                                                        @"goods_marketing_num",
                                                        @"goods_visit_times",
                                                        @"good_num",
                                                        @"share_times",
                                                        @"sound_times",
                                                        @"goods_remain",
                                                        @"goods_image_list",
                                                        @"goods_over_time",
                                                        @"goods_type",
                                                        @"goods_virtual_gold",
                                                        @"goods_real_virtual_gold",
                                                        @"goods_cat",
                                                        @"goods_tag",
                                                        @"goods_sounds",
                                                        @"recommend",
                                                        @"merchant_id",
                                                        @"status",
                                                        @"goods_taste_tag",
                                                        @"goods_sale_type",
                                                        @"goods_correlate",
                                                        @"add_user_id",
                                                        @"use_num",
                                                        @"varil_begin_time",
                                                        @"varil_end_time",
                                                        @"hasCaipu",
                                                        @"goods_vip_pice",
                                                        @"goods_v_type",
                                                        @"t_begin_time",
                                                        @"t_end_time",
                                                        @"pri_time_per",
                                                        @"pri_goods_list",
                                                        @"pri_goods_per",
                                                        @"vip_per",
                                                        @"per_type",
                                                        @"add_time",
                                                        @"goods_or_num",
                                                        @"pri_money",
                                                        @"pro_list",
                                                        @"cou_list",
                                                        @"goods_share_num",
                                                        @"translate_type",
                                                        @"sendout_num",
                                                        @"view_num",
                                                        @"translation_num",
                                                        @"be_good_num",
                                                        @"be_book_num",
                                                        @"marketing",
                                                        @"connection_menu",
                                                        @"msg",
                                                        @"num"
                                                        ]];
        [shared_mapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"goods_id"
                                                             }];
//        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg"
//                                                                                       toKeyPath:@"data"
//                                                                                     withMapping:[QSFoodDetailData objectMapping]]];
    });
    
    return shared_mapping;
    
}

@end