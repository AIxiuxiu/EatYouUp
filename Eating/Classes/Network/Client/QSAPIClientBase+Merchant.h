//
//  QSAPIClientBase+Merchant.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSMerchantListReturnData;
@class QSMerchantIndexReturnData;
@class QSMerchantChatListReturnData;
@interface QSAPIClientBase (Merchant)

- (void)merchantListWithMerchantid:(NSString *)merchant_id
                 success:(void(^)(QSMerchantListReturnData *response))success
                    fail:(void(^)(NSError *error))fail;

- (void)merchantIndexWithMerchantid:(NSString *)merchant_id
                            success:(void(^)(QSMerchantIndexReturnData *response))success
                               fail:(void(^)(NSError *error))fail;

- (void)merchantNearbyWithLatitude:(double)latitude
                         longitude:(double)longitude
                              skey:(NSString *)skey
                               pro:(NSString *)pro
                              city:(NSString *)city
                              area:(NSString *)area
                              page:(NSInteger)page
                          distance:(NSString *)distance
                            flavor:(NSString *)flavor
                            coupon:(NSString *)coupon
                              sort:(NSString *)sort
                         metroline:(NSString *)metroline
                         bussiness:(NSString *)business
                            merTag:(NSString *)merTag
                      merchantType:(NSString *)merchant_type
                           success:(void (^)(QSMerchantListReturnData *))success
                              fail:(void (^)(NSError *))fail;

- (void)merchantAddError:(NSString *)merchant_id
                    desc:(NSString *)desc
                 success:(void(^)(QSAPIModelString *response))success
                    fail:(void(^)(NSError *error))fail;



@end


