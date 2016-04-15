//
//  QSAPIModel+Comment.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Comment)

@end


@interface QSCommentListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QSCommentDetailData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *conment;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *article_time;
@property (nonatomic, copy) NSString *modify_time;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *follow_num;
@property (nonatomic, copy) NSString *per;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *evaluate;
@property (nonatomic,copy) NSString *user_link;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic, strong) NSMutableArray *image_list;
@property (nonatomic, strong) NSMutableArray *image_list_new;

@end
