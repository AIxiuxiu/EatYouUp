//
//  QSAPIClientBase+QSFreeFoodStore.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+QSFreeFoodStore.h"

@implementation QSAPIClientBase (QSFreeFoodStore)

- (void)freeActivitiesStoreListWithCallBack:(FOODDETECTED_RECOMMEND_SUCCESS_BLOCK)successAction failCallBack:(FOODDETECTED_RECOMMEND_FAIL_BLOCK)failAction
{
    //参数封装
    NSDictionary *foodDetectiveRecommend = @{};
    NSMutableDictionary *paramsFoodDetectiveRecommend = [QSAPIClientBase SetParams:[foodDetectiveRecommend mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIFoodDetectiveRecommend parameters:paramsFoodDetectiveRecommend success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFreeActivitiesStoreReturnData objectMapping] keyPath:nil];
        QSFreeActivitiesStoreReturnData *response = (result.dictionary)[[NSNull null]];
        if (([response.freeActivitiesStoreList count] > 0) && successAction) {
            successAction(response.freeActivitiesStoreList);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //推荐请求失败
        failAction(nil);
        NSLog(@"%s,%s,%d",__FILE__,__FUNCTION__,__LINE__);
    }];

}

@end
