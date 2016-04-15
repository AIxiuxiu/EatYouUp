//
//  QSAPIClientBase+MyDiary.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+MyDiary.h"

@interface QSAPIClientBase (MyDiary)

- (void)myDiaryListDataRequest:(void(^)(NSArray *myDiaryList))successAction andFailCallBack:(void(^)(NSError *error))failAction;

@end
