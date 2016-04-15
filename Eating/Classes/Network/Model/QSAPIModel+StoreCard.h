//
//  QSAPIModel+StoreCard.h
//  Eating
//
//  Created by AYG on 14-12-25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (StoreCard)

@end


@interface QSStoreCardListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end


@interface QSStoreCardDetailData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *card_id;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *psw;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *limit_val;
@property (nonatomic, copy) NSString *val;
@property (nonatomic, copy) NSString *mer_id;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, strong) NSMutableDictionary *storeCardMsg;

@end