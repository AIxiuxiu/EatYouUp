//
//  QSAPIModel+AlixPay.h
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (AlixPay)

@end

/**
 *  @author yangshengmeng, 15-12-30 18:12:40
 *
 *  @brief  支付时返回的第一层数据模型
 *
 *  @since  2.0
 */
@interface QSAlixPayServerHeaderReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码

@end

@class QSAlixPayModel;
/**
 *  @author yangshengmeng, 14-12-14 14:12:58
 *
 *  @brief  服务端返回数据的头信息
 *
 *  @since  2.0
 */
@interface QSAlixPayReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码
@property (nonatomic,retain) NSArray *orderFormList;    //!<商户包信息

@end

@interface QSAlixPayTakeoutReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码
@property (nonatomic,retain) NSArray *payModelList;  //!<商户包信息
@property (nonatomic,retain) QSAlixPayModel *orderModel;//!<再次支付时返回的模型

@end

/**
 *  @author yangshengmeng, 14-12-14 15:12:08
 *
 *  @brief  数字签名订单数据模型
 *
 *  @since  2.0
 */
@class QSOrderFormFromServerModel;
@interface QSAlixPayModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *orderFormID;       //!<服务端返回的订单ID
@property (nonatomic,copy) NSString *signedRSAString;   //!<服务端返回已经数字签名的订单字符串
@property (nonatomic,copy) NSString *priKey;            //!<私钥
@property (nonatomic,copy) NSString *priPKCS8Key;       //!<加密的私钥
@property (nonatomic,copy) NSString *orderNum;          //!<内部订单编号
@property (nonatomic,copy) NSString *billNum;           //!<支付宝的订单号
@property (nonatomic,copy) void(^alixpayCallBack)(NSString *payResultCode,NSString *payResultInfo);                                     //!<支付宝支付情况的回调

///客户端答名时，使用的模型
@property (nonatomic,retain) QSOrderFormFromServerModel *orderModel;//!<客户端自行签名时的数据模型

@end

@interface QSOrderFormFromServerModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *partner;       //!<商户ID
@property (nonatomic,copy) NSString *seller_id;     //!<入帐ID
@property (nonatomic,copy) NSString *out_trade_no;  //!<订单号
@property (nonatomic,copy) NSString *subject;       //!<商品标题
@property (nonatomic,copy) NSString *body;          //!<商品描述
@property (nonatomic,copy) NSString *total_fee;     //!<订单价格
@property (nonatomic,copy) NSString *notify_url;    //!<服务端回调URL
@property (nonatomic,copy) NSString *service;       //!<服务URL
@property (nonatomic,copy) NSString *_input_charset;//!<编码格式：UTF-8
@property (nonatomic,copy) NSString *it_b_pay;      //!<
@property (nonatomic,copy) NSString *show_url;      //!<

@end