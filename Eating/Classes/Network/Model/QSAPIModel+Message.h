//
//  QSAPIModel+Message.h
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Message)

@end

@interface QSUserTalkListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QSUserTalkListDetailData : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *message_id;
@property (nonatomic,copy) NSString *from_user_id;
@property (nonatomic,copy) NSString *to_user_id;
@property (nonatomic,copy) NSString *to_merchant_id;
@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *parent_id;
@property (nonatomic,copy) NSString *first_id;
@property (nonatomic,copy) NSString *from_user_name;
@property (nonatomic,copy) NSString *to_name;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *get_time;
@property (nonatomic,copy) NSString *reply_time;
@property (nonatomic,copy) NSString *send_time;
@property (nonatomic,copy) NSString *reply_content;
@property (nonatomic,copy) NSString *merchant_logo;
@property (nonatomic,copy) NSString *merchant_name;

@end

@interface QSMerchantChatListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QSMerchantChatDetailData : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *message_id;
@property (nonatomic,copy) NSString *from_user_id;
@property (nonatomic,copy) NSString *to_user_id;
@property (nonatomic,copy) NSString *to_merchant_id;
@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *parent_id;
@property (nonatomic,copy) NSString *first_id;
@property (nonatomic,copy) NSString *from_user_nam;
@property (nonatomic,copy) NSString *to_name;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *get_time;
@property (nonatomic,copy) NSString *reply_time;
@property (nonatomic,copy) NSString *send_time;
@property (nonatomic,copy) NSString *reply_content;
@property (nonatomic,copy) NSString *merchant_logo;
@property (nonatomic,copy) NSString *merchant_name;

@end
