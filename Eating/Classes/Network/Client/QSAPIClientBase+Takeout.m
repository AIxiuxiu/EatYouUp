//
//  QSAPIClientBase+Takeout.m
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Takeout.h"
#import "QSAPIModel+Takeout.h"
#import "QSAPIModel+Food.h"
#import "QSAPIModel+AlixPay.h"

@implementation QSAPIClientBase (Takeout)

- (void)userTakeoutOrderListWithMerchantId:(NSString *)merchant_id
                                      page:(NSInteger)pageNum
                                      type:(NSInteger)type
                                   success:(void (^)(QSTakeoutListReturnData *))success
                                      fail:(void (^)(NSError *))fail
{
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"pageNum" : [NSString stringWithFormat:@"%ld",pageNum],
                           @"type" : type > 0 ? [NSString stringWithFormat:@"%ld",type] : @"3",
                           @"order" : @"t.add_time desc"
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPITakeoutOrderList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSTakeoutListReturnData objectMapping] keyPath:nil];
        QSTakeoutListReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)takeoutOrderDetail:(NSString *)takeout_id
                   success:(void (^)(QSTakeoutDetailReturnData *))success
                      fail:(void (^)(NSError *))fail
{
    NSDictionary *dict = @{
                           @"take_out_id" : takeout_id ? takeout_id : @""
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPITakeoutOrderDetail parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSTakeoutDetailReturnData objectMapping] keyPath:nil];
        QSTakeoutDetailReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)addTakeout:(NSString *)merchant_id
          bookDate:(NSString *)take_out_date
          bookTime:(NSString *)take_out_time
          bookName:(NSString *)take_out_name
         bookPhone:(NSString *)take_out_phone
          bookDesc:(NSString *)take_out_desc
          totalNum:(NSString *)total_num
        totalMoney:(NSString *)total_money
        bookMenArr:(NSArray *)book_menu_arr
        couponList:(NSArray *)coupon_list
           address:(NSString *)address
               sex:(NSString *)sex
           payType:(NSString *)pay_type
           success:(void (^)(QSAPIModelDictddd *))success
              fail:(void (^)(NSError *))fail
{

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (QSFoodDetailData *info in book_menu_arr) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:info.goods_id forKey:@"id"];
        [dict setValue:info.goods_name forKey:@"name"];
        [dict setValue:info.goods_pice forKey:@"pice"];
        [dict setValue:[NSString stringWithFormat:@"%d",(int)(info.localAmount)] forKey:@"num"];
        [temp addObject:dict];
    }
    
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"take_out_date" : take_out_date ? take_out_date : @"",
                           @"take_out_time" : take_out_time ? take_out_time : @"",
                           @"take_out_name" : take_out_name ? take_out_name : @"",
                           @"take_out_phone" : take_out_phone ? take_out_phone : @"",
                           @"take_out_desc" : take_out_desc ? take_out_desc : @"",
                           @"total_num" : total_num ? total_num : @"",
                           @"total_money" : total_money ? total_money : @"",
                           @"book_menu_arr" : temp ? temp : @[],
                           @"coupon_list" : coupon_list ? coupon_list : @[],
                           @"add" : address ? address : @"",
                           @"sex" : sex ? sex : @"1",
                           @"pay_type" : pay_type ? pay_type : @"2"
                           };
        
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPITakeoutOrderAdd parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDictddd objectMapping] keyPath:nil];
        QSAPIModelDictddd *response = (result.dictionary)[[NSNull null]];
        
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

- (void)makePayOrder:(NSString *)indent_id
        online_money:(NSString *)online_money
            pay_type:(NSString *)pay_type
         indent_type:(NSString *)indent_type
     store_card_list:(NSArray *)store_card_list
             success:(void (^)(QSAlixPayTakeoutReturnData *))success
                fail:(void (^)(NSError *))fail
{
    
    NSDictionary *dict = @{
                           @"indent_id" : indent_id ? indent_id : @"",
                           @"online_money" : online_money ? online_money : @"",
                           @"pay_type" : pay_type ? pay_type : @"",
                           @"indent_type" : indent_type ? indent_type : @"",
                           @"store_card_list" : store_card_list ? store_card_list : @[],
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
        
    // . request
    [self.dataClient postPath:QSAPITakeoutPayOrder parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAlixPayTakeoutReturnData objectMapping] keyPath:nil];
        QSAlixPayTakeoutReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.s
        if (success && response) {
            success(response);
        }
        else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///回调
        fail(nil);
        
    }];
}

/**
 *  @author         yangshengmeng, 15-01-06 16:01:28
 *
 *  @brief          储值卡支付
 *
 *  @param dict     储值卡支付的参数
 *  @param callBack 支付的结果
 *
 *  @since          2.0
 */
- (void)prepaidCardPay:(NSDictionary *)dict andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack
{

    ///初步判断参数
    if (nil == dict || (0 >= [dict count])) {
        
        callBack(NO,@"参数无效",@"ER0021");
        return;
        
    }
    
    ///再次封装参数
    NSDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    ///进行支付请求
    [self.dataClient postPath:QSAPITakeoutPayOrder parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAlixPayTakeoutReturnData objectMapping] keyPath:nil];
        QSAlixPayTakeoutReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///数据解析成功
        if (callBack && response.type) {
            
            ///获取模型
            QSAlixPayModel *model = response.payModelList[0];
            
            ///确认支付
            NSDictionary *commitDict = @{@"trade_no" : model.orderNum ? model.orderNum :  @"",
                                         @"out_trade_no" : model.billNum ? model.billNum : @"",
                                         @"status" : @"1"};
            
            [self commitPay:commitDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
                
                ///判断支付结果
                if (flag) {
                    
                    callBack(YES,@"付款成功",response.errorCode);
                    return;
                    
                }
                
                callBack(YES,@"待确认付款",response.errorCode);
                
            }];
            
        } else {
            
            ///解析数据失败
            if (callBack) {
                
                NSLog(@"========================%@",response.errorInfo);
                callBack(NO,response.errorInfo,response.errorCode);
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///网络原因
        if (callBack) {
            
            callBack(NO,[NSString stringWithFormat:@"%@",error],@"ER0021");
            
        }
        
    }];

}

/**
 *  @author             yangshengmeng, 15-01-06 20:01:08
 *
 *  @brief              确认支付结果
 *
 *  @param commitDict   确认参数
 *
 *  @since              2.0
 */
- (void)commitPay:(NSDictionary *)commitDict andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack
{

    ///初步判断参数
    if (nil == commitDict || (0 >= [commitDict count])) {
        
        callBack(NO,@"参数无效",@"ER0021");
        return;
        
    }
    
    ///再次封装参数
    NSDictionary *params = [QSAPIClientBase SetParams:[commitDict mutableCopy]];
        
    ///进行支付请求
    [self.dataClient postPath:QSAPITakeoutPayCommit parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAlixPayServerHeaderReturnData objectMapping] keyPath:nil];
        QSAlixPayServerHeaderReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///数据解析成功
        if (callBack && response.type) {
            
            callBack(YES,@"支付成功",response.errorCode);
            
        } else {
            
            ///解析数据失败
            if (callBack) {
                
                callBack(NO,response.errorInfo,response.errorCode);
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///网络原因
        if (callBack) {
            
            callBack(NO,[NSString stringWithFormat:@"%@",error],@"ER0021");
            
        }
        
    }];

}

@end
