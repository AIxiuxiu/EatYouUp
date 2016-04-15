//
//  QSAPIClientBase+Message.m
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Message.h"
#import "QSAPIModel+Message.h"

@implementation QSAPIClientBase (Message)

- (void)merchantChatList:(NSString *)merchant_id
                    page:(NSInteger)startPage
                 success:(void (^)(QSMerchantChatListReturnData *))success
                    fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"startPage" : @(startPage) ? @(startPage) : @"1",
                           @"pageNum" : @(100)
                           };
    NSLog(@"%@",dict);
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantChatList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSMerchantChatListReturnData objectMapping] keyPath:nil];
        QSMerchantChatListReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userChatList:(NSInteger)startPage
             success:(void (^)(QSUserTalkListReturnData *))success
                fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"startPage" : @(startPage) ? @(startPage) : @"1",
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserTalkList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSUserTalkListReturnData objectMapping] keyPath:nil];
        QSUserTalkListReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)merchantChatAdd:(NSString *)merchant_id
         from_user_name:(NSString *)from_user_name
                to_name:(NSString *)to_name
                content:(NSString *)content
                success:(void (^)(QSAPIModelString *))success
                   fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"to_merchant_id" : merchant_id ? merchant_id : @"",
                           @"from_user_name" : from_user_name ? from_user_name : @"",
                           @"to_name" : to_name ? to_name : @"",
                           @"content" : content ? content : @"",
                           };
    NSLog(@"%@",dict);
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantChatAdd parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
