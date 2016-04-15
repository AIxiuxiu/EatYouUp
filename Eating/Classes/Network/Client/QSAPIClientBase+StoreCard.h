//
//  QSAPIClientBase+StoreCard.h
//  Eating
//
//  Created by Jay on 14-12-25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSStoreCardListReturnData;
@interface QSAPIClientBase (StoreCard)

- (void)userStoreCardList:(NSString *)merchant_id
                      key:(NSString *)key
                 page_num:(NSString *)page_num
                orderType:(NSString *)orderType
                  success:(void(^)(QSStoreCardListReturnData *response))success
                     fail:(void(^)(NSError *error))fail;
@end
