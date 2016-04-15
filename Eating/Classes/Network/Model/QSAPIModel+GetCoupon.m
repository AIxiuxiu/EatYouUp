//
//  QSAPIModel+GetCoupon.m
//  Eating
//
//  Created by ysmeng on 14/12/17.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+GetCoupon.h"

@implementation QSAPIModel (GetCoupon)

@end

@implementation QSGetCouponReturnData

/**
 *  @author yangshengmeng, 14-12-12 12:12:03
 *
 *  @brief  领取优惠券是否成功的返回结果
 *
 *  @return 返回mapping的结果
 *
 *  @since  2.0
 */
+ (RKObjectMapping *)objectMapping
{
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
}

@end
