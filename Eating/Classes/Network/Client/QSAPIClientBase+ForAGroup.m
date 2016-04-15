//
//  QSAPIClientBase+ForAGroup.m
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+ForAGroup.h"

@implementation QSAPIClientBase (ForAGroup)

- (void)forAGroupWithCondition:(NSArray *)con andSuccessCallBack:(void(^)(BOOL forResult))successAction andFailCallBack:(void(^)(NSError *error))failAction
{
    if ([con count] == 5) {
        //参数封装
        NSDictionary *postParams = @{
                                                 @"dis_merchant_name" : con[0],
                                                 @"dis_address" : con[1],
                                                 @"desc" : con[3],
                                                 @"dis_call" : con[2]
                                                 };
        NSMutableDictionary *requestParams = [QSAPIClientBase SetParams:[postParams mutableCopy]];
        
        // . request
        [self.dataClient postPath:QSAPIForAGroup parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // . object mapping.
            RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSForAGoupReturnData objectMapping] keyPath:nil];
            QSForAGoupReturnData *response = (result.dictionary)[[NSNull null]];
            if (response && successAction) {
                successAction(response.type);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //推荐请求失败
            failAction(error);
            NSLog(@"%s,%s,%d",__FILE__,__FUNCTION__,__LINE__);
        }];
    }
}

@end
