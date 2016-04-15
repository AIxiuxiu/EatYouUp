//
//  QSAPIClientBase+FoodDetective.h
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+QSFoodDetectiveRecommendReturnData.h"
#import "QSAPIModel+QSFoodDetectiveMarchAcNoticeReturnData.h"

//回调block
typedef void (^FOODDETECTED_RECOMMEND_SUCCESS_BLOCK)(NSArray *respondArray);
typedef void (^FOODDETECTED_RECOMMEND_FAIL_BLOCK)(NSError *error);

@interface QSAPIClientBase (FoodDetective)

- (void)foodDetectedRecommendWithPage:(NSInteger)page andPageNum:(NSInteger)pageNum successCallBack:(FOODDETECTED_RECOMMEND_SUCCESS_BLOCK)successAction failCallBack:(FOODDETECTED_RECOMMEND_FAIL_BLOCK)failAction;

@end
