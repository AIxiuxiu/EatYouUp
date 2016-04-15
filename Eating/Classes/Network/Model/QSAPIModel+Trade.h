//
//  QSAPIModel+Trade.h
//  Eating
//
//  Created by System Administrator on 12/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Trade)

@end

@interface QSTradeListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QSTradeDetailData : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *trade_id;
@property (nonatomic,copy) NSString *parent_id;
@property (nonatomic,copy) NSString *order_num;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *pay_num;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *bill_num;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *pay_time;
@property (nonatomic,copy) NSString *indent_type;//!<订单类型
@property (nonatomic,copy) NSString *indent_id; //!<说明

@property (nonatomic,copy) NSString *merchantID;//!<商户ID

@end
