//
//  QSAPIClientBase+Index.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSIndexBannerReturnData;
@interface QSAPIClientBase (Index)

- (void)indexBannerWithSuccess:(void(^)(QSIndexBannerReturnData *response))success
                          fail:(void(^)(NSError *error))fail;

@end
