//
//  QSAPIClientBase+JoinActivity.h
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+JoinActivity.h"

@interface QSAPIClientBase (JoinActivity)

- (void)joinActivityWithCondition:(NSArray *)con andSuccessCallBack:(void(^)(BOOL joinResult,NSString *msg))successAction andFailCallBack:(void(^)(NSError *error))failAction;

@end
