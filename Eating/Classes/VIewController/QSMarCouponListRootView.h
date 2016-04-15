//
//  QSMarCouponListRootView.h
//  Eating
//
//  Created by ysmeng on 14/12/3.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMarCouponListRootView : UIView

/**
 *  @author         yangshengmeng, 15-01-05 11:01:57
 *
 *  @brief          创建一个优惠券列表
 *
 *  @param frame    列表的大小和位置
 *  @param listType 列表类型
 *  @param params   参数
 *  @param callBack 请求成功或者失败时的回调
 *
 *  @return         返回一个优惠券列表
 *
 *  @since          2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCouponListType:(GET_COUPONTLIST_TYPE)listType andParams:(NSDictionary *)params andCallBack:(void (^)(NSString *marchantName,NSString *marchantID, NSString *volumeID,NSString *couponSubID,MYLUNCHBOX_COUPON_TYPE couponType,MYLUNCHBOX_COUPON_STATUS couponStatus))callBack;

/**
 *  @author yangshengmeng, 15-01-07 18:01:34
 *
 *  @brief  提供给外部使用的主动头部刷新
 *
 *  @since  2.0
 */
- (void)couponListHeaderRefresh;

/**
 *  @author         yangshengmeng, 15-01-05 09:01:35
 *
 *  @brief          根据不同的参数类型，请求不同的数据
 *
 *  @param params   参数
 *
 *  @since          2.0
 */
- (void)couponListSearchRefresh:(NSDictionary *)params;

@end
