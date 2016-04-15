//
//  QSAPIModel+DetectiveArticle.h
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (DetectiveArticle)

@end

@interface QSDetectiveArticleReturnData : NSObject<QSObjectMapping>

@property (nonatomic, assign) BOOL type;
@property (nonatomic,retain) NSMutableArray *articleArray;

@end

@interface QSDetectiveArticleDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *articleID;
@property (nonatomic,copy) NSString *authorID;
@property (nonatomic,copy) NSString *marID;
@property (nonatomic,copy) NSDictionary *authorIconModel;
@property (nonatomic,copy) NSString *authorName;
@property (nonatomic,copy) NSString *releaseTime;
@property (nonatomic,copy) NSString *modifyTime;
@property (nonatomic,copy) NSString *readCount;
@property (nonatomic,copy) NSString *interestedCount;
@property (nonatomic,assign) BOOL currentUserInterestedStatu;
@property (nonatomic,copy) NSString *comment;

@end

@interface QSDetectiveArticleAuthorIconModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *articleID;
@property (nonatomic,copy) NSString *authorIcon;

@end