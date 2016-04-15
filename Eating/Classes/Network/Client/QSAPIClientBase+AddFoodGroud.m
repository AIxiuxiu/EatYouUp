//
//  QSAPIClientBase+AddFoodGroud.m
//  Eating
//
//  Created by ysmeng on 14/12/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+AddFoodGroud.h"

@implementation QSAPIClientBase (AddFoodGroud)

/**
 *  @author         yangshengmeng, 14-12-24 15:12:01
 *
 *  @brief          新增搭食团
 *
 *  @param dict     搭食团信息参数
 *  @param callBack 请求成功时的回调
 *
 *  @since          2.0
 */
- (void)addFoodGroudWithParams:(NSDictionary *)dict andCallBack:(void (^)(BOOL, NSString *, NSString *))callBack
{
    
    ///判断参数
    if (nil == dict) {
        
        callBack(NO,@"参数无效",@"ER0021");
        return;
        
    }
    
    ///请求数据
    NSDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    [self.dataClient postPath:QSAPIAddFoodGroud parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAddFoodGroudReturnData objectMapping] keyPath:nil];
        QSAddFoodGroudReturnData *response = (result.dictionary)[[NSNull null]];
        
        if (callBack && response.type) {
            
            callBack(YES,response.errorInfo,response.errorCode);
            
        } else {
        
            callBack(NO,response.errorInfo,response.errorCode);
        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callBack) {
            callBack(NO,[NSString stringWithFormat:@"%@",error],nil);
        }
        
    }];

}

@end
