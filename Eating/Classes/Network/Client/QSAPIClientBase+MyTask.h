//
//  QSAPIClientBase+MyTask.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+MyTask.h"

@interface QSAPIClientBase (MyTask)

- (void)myTaskListDataRequest:(void(^)(NSArray *myTaskList))successAction andFailCallBack:(void(^)(NSError *error))failAction;

@end
