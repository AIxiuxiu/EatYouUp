//
//  QSAPIClientBase+Merchant.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Merchant.h"
#import "QSAPIModel+Merchant.h"

@implementation QSAPIClientBase (Merchant)

- (void)merchantListWithMerchantid:(NSString *)merchant_id
                           success:(void (^)(QSMerchantListReturnData *response))success
                              fail:(void (^)(NSError *error))fail
{
    // . setup params
    NSDictionary *dict = @{
                                  @"merchant_id" : merchant_id ? merchant_id : @""
                                  };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSMerchantListReturnData objectMapping] keyPath:nil];
        QSMerchantListReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            
            fail(nil);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(nil);
        
    }];
}

- (void)merchantIndexWithMerchantid:(NSString *)merchant_id
                            success:(void (^)(QSMerchantIndexReturnData *))success
                               fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantIndex parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSMerchantIndexReturnData objectMapping] keyPath:nil];
        QSMerchantIndexReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            //            CHAErrorResponseData *error = [[CHAErrorResponseData alloc] init];
            //            error.str_err = response.str_err;
            //            if (fail) {
            //                fail(error);
            //            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
        //        if (fail) {
        //            fail(response);
        //        }
    }];
}

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
                              fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"latitude" : @(latitude) ? @(latitude) : @"",
                           @"longitude" : @(longitude) ? @(longitude) : @"",
                           @"skey" : skey ? skey : @"",
                           @"pro" : pro ? pro : @"",
                           @"city" : city ? city : @"",
                           @"area" : area ? area : @"",
                           @"startPage" : @(page) ? @(page) : @"",
                           @"distance" : distance ? distance : @"",
                           @"flavor" : flavor ? flavor : @"",
                           @"coupon" : coupon ? coupon : @"",
                           @"sort" : sort ? sort : @"",
                           @"metroline" : metroline ? metroline : @"",
                           @"business" : business ? business : @"",
                           @"merTag" : merTag ? merTag : @"",
                           @"merchant_type" : merchant_type ? merchant_type : @"",
                           
                           };
    NSLog(@"%@",dict);
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantNearList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSMerchantListReturnData objectMapping] keyPath:nil];
        QSMerchantListReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            //            CHAErrorResponseData *error = [[CHAErrorResponseData alloc] init];
            //            error.str_err = response.str_err;
            //            if (fail) {
            //                fail(error);
            //            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
        //        if (fail) {
        //            fail(response);
        //        }
    }];

}

- (void)merchantAddError:(NSString *)merchant_id
                    desc:(NSString *)desc
                 success:(void(^)(QSAPIModelString *response))success
                    fail:(void(^)(NSError *error))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"desc" : desc ? desc : @"",
 };
    NSLog(@"%@",dict);
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantAddError parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelString objectMapping] keyPath:nil];
        QSAPIModelString *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            //            CHAErrorResponseData *error = [[CHAErrorResponseData alloc] init];
            //            error.str_err = response.str_err;
            //            if (fail) {
            //                fail(error);
            //            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
        //        if (fail) {
        //            fail(response);
        //        }
    }];
}

@end
