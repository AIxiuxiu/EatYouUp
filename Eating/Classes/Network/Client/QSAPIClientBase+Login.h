//
//  QSAPIClientBase+Login.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSUserReturnData;
@interface QSAPIClientBase (Login)

- (void)userLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                      success:(void(^)(BOOL flag,QSUserReturnData *model,NSString *errorInfo,NSString *errorCode))success
                         fail:(void(^)(NSError *error))fail;

@end
