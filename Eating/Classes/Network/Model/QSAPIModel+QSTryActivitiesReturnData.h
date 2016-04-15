//
//  QSAPIModel+QSTryActivitiesReturnData.h
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (QSTryActivitiesReturnData)

@end

@class QSTryActivitiesDataModel;
@interface QSTryActivitiesReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, retain) QSTryActivitiesDataModel *tryActivitiesModel;

@end

@interface QSTryActivitiesDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *activitiesID;//活动ID
@property (nonatomic,copy) NSString *userID;//用户ID
@property (nonatomic,copy) NSString *activitiesType;//活动类型
@property (nonatomic,copy) NSString *activitiesName;//活动名称
@property (nonatomic,copy) NSString *activityStatu;//活动状态
@property (nonatomic,copy) NSString *isGet;//是否中奖isGet
@property (nonatomic,copy) NSString *startTime;//开始时间
@property (nonatomic,copy) NSString *endTime;//结束时间
@property (nonatomic,copy) NSString *joinNum;//已报名数量
@property (nonatomic,copy) NSString *emtyNum;//已报名数量
@property (nonatomic,copy) NSString *headerImage;//活动大图
@property (nonatomic,copy) NSString *marID;//活动店铺ID
@property (nonatomic,copy) NSString *marName;//店铺名字
@property (nonatomic,copy) NSString *marIcon;//店铺logo
@property (nonatomic,copy) NSString *marAddress;//店铺地址
@property (nonatomic,copy) NSString *addCondiction;//加入条件
@property (nonatomic,copy) NSString *activitiesDetail;//活动详情说明
@property (nonatomic,copy) NSString *currentUserStatue;//当前用户是否加入此活动状态

@end
