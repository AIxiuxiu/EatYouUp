//
//  QSAPIModel+CouponDetail.h
//  Eating
//
//  Created by ysmeng on 14/12/12.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (CouponDetail)

@end

/**
 *  @author yangshengmeng, 15-01-08 01:01:55
 *
 *  @brief  储值卡退款时返回的数据
 *
 *  @since  2.0
 */
@interface QSPrepaidCardRefundReturdData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码
@property (nonatomic,retain) id detailModel;            //!<退款说明信息

@end

@class QSYCouponDetailDataModel;
@interface QSYCouponDetailReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码
@property (nonatomic,retain) QSYCouponDetailDataModel *detailModel;//!<商户包信息

@end

/**
 *  @author yangshengmeng, 14-12-12 13:12:14
 *
 *  @brief  优惠券详情信息
 *
 *  @since  2.0
 */
@class QSYCouponMoreDetailInfoDataModel;
@class QSYMarchantBaseInfoDataModel;
@class QSYCouponPersonDataModel;
@interface QSYCouponDetailDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *couponID;//!<优惠券ID
@property (nonatomic,copy) NSString *couponName;//!<优惠名称
@property (nonatomic,copy) NSString *couponType;//!<优惠卷大类
@property (nonatomic,copy) NSString *couponSubType;//!<优惠券小类
@property (nonatomic,copy) NSString *des;//!<优惠说明
@property (nonatomic,copy) NSString *startTime;//!<活动开始时间
@property (nonatomic,copy) NSString *lastTime;//!<有效期至
@property (nonatomic,copy) NSString *limitedTimeDiscount;//!<限时折扣
@property (nonatomic,copy) NSString *foodOfferDiscount;//菜品优惠折扣/折扣券的折扣
@property (nonatomic,copy) NSString *foodImage;//!<菜品图片
@property (nonatomic,copy) NSString *vipDiscount;//!<会员优惠折扣
@property (nonatomic,copy) NSString *coucherValue;//!<代金券面额
@property (nonatomic,copy) NSString *prepaidCardBuyPrice;//!<储值卡购买的价格
@property (nonatomic,copy) NSString *prepaidCardValuePrice;//!<储值卡价值
@property (nonatomic,copy) NSString *sumNumOfCoupon;//!<优惠券总数
@property (nonatomic,copy) NSString *leftNumOfCoupon;//!<还剩下多少优惠券
@property (nonatomic,retain) NSArray *cardInfoList;//!<优惠卡的附加说明信息
@property (nonatomic,assign) BOOL currentUserInterestedStatus;//!<当前用户是否已点赞

@property (nonatomic,retain) NSArray *foodImageList;//!<菜品优惠的时候，每一个菜品优惠信息数组

///更详情信息
@property (nonatomic,retain) QSYCouponMoreDetailInfoDataModel *moreDetailInfoModel;

///优惠券发行商户的基本信息
@property (nonatomic,retain) QSYMarchantBaseInfoDataModel *marchantBaseInfoModel;

///个人领取的优惠券信息
@property (nonatomic,retain) QSYCouponPersonDataModel *personCouponInfoModel;

@end

/**
 *  @author wangshupeng, 14-12-27 11:12:05
 *
 *  @brief  菜品优惠：每一个菜品的优惠信息数据模型
 *
 *  @since  2.0
 */
@interface QSYFoodOfferFoodDiscountDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *foodID;//!<菜品ID
@property (nonatomic,copy) NSString *foodTitle;//!<菜品标题
@property (nonatomic,copy) NSString *foodOriginalPrice;//!<菜品原价
@property (nonatomic,copy) NSString *foodImageURLString;//!<菜品图片地址

@end

/**
 *  @author yangshengmeng, 14-12-12 13:12:36
 *
 *  @brief  优惠其他更详情的信息：优惠详情、使用须知等
 *
 *  @since  2.0
 */
@interface QSYCouponMoreDetailInfoDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *detailID;//!<详情ID
@property (nonatomic,copy) NSString *marchantDes;//!<商家描述
@property (nonatomic,copy) NSString *activityDes;//!<商家活动描述
@property (nonatomic,copy) NSString *favourableDes;//!<优惠说明
@property (nonatomic,copy) NSString *subscribeDes;//!<预定流程说明
@property (nonatomic,copy) NSString *useNotice;//!<使用规则

@end

/**
 *  @author yangshengmeng, 14-12-12 13:12:09
 *
 *  @brief  优惠券的发生商户基本信息
 *
 *  @since  2.0
 */
@interface QSYMarchantBaseInfoDataModel : NSObject<QSObjectMapping>

///商户的基本信息
@property (nonatomic,copy) NSString *marID;//!<商户ID
@property (nonatomic,copy) NSString *marName;//!<商户名称
@property (nonatomic,copy) NSString *marIcon;//!<商户图标
@property (nonatomic,copy) NSString *marNickName;//!<商昵称
@property (nonatomic,copy) NSString *merAddress;//!<商户地址
@property (nonatomic,copy) NSArray *marFreeServicesList;//!<商家提供服务列表
@property (nonatomic,copy) NSString *merchantLongitude;//!<商户的经度
@property (nonatomic,copy) NSString *merchantLatitude;//!<商户的纬度

@end

/**
 *  @author yangshengmeng, 14-12-23 10:12:25
 *
 *  @brief  优惠券个人相关信息数据模型
 *
 *  @since  2.0
 */
@interface QSYCouponPersonDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *userCardID;//!<用户领用的ID
@property (nonatomic,copy) NSString *serielNumber;//!<序列号
@property (nonatomic,copy) NSString *dynamicPassWord;//!<动态密码
@property (nonatomic,copy) NSString *valuePrice;//!<价值
@property (nonatomic,copy) NSString *leftValue;//!<剩余价值

@end