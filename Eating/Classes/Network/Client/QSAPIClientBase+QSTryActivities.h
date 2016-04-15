//
//  QSAPIClientBase+QSTryActivities.h
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

//model
@class QSTryActivitiesDataModel;

//回调block
typedef void (^TRYACTIVITIES_SUCCESSCALLBACK_BLOCK)(QSTryActivitiesDataModel *model);
typedef void (^TRYACTIVITIES_FAILCALLBACK_BLOCK)(NSError *error);

@interface QSAPIClientBase (QSTryActivities)

- (void)tryActivitiesWithID:(NSString *)userID andID:(NSString *)tryID andSuccessCallBack:(TRYACTIVITIES_SUCCESSCALLBACK_BLOCK)successAction andFailCallBack:(TRYACTIVITIES_FAILCALLBACK_BLOCK)failAction;

@end
