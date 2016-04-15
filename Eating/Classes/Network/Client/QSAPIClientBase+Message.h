//
//  QSAPIClientBase+Message.h
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSMerchantChatListReturnData;
@class QSUserTalkListReturnData;
@interface QSAPIClientBase (Message)

- (void)merchantChatList:(NSString *)merchant_id
                    page:(NSInteger)startPage
                 success:(void(^)(QSMerchantChatListReturnData *response))success
                    fail:(void(^)(NSError *error))fail;

- (void)userChatList:(NSInteger)startPage
             success:(void(^)(QSUserTalkListReturnData *response))success
                fail:(void(^)(NSError *error))fail;

- (void)merchantChatAdd:(NSString *)merchant_id
         from_user_name:(NSString *)from_user_name
                to_name:(NSString *)to_name
                content:(NSString *)content
                success:(void(^)(QSAPIModelString *response))success
                   fail:(void(^)(NSError *error))fail;
@end
