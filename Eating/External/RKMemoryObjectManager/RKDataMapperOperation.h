//
//  RMDataMapperOperation.h
//  MasterPlan
//
//  Created by Kim on 13-4-7.
//  Copyright (c) 2013年 Kim. All rights reserved.
//

#import "RKMapperOperation.h"

@interface RKDataMapperOperation : RKMapperOperation

- (id)initWithData:(id)data mappingsDictionary:(NSDictionary *)mappingsDictionary;

- (void)setCompletionBlockWithSuccess:(void (^)(RKDataMapperOperation *operation, RKMappingResult *mappingResult))success
                              failure:(void (^)(RKDataMapperOperation *operation, NSError *error))failure;


@end
