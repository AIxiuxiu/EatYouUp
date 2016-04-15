//
//  QSAPIClientBase+QSTryActivities.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+QSTryActivities.h"
#import "QSAPIModel+QSTryActivitiesReturnData.h"

@implementation QSAPIClientBase (QSTryActivities)

- (void)tryActivitiesWithID:(NSString *)userID andID:(NSString *)tryID andSuccessCallBack:(TRYACTIVITIES_SUCCESSCALLBACK_BLOCK)successAction andFailCallBack:(TRYACTIVITIES_FAILCALLBACK_BLOCK)failAction
{
    //参数
    NSDictionary *marAcNoticeDict = @{
                                      @"user_id" : userID ? : @"0",
                                      @"id" : tryID ? : @"0"
                                      };
    
    //进行推介信息请求
    NSMutableDictionary *paramsmarAcNotice = [QSAPIClientBase SetParams:[marAcNoticeDict mutableCopy]];
        
    //开始请求数据
    [self.dataClient postPath:QSAPITryActivityDetail parameters:paramsmarAcNotice success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //评论请求成功
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSTryActivitiesReturnData objectMapping] keyPath:nil];
        QSTryActivitiesReturnData *response = (result.dictionary)[[NSNull null]];
        
        //回调
        if (successAction && response.tryActivitiesModel) {
            successAction(response.tryActivitiesModel);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //评论请求失败
        failAction(nil);
        NSLog(@"%s,%s,%d",__FILE__,__FUNCTION__,__LINE__);
    }];
}

@end
