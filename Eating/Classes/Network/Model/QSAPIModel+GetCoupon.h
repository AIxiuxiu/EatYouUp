//
//  QSAPIModel+GetCoupon.h
//  Eating
//
//  Created by ysmeng on 14/12/17.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (GetCoupon)

@end

/**
 *  @author yangshengmeng, 14-12-12 12:12:03
 *
 *  @brief  领取优惠券是否成功的返回结果
 *
 *  @return 返回mapping的结果
 *
 *  @since  2.0
 */
@interface QSGetCouponReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码

@end