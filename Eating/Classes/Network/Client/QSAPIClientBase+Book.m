//
//  QSAPIClientBase+Book.m
//  Eating
//
//  Created by System Administrator on 12/2/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Book.h"
#import "QSAPIModel+Book.h"
#import "QSAPIModel+Food.h"


@implementation QSAPIClientBase (Book)

- (void)addBookWithMerchantId:(NSString *)merchant_id
                     BookDate:(NSString *)book_date
                     BookTime:(NSString *)book_time
                      BookNum:(NSString *)book_num
                 BookSeatType:(BOOL)book_seat_type
                     BookName:(NSString *)book_name
                    BookPhone:(NSString *)book_phone
                     BookDesc:(NSString *)book_desc
                      BookSex:(NSString *)book_sex
                   BookMenArr:(NSMutableArray *)book_menu_arr
                      success:(void (^)(QSAPIModelDict *))success
                         fail:(void (^)(NSError *))fail
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (QSFoodDetailData *info in book_menu_arr) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:info.goods_id forKey:@"id"];
        [dict setValue:info.goods_name forKey:@"name"];
        [dict setValue:info.goods_pice forKey:@"pice"];
        [dict setValue:[NSString stringWithFormat:@"%d",info.localAmount] forKey:@"num"];
        [temp addObject:dict];
    }
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"book_date" : book_date ? book_date : @"",
                           @"book_time" : book_time ? book_time : @"",
                           @"book_name" : book_name ? book_name : @"",
                           @"book_phone" : book_phone ? book_phone : @"",
                           @"book_desc" : book_desc ? book_desc : @"",
                           @"book_seat_type" : book_seat_type == YES ? @"1" : @"0",
                           @"book_menu_arr" : temp ? temp : @[],
                           @"book_num" : book_num ? book_num : @"",
                           @"sex" : book_sex
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIMerchantBookAdd parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
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
        
        
        
    }];
}

- (void)bookListWithMerchantId:(NSString *)merchant_id
                          page:(NSInteger)pageNum
                          type:(NSInteger)type
                       success:(void (^)(QSBookListReturnData *))success
                          fail:(void (^)(NSError *))fail
{
    
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"count" : [NSString stringWithFormat:@"%d",(int)pageNum],
                           @"type" : type > 0 ? [NSString stringWithFormat:@"%d",(int)type] : @"3",
                           @"order" : @"t.time desc",
                           @"pageNum" : @"10"
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIBookOrderList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSBookListReturnData objectMapping] keyPath:nil];
        QSBookListReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response) {
            
            success(response);
            
        } else {
            
            fail(nil);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(nil);
        
    }];
    
}

- (void)bookDetailWithBookId:(NSString *)book_id
                     success:(void (^)(QSBookDetailReturnData *))success
                        fail:(void (^)(NSError *))fail
{
    NSDictionary *dict = @{
                           @"bookId" : book_id ? book_id : @""
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIBookOrderDetail parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSBookDetailReturnData objectMapping] keyPath:nil];
        QSBookDetailReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)bookDelayWithMerchantId:(NSString *)merchant_id
                        orderId:(NSString *)order_id
                        success:(void (^)(QSAPIModelDict *))success
                           fail:(void (^)(NSError *))fail
{
    
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"id" : order_id ? order_id : @""
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIBookOrderDelay parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            
            success(response);
            
        } else{
            
            fail(nil);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(nil);
    }];
}

@end


