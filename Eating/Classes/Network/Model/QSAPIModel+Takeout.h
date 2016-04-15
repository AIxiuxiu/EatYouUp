//
//  QSAPIModel+Takeout.h
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Takeout)

@end


@interface QSTakeoutListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@class QSTakeoutDetailDataCouponInfoDataModel;
@interface QSTakeoutDetailData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *takeout_id;
@property (nonatomic, copy) NSString *take_out_num;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_phone;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *price_count;
@property (nonatomic, copy) NSString *take_num_count;
@property (nonatomic, copy) NSString *take_outcol;
@property (nonatomic, copy) NSString *take_time;
@property (nonatomic, copy) NSString *pro_time;
@property (nonatomic, copy) NSString *out_time;
@property (nonatomic, copy) NSString *get_time;
@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *take_out_name;
@property (nonatomic, copy) NSString *take_out_type;
@property (nonatomic, copy) NSString *favorable_id;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *pay_status;
@property (nonatomic, copy) NSString *add;
@property (nonatomic, copy) NSString *take_out_status;
@property (nonatomic, copy) NSString *super_need;
@property (nonatomic, copy) NSString *take_num;
@property (nonatomic, copy) NSString *take_out_date;
@property (nonatomic, copy) NSString *take_out_time;
@property (nonatomic, copy) NSString *take_out_phone;
@property (nonatomic, copy) NSString *common_id;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *customer_id;
@property (nonatomic, copy) NSString *merchant_name;
@property (nonatomic, strong) NSMutableDictionary *merchant_msg;

@property (nonatomic, strong) NSMutableDictionary *detail;
@property (nonatomic, copy) NSString *merchant_call;

@property (nonatomic,retain) QSTakeoutDetailDataCouponInfoDataModel *couponInfo;//!<本外卖订单中使用的优惠券信息

@end

@interface QSTakeoutDetailDataCouponInfoDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *couponID;      //!<优惠券ID
@property (nonatomic,copy) NSString *couponName;    //!<优惠券名字
@property (nonatomic,copy) NSString *couponPrice;   //!<优惠券面额

@end

@interface QSTakeoutOrderListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QSTakeoutDetailReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) QSTakeoutDetailData *data;

@end
