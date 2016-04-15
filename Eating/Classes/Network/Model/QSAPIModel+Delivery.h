//
//  QSAPIModel+Delivery.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Delivery)

@end


@interface QSDeliveryListReutrnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QSDeliveryDetailData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *delivery_id;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *other_phone;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *ad_time;
@property (nonatomic, copy) NSString *modify_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *pro;
@property (nonatomic, copy) NSString *city;

@end