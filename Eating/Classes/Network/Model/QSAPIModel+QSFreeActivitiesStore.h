//
//  QSAPIModel+QSFreeActivitiesStore.h
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (QSFreeActivitiesStore)

@end

@interface QSFreeActivitiesStoreReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, retain) NSMutableArray *freeActivitiesStoreList;

@end

@interface QSFreeActivitiesStoreModel : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic,copy) NSString *actID;
@property (nonatomic,copy) NSString *marID;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *storeIcon;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *marOtherName;
@property (nonatomic,copy) NSString *storeAddress;
@property (nonatomic,copy) NSString *starLevel;
@property (nonatomic,copy) NSString *startDate;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic,copy) NSString *statusCurrent;
@property (nonatomic,copy) NSString *distance;

@end