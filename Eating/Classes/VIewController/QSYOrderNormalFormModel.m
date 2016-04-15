//
//  QSYOrderNormalFormModel.m
//  Eating
//
//  Created by ysmeng on 14/12/12.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSYOrderNormalFormModel.h"

@implementation QSYOrderNormalFormModel

/**
 *  @author         yangshengmeng, 14-12-12 21:12:31
 *
 *  @brief          反归档的初始化方法
 *
 *  @param aDecoder 解档器
 *
 *  @return         返回当前类的实例
 *
 *  @since          2.0
 */
#pragma mark - 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.marchantID = [aDecoder decodeObjectForKey:@"marchantID"];
        self.totalPrice = [aDecoder decodeObjectForKey:@"totalPrice"];
        self.buyDate = [aDecoder decodeObjectForKey:@"buyDate"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.payType = [aDecoder decodeObjectForKey:@"payType"];
        self.orderFormType = [aDecoder decodeObjectForKey:@"orderFormType"];
        self.userPhone = [aDecoder decodeObjectForKey:@"userPhone"];
        self.orderFormTitle = [aDecoder decodeObjectForKey:@"orderFormTitle"];
        self.goodsList = [aDecoder decodeObjectForKey:@"goodsList"];
        self.promotionList = [aDecoder decodeObjectForKey:@"promotionList"];
        self.couponList = [aDecoder decodeObjectForKey:@"couponList"];
        self.prepaidCardList = [aDecoder decodeObjectForKey:@"prepaidCardList"];
        
    }
    
    return self;
}

/**
 *  @author yangshengmeng, 14-12-12 20:12:27
 *
 *  @brief  返回订单参数字典
 *
 *  @return 返回订单参数字典
 *
 *  @since  2.0
 */
#pragma mark - 返回订单post时的参数字典
- (NSDictionary *)getOrderFormPostParamsDictionary
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    /*
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
     *                  "promotion_id": "20"
     *              }
     *          ],
     *      "coupon":
     *          [
     *              {
     *                  "coupon_id": "45"
     *              }
     *          ],
     *      "store_card":
     *          [
     *              {
     *                  "store_card_id": "98"
     *              }
     *          ]
     *  }
     *
     */
    
    ///头信息
    [tempDict setObject:@"0" forKey:@"order_type"];
    
    ///商户ID
    if (self.marchantID) {
        [tempDict setObject:self.marchantID forKey:@"merchant_id"];
    }
    
    ///总价
    if (self.totalPrice) {
        [tempDict setObject:self.totalPrice forKey:@"total_money"];
    }
    
    ///当前提交订单的用户ID
    if (self.userID) {
        [tempDict setObject:self.userID forKey:@"user_id"];
    }
    
    ///支付方式
    if (self.payType) {
        [tempDict setObject:self.payType forKey:@"pay_type"];
    }
    
    ///订单类型
    if (self.orderFormType) {
        [tempDict setObject:self.orderFormType forKey:@"indent_type"];
    }
    
    ///当前购买使用的手机号码
    if (self.userPhone) {
        [tempDict setObject:self.userPhone forKey:@"buy_phone"];
    }
    
    ///订单大标题
    if (self.orderFormTitle) {
        [tempDict setObject:self.orderFormTitle forKey:@"desc"];
    }
    
    ///下订日期
    if (self.buyDate) {
        [tempDict setObject:self.buyDate forKey:@"indent_time"];
    }
    
    ///货物列表
    if (self.goodsList && [self.goodsList count] > 0) {
        [tempDict setObject:self.goodsList forKey:@"goods_list"];
    }
    
    ///促销优惠列表
    if (self.promotionList && [self.promotionList count] > 0) {
        [tempDict setObject:self.promotionList forKey:@"promotion"];
    }
    
    ///优惠券列表
    if (self.couponList && [self.couponList count] > 0) {
        [tempDict setObject:self.couponList forKey:@"coupon_id"];
    }
    
    ///储值卡列表
    if (self.prepaidCardList && [self.prepaidCardList count] > 0) {
        [tempDict setObject:self.prepaidCardList forKey:@"store_card"];
    }
    
    ///返回一个不可变字典，停止数据被修改
    return [NSDictionary dictionaryWithDictionary:tempDict];
}

/**
 *  @author yangshengmeng, 15-01-07 09:01:55
 *
 *  @brief  在线支付和储值卡支付时，老订单支付参数封装
 *
 *  @return 返回参数字典
 *
 *  @since  2.0
 */
- (NSDictionary *)getOldOnlinePayAndPrecardPayOrderFormPostParams
{

    /**
     *  user_id int 用户id
     *  indent_id int 订单id
     *  online_money float 在线支付的
     *  pay_type int 支付类型
     *  indent_type int 订单类型
     *  store_card_list array
     *      结构 array(
     *          store_id  int 用户领取到的储值卡id，
     *          use_val  float 使用的价格
     *          limit_val  float 使用后剩余的价格
     *          name string 储值卡的名字
     *      )
     *  store_card_money float 储值卡要给的总价
     */
    NSDictionary *tempDict = @{@"order_type" : @"2",
                               @"indent_id" : self.orderID,
                               @"online_money" : self.totalPrice,
                               @"pay_type" : self.payType,
                               @"indent_type" : self.orderFormType,
                               @"store_card_list" : self.prepaidCardList,
                               @"store_card_money" : [self.prepaidCardList[0] valueForKey:@"use_val"]};
    
    return tempDict;

}

/**
 *  @author yangshengmeng, 15-12-30 16:12:53
 *
 *  @brief  返回老订单支付的参数
 *
 *  @return 返回参数字典
 *
 *  @since  2.0
 */
- (NSDictionary *)getOldOrderFormPostParamsDictionary
{

    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    ///头信息
    [tempDict setObject:@"1" forKey:@"order_type"];
    
    ///订单号
    [tempDict setObject:self.orderID forKey:@"indent_id"];
    
    ///总价
    [tempDict setObject:self.totalPrice forKey:@"online_money"];
    
    ///支付方式
    [tempDict setObject:self.payType forKey:@"pay_type"];
    
    ///用户ID
    [tempDict setObject:self.userID forKey:@"user_id"];
    
    return [NSDictionary dictionaryWithDictionary:tempDict];

}

/**
 *  @author yangshengmeng, 14-12-12 21:12:01
 *
 *  @brief          归档
 *
 *  @param aCoder   归档器
 *
 *  @since          2.0
 */
#pragma mark - 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.marchantID forKey:@"marchantID"];
    [aCoder encodeObject:self.totalPrice forKey:@"totalPrice"];
    [aCoder encodeObject:self.buyDate forKey:@"buyDate"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.payType forKey:@"payType"];
    [aCoder encodeObject:self.orderFormType forKey:@"orderFormType"];
    [aCoder encodeObject:self.userPhone forKey:@"userPhone"];
    [aCoder encodeObject:self.orderFormTitle forKey:@"orderFormTitle"];
    [aCoder encodeObject:self.goodsList forKey:@"goodsList"];
    [aCoder encodeObject:self.promotionList forKey:@"promotionList"];
    [aCoder encodeObject:self.couponList forKey:@"couponList"];
    [aCoder encodeObject:self.prepaidCardList forKey:@"prepaidCardList"];
    
}

@end