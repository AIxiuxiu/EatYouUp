//
//  QSAPIModel+MyDiary.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (MyDiary)

@end

@interface QSMyDiaryListReturnData : NSObject<QSObjectMapping>

@property (nonatomic,retain) NSArray *myDiaryList;

@end

@interface QSMyDiaryDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *diaryID;
@property (nonatomic,copy) NSString *authorID;
@property (nonatomic,copy) NSString *marID;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userIcon;
@property (nonatomic,copy) NSString *marName;
@property (nonatomic,copy) NSString *releaseTime;
@property (nonatomic,copy) NSString *lastUpdateTime;
@property (nonatomic,copy) NSString *readCount;
@property (nonatomic,copy) NSString *interestedCount;
@property (nonatomic,copy) NSString *diaryComment;
@property (nonatomic,copy) NSArray *imageList;
@property (nonatomic,copy) NSString *merchantLongitude;
@property (nonatomic,copy) NSString *merchantLatitude;
@property (nonatomic,copy) NSString *marNickName;

@end

@interface QSMyDiaryImageModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *imageName;

@end