//
//  QSAPIClientBase+Coupon.m
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Coupon.h"
#import "QSAPIModel+Coupon.h"
#import "NSString+JSON.h"

@implementation QSAPIClientBase (Coupon)

- (void)userCouponListWithMerchant_id:(NSString *)merchant_id
                              success:(void (^)(QSCouponListReturnData *))success
                                 fail:(void (^)(NSError *))fail
{
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @""
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserCouponList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSCouponListReturnData objectMapping] keyPath:nil];
        QSCouponListReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response) {
            
            success(response);
            
        } else{
            
            ///服务端返回的错误：可能参数有误
            fail([NSError errorWithDomain:@"请求可用优惠券列表" code:1002 userInfo:@{NSLocalizedDescriptionKey:@"参数有误"}]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///网络连接出错
        fail([NSError errorWithDomain:@"请求可用优惠券列表" code:1002 userInfo:@{NSLocalizedDescriptionKey:@"当前网络不可用"}]);
        
    }];
}

- (void)recommendCouponList:(NSString *)merchant_id Type:(NSString *)type success:(void (^)(QSCouponListReturnData *))success fail:(void (^)(NSError *))fail
{
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"getType" : type ? type : @""
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIRecommendCouponList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSCouponListReturnData objectMapping] keyPath:nil];
        QSCouponListReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response) {
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
