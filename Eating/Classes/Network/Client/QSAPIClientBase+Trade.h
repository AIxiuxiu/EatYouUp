//
//  QSAPIClientBase+Trade.h
//  Eating
//
//  Created by System Administrator on 12/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSTradeListReturnData;
@interface QSAPIClientBase (Trade)

- (void)userTradeList:(NSInteger)page
              success:(void(^)(QSTradeListReturnData *response))success
                 fail:(void(^)(NSError *error))fail;

@end
