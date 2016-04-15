//
//  QSAPIClientBase+Food.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Food.h"
#import "QSAPIModel+Food.h"

@implementation QSAPIClientBase (Food)

- (void)foodListWithMerchantId:(NSString *)merchant_id
                       pageNum:(NSInteger)pageNum
                           tag:(NSString *)tag
                        flavor:(NSString *)flavor
                          pice:(NSString *)pice
                       success:(void(^)(QSFoodListReturnData *response))success
                          fail:(void(^)(NSError *error))fail;
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"pageNum" : @(pageNum) ? @(pageNum) : @(1),
                           @"tag" : tag ? tag : @"",
                           @"flavor" : flavor ? flavor : @"",
                           @"pice" : pice ? pice : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIFoodList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodListReturnData objectMapping] keyPath:nil];
        QSFoodListReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)foodDetailWithGoodsId:(NSString *)goods_id
                      success:(void (^)(QSFoodDetailReturnData *))success
                         fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"menu_id" : goods_id ? goods_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIFoodDetail parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodDetailReturnData objectMapping] keyPath:nil];
        QSFoodDetailReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)foodMenuWithGoodsName:(NSString *)goods_name
                      success:(void (^)(QSAPIModelString *))success
                         fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"str" : goods_name ? goods_name : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIFoodMenu parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
