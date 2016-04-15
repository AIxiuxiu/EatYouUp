//
//  QSAPIClientBase+FoodDetective.m
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+FoodDetective.h"

@implementation QSAPIClientBase (FoodDetective)

- (void)foodDetectedRecommendWithPage:(NSInteger)page andPageNum:(NSInteger)pageNum successCallBack:(FOODDETECTED_RECOMMEND_SUCCESS_BLOCK)successAction failCallBack:(FOODDETECTED_RECOMMEND_FAIL_BLOCK)failAction
{
    //判断是否请求第一页
    if (page == 1) {
        [self foodDetectedRecommendHeader:^(NSArray *respondArrayHeader) {
            // .推荐请求完成.
            if ([respondArrayHeader count] > 0) {
                
                //数据源
                NSMutableArray *resultTempArray = [[NSMutableArray alloc] initWithObjects:respondArrayHeader, nil];
                
                //进行分享信息请求
                [self foodDetectedRecommendNormal:page andPageNum:pageNum successCallBack:^(NSArray *respondArrayNormal) {
                    if (([respondArrayNormal count] > 0) && successAction) {
                        [resultTempArray addObjectsFromArray:respondArrayNormal];
                        successAction(resultTempArray);
                    }
                } failCallBack:^(NSError *error) {
                    failAction(error);
                }];
            }
        } failCallBack:^(NSError *error) {
            failAction(error);
        }];
        return;
    }
    
    //进行第二页请求
    if (page > 1) {
        //进行分享信息请求
        NSMutableArray *resultTempArray = [[NSMutableArray alloc] init];
        [self foodDetectedRecommendNormal:page andPageNum:pageNum successCallBack:^(NSArray *respondArrayNormal) {
            if (([respondArrayNormal count] > 0) && successAction) {
                [resultTempArray addObjectsFromArray:respondArrayNormal];
                successAction(resultTempArray);
            }
        } failCallBack:^(NSError *error) {
            failAction(error);
        }];
        return;
    }
}

//请求头信息
- (void)foodDetectedRecommendHeader:(FOODDETECTED_RECOMMEND_SUCCESS_BLOCK)successAction failCallBack:(FOODDETECTED_RECOMMEND_FAIL_BLOCK)failAction
{
    //参数封装
    NSDictionary *foodDetectiveRecommend = @{@"type" : @"1"};
    NSMutableDictionary *paramsFoodDetectiveRecommend = [QSAPIClientBase SetParams:[foodDetectiveRecommend mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIFoodDetectiveRecommend parameters:paramsFoodDetectiveRecommend success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodDetectiveRecommendReturnData objectMapping] keyPath:nil];
        QSFoodDetectiveRecommendReturnData *response = (result.dictionary)[[NSNull null]];
        if (([response.foodDetectiveArray count] > 0) && successAction) {
            successAction(response.foodDetectiveArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //推荐请求失败
        failAction(nil);
        NSLog(@"%s,%s,%d",__FILE__,__FUNCTION__,__LINE__);
    }];
}

//请普通推荐信息
- (void)foodDetectedRecommendNormal:(NSInteger)page andPageNum:(NSInteger)pageNum successCallBack:(FOODDETECTED_RECOMMEND_SUCCESS_BLOCK)successAction failCallBack:(FOODDETECTED_RECOMMEND_FAIL_BLOCK)failAction
{
    //参数
    NSDictionary *marAcNoticeDict = @{
                                      @"startPage" : [NSString stringWithFormat:@"%ld",page] ? : @"1",
                                      @"pageNum" : [NSString stringWithFormat:@"%ld",pageNum] ? : @"5"
                                      };
    
    //进行推介信息请求
    NSMutableDictionary *paramsmarAcNotice = [QSAPIClientBase SetParams:[marAcNoticeDict mutableCopy]];
    
    [self.dataClient postPath:QSAPIFoodDetectiveMarAcNotice parameters:paramsmarAcNotice success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //评论请求成功
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodDetectiveMarchAcNoticeReturnData objectMapping] keyPath:nil];
        QSFoodDetectiveMarchAcNoticeReturnData *response = (result.dictionary)[[NSNull null]];
        //返回
        if (successAction && response) {
            successAction([NSArray arrayWithArray:response.foodDetectiveArray]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //评论请求失败
        failAction(nil);
        NSLog(@"%s,%s,%d",__FILE__,__FUNCTION__,__LINE__);
    }];
}

@end
