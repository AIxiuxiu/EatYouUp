//
//  QSAPIModel+JoinActivity.h
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (JoinActivity)

@end

@interface QSJoinActivityReturnData : NSObject<QSObjectMapping>

@property (nonatomic, assign) BOOL type;
@property (nonatomic,retain) NSArray *infoArray;

@end