//
//  QSAPIClientBase+AddFoodGroud.h
//  Eating
//
//  Created by ysmeng on 14/12/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+AddFoodGroud.h"

@interface QSAPIClientBase (AddFoodGroud)

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
- (void)addFoodGroudWithParams:(NSDictionary *)dict andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

@end