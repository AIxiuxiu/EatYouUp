//
//  QSAPIModel+Book.h
//  Eating
//
//  Created by System Administrator on 12/2/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Book)

@end


@interface QSBookListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QSBookDetailData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *merchange_id;
@property (nonatomic, copy) NSString *book_time;
@property (nonatomic, copy) NSString *book_desc;
@property (nonatomic, copy) NSString *book_phone;
@property (nonatomic, copy) NSString *book_name;
@property (nonatomic, copy) NSString *book_num;
@property (nonatomic, copy) NSString *book_no;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *book_or_num;
@property (nonatomic, copy) NSString *reserve_time;
@property (nonatomic, copy) NSString *reach_time;
@property (nonatomic, copy) NSString *begin_time;
@property (nonatomic, copy) NSString *over_time;
@property (nonatomic, copy) NSString *book_type;
@property (nonatomic, copy) NSString *add_user_id;
@property (nonatomic, copy) NSString *book_date;
@property (nonatomic, copy) NSString *book_sex;
@property (nonatomic, copy) NSString *commit_time;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *book_seat_type;
@property (nonatomic, copy) NSString *book_seat_num;
@property (nonatomic, copy) NSString *book_source_type;
@property (nonatomic, copy) NSString *merchant_name;
@property (nonatomic, strong) NSMutableDictionary *merchant_msg;

@end


@interface QSBookDetailReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) QSBookDetailData *data;

@end