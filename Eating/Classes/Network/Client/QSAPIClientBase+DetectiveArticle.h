//
//  QSAPIClientBase+DetectiveArticle.h
//  Eating
//
//  Created by ysmeng on 14/11/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPIModel+DetectiveArticle.h"

@interface QSAPIClientBase (DetectiveArticle)

- (void)detectiveArticleDataWithID:(NSString *)articleID andSuccessCallBack:(void(^)(QSDetectiveArticleDataModel *resultModel))successAction andFailCallBack:(void(^)(NSError *error))failAction;

@end
