//
//  QSAPIModel+QSFoodDetectiveRecommendReturnData.h
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (QSFoodDetectiveRecommendReturnData)

@end

@interface QSFoodDetectiveRecommendReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, retain) NSMutableArray *foodDetectiveArray;

@end

@interface QSFoodDetectiveRecommendModel : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic,copy) NSString *actID;
@property (nonatomic,copy) NSString *marID;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *marName;

@end
