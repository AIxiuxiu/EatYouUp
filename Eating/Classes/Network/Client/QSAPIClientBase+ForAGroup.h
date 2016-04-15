//
//  QSAPIClientBase+ForAGroup.h
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+ForAGroup.h"

@interface QSAPIClientBase (ForAGroup)

- (void)forAGroupWithCondition:(NSArray *)con andSuccessCallBack:(void(^)(BOOL forResult))successAction andFailCallBack:(void(^)(NSError *error))failAction;

@end
