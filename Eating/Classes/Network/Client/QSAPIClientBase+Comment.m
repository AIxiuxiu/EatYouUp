//
//  QSAPIClientBase+Comment.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Comment.h"
#import "QSAPIModel+Comment.h"

@implementation QSAPIClientBase (Comment)


- (void)commentListWithMerchantId:(NSString *)merchant_id
                          success:(void (^)(QSCommentListReturnData *))success
                             fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @""
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantCommentList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSCommentListReturnData objectMapping] keyPath:nil];
        QSCommentListReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            //            CHAErrorResponseData *error = [[CHAErrorResponseData alloc] init];
            //            error.str_err = response.str_err;
            //   x`         if (fail) {
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

- (void)addMerchantCommentWithMerchantId:(NSString *)merchant_id
                                 context:(NSString *)context
                                evaluate:(NSString *)evaluate
                                     per:(NSString *)per
                               imageList:(NSMutableArray *)image_list
                                 success:(void (^)(QSAPIModel *))success
                                    fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"context" : context ? context : @"",
                           @"evaluate" : evaluate ? evaluate : @"",
                           @"per" : per ? per : @"",
                           @"image_list" : image_list ? image_list : @""
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantMakeComment parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
            //   x`         if (fail) {
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
