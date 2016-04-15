//
//  QSAPIClientBase+Food.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSFoodListReturnData;
@class QSFoodDetailReturnData;
@interface QSAPIClientBase (Food)

- (void)foodListWithMerchantId:(NSString *)merchant_id
                       pageNum:(NSInteger)pageNum
                           tag:(NSString *)tag
                        flavor:(NSString *)flavor
                          pice:(NSString *)pice
                       success:(void(^)(QSFoodListReturnData *response))success
                          fail:(void(^)(NSError *error))fail;

- (void)foodDetailWithGoodsId:(NSString *)goods_id
                      success:(void(^)(QSFoodDetailReturnData *response))success
                         fail:(void(^)(NSError *error))fail;

- (void)foodMenuWithGoodsName:(NSString *)goods_name
                      success:(void(^)(QSAPIModelString *response))success
                         fail:(void(^)(NSError *error))fail;
@end
