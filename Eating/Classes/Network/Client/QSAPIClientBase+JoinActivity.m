//
//  QSAPIClientBase+JoinActivity.m
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+JoinActivity.h"

@implementation QSAPIClientBase (JoinActivity)

- (void)joinActivityWithCondition:(NSArray *)con andSuccessCallBack:(void(^)(BOOL joinResult,NSString *msg))successAction andFailCallBack:(void(^)(NSError *error))failAction
{
    //QSAPIJoinActivity
    if ([con count] == 5) {
        //参数封装
        NSDictionary *postParams = @{
                                     @"at_id" : con[4],
                                     @"name" : con[0],
                                     @"iphone" : con[1],
                                     @"email" : con[2],
                                     @"qq_wechat" : con[3]
                                     };
        NSMutableDictionary *requestParams = [QSAPIClientBase SetParams:[postParams mutableCopy]];
        
        // . request
        [self.dataClient postPath:QSAPIJoinActivity parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // . object mapping.
            RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSJoinActivityReturnData objectMapping] keyPath:nil];
            QSJoinActivityReturnData *response = (result.dictionary)[[NSNull null]];
            if (response && successAction) {
                successAction(response.type,response.infoArray[1]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //推荐请求失败
            failAction(error);
            NSLog(@"%s,%s,%d",__FILE__,__FUNCTION__,__LINE__);
        }];
    }
}

@end
