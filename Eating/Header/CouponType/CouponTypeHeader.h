//
//  CouponTypeHeader.h
//  Eating
//
//  Created by ysmeng on 14/12/9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#ifndef Eating_CouponTypeHeader_h
#define Eating_CouponTypeHeader_h

//视图类型
typedef enum
{
    DEFAULT_MCT = 0,        //!<无效优惠卷类型
    PREPAIDCARD_MCT,        //!<储值卡
    FASTENING_VOLUME_MCT,   //!<折扣卷
    EXCHANGE_VOLUME_MCT,    //!<兑换卷
    VOUCHER_MCT,            //!<代金卷
    TIMELIMITEDOFF_MCT,     //!<限时免费
    FOODOFF_MCT,            //!<菜品优惠
    MEMBERDISCOUNT_MCT      //!<会员优惠
}MYLUNCHBOX_COUPON_TYPE;

//视图状态
typedef enum
{
    DEFAULT_MCS = 0,    //!<优惠卷状态：无效状态
    REFUND_MCS,         //!<退款状态
    USING_MCS,          //!<已使用状态
    EXPIRED_MCS,        //!<已过期状态
    
    REFUNDING_MCS,      //!<退款中状态
    REFUNDED_MCS        //!<已退款状态
    
}MYLUNCHBOX_COUPON_STATUS;

//列表类型
typedef enum
{
    DEFAULT_GCT = 0,                    //!<默认列表请求类型
    RECOMMENT_COUPONLIST_GCT,           //!<推荐优惠列表
    PREPAIDCARD_COUPONLIST_GCT,         //!<储值卡列表
    MYLUNCHBOX_COUPONLIST_UNUSE_CGT,    //!<我的餐盒：可使用优惠券列表
    MYLUNCHBOX_COUPONLIST_USED_CGT,     //!<我的餐盒：已使用优惠券列表
    OTHER_COUPONLIST_GCT,               //!<促销和优惠券列表
    
    MERCHANT_COUPONLIST_CGT,            //!<指定商户的所有优惠券列表
    MERCHANT_VOLUME_COUPONLIST_CGT,     //!<指定商户的优惠券列表
    MERCHANT_PREPAIDCARD_COUPONLIST_CGT //!<指定商户的储值卡列表
    
}GET_COUPONTLIST_TYPE;                  //!<商户优惠列表类型

#endif
