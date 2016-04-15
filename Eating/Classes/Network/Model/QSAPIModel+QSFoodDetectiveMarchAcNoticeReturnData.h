//
//  QSAPIModel+QSFoodDetectiveMarchAcNoticeReturnData.h
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (QSFoodDetectiveMarchAcNoticeReturnData)

@end

@interface QSFoodDetectiveMarchAcNoticeReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, retain) NSMutableArray *foodDetectiveArray;

@end

@interface QSFoodDetectiveMarchAcNoticeModel : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic,copy) NSString *actID;
@property (nonatomic,copy) NSString *release_time;
@property (nonatomic,copy) NSString *update_time;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *user_logo;
@property (nonatomic,copy) NSString *account_name;
@property (nonatomic,copy) NSString *follow_num;
@property (nonatomic,copy) NSString *view_num;
@property (nonatomic,copy) NSString *love_num;
@property (nonatomic,copy) NSString *merchant_id;
@property (nonatomic,copy) NSString *share_title;
@property (nonatomic,retain) NSMutableArray *image_list;

@end

@interface QSFoodDetectiveMarchAcNoticeImageModel : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic,copy) NSString *marID;
@property (nonatomic,copy) NSString *image_name;

@end
