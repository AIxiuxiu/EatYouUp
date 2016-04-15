//
//  QSAPIModel+CouponList.h
//  Eating
//
//  Created by ysmeng on 14/12/10.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (CouponList)

@end

/**
 *  @author yangshengmeng, 14-12-10 11:12:26
 *
 *  @brief  服务端返回外层数据：成功/失败
 *
 *  @since 2.0
 */
@class QSMarchantListReturnData;
@interface QSMarchantCouponListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码
@property (nonatomic,retain) QSMarchantListReturnData *recordModel;//!<商户包信息

@end

/**
 *  @author yangshengmeng, 14-12-10 17:12:31
 *
 *  @brief  商户包信息数据
 *
 *  @since  2.0
 */
@interface QSMarchantListReturnData : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *totalPage;       //!<总页数
@property (nonatomic,copy) NSString *totalNum;        //!<目前有优惠活动的商户总数
@property (nonatomic,copy) NSString *beforePageNum;   //!<前一页的页码
@property (nonatomic,copy) NSString *currentPageNum;  //!<当前页的页码
@property (nonatomic,copy) NSString *nextPageNum;     //!<下一页的页码
@property (nonatomic,retain) NSMutableArray *marList; //!<商户列表

@end

/**
 *  @author yangshengmeng, 14-12-10 12:12:14
 *
 *  @brief  每个商户的信息
 *
 *  @since 2.0f
 */
@interface QSMarchantBaseInfoDataModel : NSObject<QSObjectMapping>

///商户的基本信息
@property (nonatomic,copy) NSString *marID;//!<商户ID
@property (nonatomic,copy) NSString *marName;//!<商户名称
@property (nonatomic,copy) NSString *marIcon;//!<商户图标
@property (nonatomic,copy) NSString *marNickName;//!<商昵称
@property (nonatomic,copy) NSString *marLongitude;//!<商户所在经度
@property (nonatomic,copy) NSString *marLatitude;//!<商户所在纬度
@property (nonatomic,copy) NSString *marRemarkScore;//!<商户评分
@property (nonatomic,strong) NSMutableArray *couponList;//!<所有优惠卷集合数组
@property (nonatomic,copy) NSString *marAddress;//!<商户地址

///不同优惠信息列表
@property (nonatomic, retain) NSMutableArray *prepaidCardList; //!<储值卡列表
@property (nonatomic, retain) NSMutableArray *limitedTimeOfferList; //!<限时优惠列表
@property (nonatomic, retain) NSMutableArray *foodOfferList; //!<菜品优惠列表
@property (nonatomic, retain) NSMutableArray *memberDiscountList; //!<会员优惠列表
@property (nonatomic, retain) NSMutableArray *voucherList; //!<代金券列表
@property (nonatomic, retain) NSMutableArray *fasteningVolumeList; //!<折扣券列表
@property (nonatomic, retain) NSMutableArray *exchangeVolumeList; //!<菜品兑换券列表
@property (nonatomic,retain) NSMutableArray *myCouponList;//!<个人的优惠券列表

@end

/**
 *  @author yangshengmeng, 14-12-10 12:12:12
 *
 *  @brief                  优惠卷的基本信息
 *
 *  @param couponType       优惠券大类：2: 促销优惠   3: 优惠卷  5: 储值卡
 *  @param couponSubType    优惠券小类：优惠促销-1 限时优惠   2 菜品优惠 3 vip优惠
 *                                    优惠卷  -1 代金卷    2 折扣卷   3 菜品兑换券
 *
 *  @since                  2.0
 */
@interface QSMarCouponDetailDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *couponID;//!<优惠券ID
@property (nonatomic,copy) NSString *couponSubID;//!<优惠券子ID
@property (nonatomic,copy) NSString *couponName;//!<优惠名称
@property (nonatomic,copy) NSString *couponType;//!<优惠卷大类
@property (nonatomic,copy) NSString *couponSubType;//!<优惠券小类
@property (nonatomic,copy) NSString *currentUserCouponStatues;//!<当前用户此张券的状态
@property (nonatomic,copy) NSString *des;//!<优惠说明
@property (nonatomic,copy) NSString *lastTime;//!<有效期至
@property (nonatomic,copy) NSString *limitedTimeDiscount;//!<限时折扣
@property (nonatomic,copy) NSString *foodOfferDiscount;//菜品优惠折扣/折扣券的折扣
@property (nonatomic,copy) NSString *foodImage;//!<菜品图片
@property (nonatomic,copy) NSString *vipDiscount;//!<会员优惠折扣
@property (nonatomic,copy) NSString *coucherValue;//!<代金券面额
@property (nonatomic,copy) NSString *prepaidCardBuyPrice;//!<集会卡购买的价格
@property (nonatomic,copy) NSString *prepaidCardValuePrice;//!<储值卡价值
@property (nonatomic,copy) NSString *sumNumOfCoupon;//!<优惠券总数
@property (nonatomic,copy) NSString *leftNumOfCoupon;//!<还剩下多少优惠券
@property (nonatomic,copy) NSString *couponStatus;//!<优惠券状态

/**
 *  @author yangshengmeng, 14-12-11 15:12:24
 *
 *  @brief  根据优惠券大小类，格式化为代码定义的优惠券类型并返回类型编码
 *
 *  @param  bigType 优惠券类型
 *  @param  subType 优惠类小类
 *
 *  @return 返回编码实现中的优惠券编码
 *
 *  @since  2.0
 */
- (MYLUNCHBOX_COUPON_TYPE)formatCouponTypeWithType;

/**
 *  @author yangshengmeng, 14-12-12 09:12:13
 *
 *  @brief  返回当前优惠的状态：可退款、已使用、已过期
 *
 *  @return 返回状态代码
 *
 *  @since  2.0
 */
- (MYLUNCHBOX_COUPON_STATUS)getCouponCurrentStatus;

@end