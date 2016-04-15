//
//  QSAPIClientBase+QSFreeFoodStore.h
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+QSFreeActivitiesStore.h"

//回调block
typedef void (^FOODDETECTED_RECOMMEND_SUCCESS_BLOCK)(NSArray *respondArray);
typedef void (^FOODDETECTED_RECOMMEND_FAIL_BLOCK)(NSError *error);

@interface QSAPIClientBase (QSFreeFoodStore)

- (void)freeActivitiesStoreListWithCallBack:(FOODDETECTED_RECOMMEND_SUCCESS_BLOCK)successAction failCallBack:(FOODDETECTED_RECOMMEND_FAIL_BLOCK)failAction;

@end
