//
//  QSAPIModel+Coupon.h
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Coupon)

@end


@interface QSCouponListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QSCouponDetailData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *coupon_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_v_type;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *goods_at_num;
@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, copy) NSString *merchant_name;
@property (nonatomic, copy) NSString *coup_logo;
@property (nonatomic, copy) NSString *coup_price;
@property (nonatomic, strong) NSMutableArray *coup_goods_list;

@end