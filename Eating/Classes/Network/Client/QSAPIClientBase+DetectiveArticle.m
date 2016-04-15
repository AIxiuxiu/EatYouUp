//
//  QSAPIClientBase+DetectiveArticle.m
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+DetectiveArticle.h"

@implementation QSAPIClientBase (DetectiveArticle)

- (void)detectiveArticleDataWithID:(NSString *)articleID andSuccessCallBack:(void(^)(QSDetectiveArticleDataModel *resultModel))successAction andFailCallBack:(void(^)(NSError *error))failAction
{
    //ID有效，进行参数封装
    if (articleID) {
        //参数封装
        NSDictionary *postParams = @{
                                     @"id" : articleID
                                     };
        NSMutableDictionary *requestParams = [QSAPIClientBase SetParams:[postParams mutableCopy]];
        
        //请求数据
        [self.dataClient postPath:QSAPIArticleDetail parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //解析数据
            RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSDetectiveArticleReturnData objectMapping] keyPath:nil];
            QSDetectiveArticleReturnData *response = (result.dictionary)[[NSNull null]];
            if (([response.articleArray count] > 0) && successAction) {
                successAction(response.articleArray[0]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //推荐请求失败
            failAction(error);
            NSLog(@"%s,%s,%d",__FILE__,__FUNCTION__,__LINE__);
        }];
    }
}

@end
