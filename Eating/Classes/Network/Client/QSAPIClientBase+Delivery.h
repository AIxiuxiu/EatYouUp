//
//  QSAPIClientBase+Delivery.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSDeliveryListReutrnData;
@class QSDeliveryDetailData;
@interface QSAPIClientBase (Delivery)

- (void)userDeliveryListSuccess:(void(^)(QSDeliveryListReutrnData *response))success
                           fail:(void(^)(NSError *error))fail;

- (void)addDelivery:(QSDeliveryDetailData *)data
               success:(void(^)(QSAPIModel *response))success
                  fail:(void(^)(NSError *error))fail;

- (void)updateDelivery:(QSDeliveryDetailData *)data
               success:(void(^)(QSAPIModel *response))success
                  fail:(void(^)(NSError *error))fail;


- (void)deleteDelivery:(NSString *)delivery_id
               success:(void(^)(QSAPIModel *response))success
                  fail:(void(^)(NSError *error))fail;


@end
