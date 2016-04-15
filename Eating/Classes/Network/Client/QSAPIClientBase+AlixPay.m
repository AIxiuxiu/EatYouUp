//
//  QSAPIClientBase+AlixPay.m
//  Eating
//
//  Created by ysmeng on 14/12/14.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+AlixPay.h"
#import "QSAPI.h"

@implementation QSAPIClientBase (AlixPay)

/**
 *  @author         yangshengmeng, 14-12-14 16:12:45
 *
 *  @brief          将购买信息发送到服务端，服务端生成对应的订单并完成数字签名
 *
 *  @param params   参数字典
 *  @param callBack 请求成功或失败时的回调
 *
 *  @since          2.0
 */
- (void)getRSAOrderFormWithModel:(NSDictionary *)params andCallBack:(void(^)(BOOL resultFlag, QSAlixPayModel *result, NSString *errorInfo, NSString *errorCode))callBack
{
    
    ///判断参数
    if (nil == params || 0 >= [params count]) {
        callBack(NO,nil,@"参数无效",nil);
        return;
    }
    
    ///根据不同的类型，进行不同的接口请求
    NSString *urlString;
    NSString *orderTypeString = [params valueForKey:@"order_type"];
    if ([@"1" isEqualToString:orderTypeString]) {
        
        ///再次支付储值卡购买旧订单请求
        urlString = QSAPIAlixPayOldOrderSign;
        
    } else if ([@"2" isEqualToString:orderTypeString]){
    
        ///外卖时，使用储值卡支付，不足额时的在线支付
        urlString = QSAPITakeoutPayOrder;
    
    } else {
    
        ///购买新的储值卡时订单请求
        urlString = QSAPIAlixPayOrderSign;
    
    }
    
    ///清空类型
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [tempDict removeObjectForKey:@"order_type"];
    
    ///开始请求数据
    NSDictionary *tempParams = [QSAPIClientBase SetParams:tempDict];
        
    [self.dataClient postPath:urlString parameters:tempParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已响应：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAlixPayReturnData objectMapping] keyPath:nil];
        QSAlixPayReturnData *response = (result.dictionary)[[NSNull null]];
                
        ///判断是否生成订单及签名成功
        if (response.type && callBack) {
            
            ///将签名的订单字符串返回
            callBack (YES,response.orderFormList[0],response.errorInfo,response.errorCode);
            
        } else {
            
            ///签名，或者生成订单等不成功：回调服务端的说明信息
            if (callBack) {
                
                callBack(NO,nil,response.errorInfo,response.errorCode);
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///响应失败
        if (callBack) {
            
            callBack(NO,nil,@"网络不给力……请稍等",nil);
            
        }
        
    }];
    
}

/**
 *  @author         yangshengmeng, 15-12-30 18:12:02
 *
 *  @brief          将支付结果回调给服务端，进行双重认证
 *
 *  @param params   参数字典
 *  @param callBack 回调的结果：YES-成功
 *
 *  @since          2.0
 */
- (void)rebackAlixPayResultToServer:(NSDictionary *)params andCallBack:(void (^)(BOOL, NSString *, NSString *))callBack
{

    ///判断参数
    if (nil == params || 0 >= [params count]) {
        callBack(NO,@"参数无效",nil);
        return;
    }
    
    ///开始请求数据
    NSDictionary *tempParams = [QSAPIClientBase SetParams:[params mutableCopy]];
    [self.dataClient postPath:QSAPIAlixPayRebackServer parameters:tempParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端已响应：解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAlixPayServerHeaderReturnData objectMapping] keyPath:nil];
        QSAlixPayServerHeaderReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///判断是否生成订单及签名成功
        if (response.type && callBack) {
            
            ///将签名的订单字符串返回
            callBack (YES,response.errorInfo,response.errorCode);
            
        } else {
            
            ///签名，或者生成订单等不成功：回调服务端的说明信息
            if (callBack) {
                
                callBack(NO,response.errorInfo,response.errorCode);
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///响应失败
        if (callBack) {
            
            callBack(NO,@"网络不给力……请稍等",nil);
            
        }
        
    }];

}

@end
