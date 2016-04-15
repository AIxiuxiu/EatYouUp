//
//  QSAPIClientBase+Coupon.h
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSCouponListReturnData;
@interface QSAPIClientBase (Coupon)

- (void)userCouponListWithMerchant_id:(NSString *)merchant_id
                              success:(void(^)(QSCouponListReturnData *response))success
                                 fail:(void(^)(NSError *error))fail;

- (void)recommendCouponList:(NSString *)merchant_id
                       Type:(NSString *)type
                    success:(void(^)(QSCouponListReturnData *response))success
                       fail:(void(^)(NSError *error))fail;

@end
