//
//  QSAPIClientBase+AlixPay.h
//  Eating
//
//  Created by ysmeng on 14/12/14.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+AlixPay.h"

@interface QSAPIClientBase (AlixPay)

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
- (void)getRSAOrderFormWithModel:(NSDictionary *)params andCallBack:(void(^)(BOOL resultFlag, QSAlixPayModel *result, NSString *errorInfo, NSString *errorCode))callBack;

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
- (void)rebackAlixPayResultToServer:(NSDictionary *)params andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

@end
