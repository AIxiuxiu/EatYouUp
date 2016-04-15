//
//  QSYOrderNormalFormModel.h
//  Eating
//
//  Created by ysmeng on 14/12/12.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{

    DEFAULT_ORDERPAY_COPT = 0,              //!<默认的支付：储值卡新增支付
    BUY_PREPAIDCARD_PAYAGENT_COPT,          //!<储值卡订单再支付
    
    TAKEOUT_ONLINEPAY_PAYAGENT_COPT,        //!<外卖：在线支付时，不足额时，支付宝支付
    TAKEOUT_PREPAIDCARDPAY_PAYAGENT_COPT    //!<外卖：储值卡支付时，储值卡支付额不足，需要支付宝支付

}CUSTOM_ORDER_PAY_TYPE;

/**
 *  客户端订单信息
 *
 *  @param  merchant_id 商户ID
 *  @param  total_money 商品总价 = 商品数量 * 商品单价(现在的实际价格)
 *  @param  user_id     用户ID
 *  @param  pay_type    支付方式:1-在线   2-货到付款  3-储值：由于本列表只是购买储值卡，在2.0版本内只需要传在线支付即可
 *  @param  indent_type 订单类型：1-下订   2-外卖    3-储值卡购买
 *  @param  buy_phone   当前购买者手机号
 *  @param  desc        订单标题
 *  @param  indent_time 订单生成时的时间
 *
 *  @param  goods_list  货物数组
 *  @param  goods_list  items   goods_id    货物ID
 *  @param  goods_list  items   goods_name  货物名称
 *  @param  goods_list  items   goods_num   购买数量
 *  @param  goods_list  items   goods_price 货物原单价
 *  @param  goods_list  items   goods_sale_money    实际单价
 *
 *  @param  promotion   促销优惠数组
 *  @param  promotion   items   promotion_id
 *
 *  @param  coupon      优惠券数组
 *  @param  coupon      items   coupon_id
 *
 *  @param  store_card   储值卡数组
 *  @param  store_card   items   store_card_id
 *
 *  参数json
 *  {
 *      "merchant_id": "109",
 *      "total_money": "100.00",
 *      "user_id": "320",
 *      "pay_type": "1",
 *      "indent_type": "3",
 *      "buy_phone": "13660581329",
 *      "desc": "大订单标题",
 *      "indent_time": "384929343",
 *      "goods_list": 
 *          [
 *              {
 *                  "goods_id": "2",
 *                  "goods_name": "储值卡05",
 *                  "goods_num": "2",
 *                  "goods_price": "50.00",
 *                  "goods_sale_money": "50.00"
 *              }
 *          ],
 *      "promotion": 
 *          [
 *              {
 *                  "promotion_id" : "20",
 *                  "promotion_name" : @"西提￥50.00优惠券",
 *                  "promotion_value" : @"50.00"
 *              }
 *          ],
 *      "coupon": 
 *          [
 *              {
 *                  "coupon_id": "45"
 *                  "coupon_name" : @"西提￥50.00优惠券",
 *                  "coupon_value" : @"50.00"
 *              }
 *          ],
 *      "store_card": 
 *          [
 *              {
 *                  "store_card_id": "98"
 *                  "store_card_name" : @"西提￥50.00优惠券",
 *                  "store_card_value" : @"50.00",
 *              }
 *          ]
 *  }
 *
 */
@interface QSYOrderNormalFormModel : NSObject<NSCoding>

@property (nonatomic,assign) CUSTOM_ORDER_PAY_TYPE formPayType;  //!<支付类型
@property (nonatomic,copy) NSString *orderID;                //!<订单ID
@property (nonatomic,copy) NSString *orderNumber;            //!<订单号
@property (nonatomic,copy) NSString *marchantID;             //!<商户ID
@property (nonatomic,copy) NSString *totalPrice;             //!<总价
@property (nonatomic,copy) NSString *buyDate;                //!<购买日期
@property (nonatomic,copy) NSString *userID;                 //!<当前用户ID
@property (nonatomic,copy) NSString *payType;                //!<支付方式
@property (nonatomic,copy) NSString *orderFormType;          //!<订单类型
@property (nonatomic,copy) NSString *userPhone;              //!<当前购买使用的手机号码
@property (nonatomic,copy) NSString *orderFormTitle;         //!<订单标题：是指整个订单的标题
@property (nonatomic,retain) NSMutableArray *goodsList;      //!<货物列表
@property (nonatomic,retain) NSMutableArray *promotionList;  //!<所使用的促销优惠列表
@property (nonatomic,retain) NSMutableArray *couponList;     //!<所使用的优惠券列表
@property (nonatomic,retain) NSMutableArray *prepaidCardList;//!<所使用的储值卡列表

/**
 *  @author yangshengmeng, 14-12-12 20:12:27
 *
 *  @brief  返回订单参数字典
 *
 *  @return 返回订单参数字典
 *
 *  @since  2.0
 */
- (NSDictionary *)getOrderFormPostParamsDictionary;

/**
 *  @author yangshengmeng, 15-12-30 16:12:53
 *
 *  @brief  返回老订单支付的参数
 *
 *  @return 返回参数字典
 *
 *  @since  2.0
 */
- (NSDictionary *)getOldOrderFormPostParamsDictionary;

/**
 *  @author yangshengmeng, 15-01-07 09:01:55
 *
 *  @brief  在线支付和储值卡支付时，老订单支付参数封装
 *
 *  @return 返回参数字典
 *
 *  @since  2.0
 */
- (NSDictionary *)getOldOnlinePayAndPrecardPayOrderFormPostParams;

@end
