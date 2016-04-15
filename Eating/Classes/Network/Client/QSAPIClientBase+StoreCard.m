//
//  QSAPIClientBase+StoreCard.m
//  Eating
//
//  Created by Jay on 14-12-25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+StoreCard.h"
#import "QSAPIModel+StoreCard.h"

@implementation QSAPIClientBase (StoreCard)

- (void)userStoreCardList:(NSString *)merchant_id
                      key:(NSString *)key
                 page_num:(NSString *)page_num
                orderType:(NSString *)orderType
                  success:(void (^)(QSStoreCardListReturnData *))success
                     fail:(void (^)(NSError *))fail
{

    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"key" : key ? key : @"",
                           @"now_page" : page_num ? page_num : @"",
                           @"type" : orderType ? orderType : @""
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMyCouponBoxList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSStoreCardListReturnData objectMapping] keyPath:nil];
        QSStoreCardListReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.s
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
