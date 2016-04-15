//
//  QSAPIClientBase+Delivery.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Delivery.h"
#import "QSAPIModel+Delivery.h"

@implementation QSAPIClientBase (Delivery)

- (void)userDeliveryListSuccess:(void (^)(QSDeliveryListReutrnData *))success
                           fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{};
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIDeliveryList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSDeliveryListReutrnData objectMapping] keyPath:nil];
        QSDeliveryListReutrnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)addDelivery:(QSDeliveryDetailData *)data success:(void (^)(QSAPIModel *))success
               fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"address" : data.address ? data.address : @"",
                           @"iphone" : data.phone ? data.phone : @"",
                           @"name" : data.name ? data.name : @"",
                           @"pro" : data.pro ? data.pro : @"",
                           @"city" : data.city ? data.city : @"",
                           @"area" : data.area ? data.area : @"",
                           @"isUse" : data.status ? data.status : @"0"
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIDeliveryAdd parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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

- (void)updateDelivery:(QSDeliveryDetailData *)data success:(void (^)(QSAPIModel *))success
                  fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"id" : data.delivery_id ? data.delivery_id : @"",
                           @"address" : data.address ? data.address : @"",
                           @"iphone" : data.phone ? data.phone : @"",
                           @"name" : data.name ? data.name : @"",
                           @"pro" : data.pro ? data.pro : @"",
                           @"city" : data.city ? data.city : @"",
                           @"area" : data.area ? data.area : @"",
                           @"isUse" : data.status ? data.status : @"0"
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIDeliveryUpdate parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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

- (void)deleteDelivery:(NSString *)delivery_id success:(void (^)(QSAPIModel *))success
                  fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"id" : delivery_id ? delivery_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIDeliveryDelete parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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
