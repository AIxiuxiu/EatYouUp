//
//  QSAPIModel+MyTask.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (MyTask)

@end

@interface QSMyTaskListReturnData : NSObject<QSObjectMapping>

@property (nonatomic,retain) NSArray *myTaskList;

@end

@interface QSMyTaskDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *activityID;
@property (nonatomic,copy) NSString *authorID;
@property (nonatomic,copy) NSString *activityType;
@property (nonatomic,copy) NSString *marID;
@property (nonatomic,copy) NSString *marName;
@property (nonatomic,copy) NSString *marNickName;
@property (nonatomic,copy) NSString *marLogo;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *marScore;
@property (nonatomic,copy) NSString *marLongitude;
@property (nonatomic,copy) NSString *marLatitude;
@property (nonatomic,copy) NSString *currentUserStatu;
@property (nonatomic,copy) NSString *isGet;
@property (nonatomic,copy) NSString *activityStatus;

@end