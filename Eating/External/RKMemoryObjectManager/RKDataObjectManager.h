//
//  RKMemoryObjectManager.h
//  MasterPlan
//
//  Created by Kim on 13-4-6.
//  Copyright (c) 2013年 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKDataMapperOperation.h"
@interface RKDataObjectManager : NSObject

+ (RKDataObjectManager *)sharedManager;

/**
 The operation queue which manages operations enqueued by the object manager.
 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (RKMapperOperation *)importObjectFromData:(NSData *)data
                                    mapping:(RKMapping *)mapping
                                    keyPath:(NSString *)keyPath
                                    success:(void (^)(RKMapperOperation *operation, RKMappingResult *mappingResult))success
                                    failure:(void (^)(RKMapperOperation *operation, NSError *error))failure;

- (RKMappingResult *)objectFromData:(NSData *)data
                            mapping:(RKMapping *)mapping
                            keyPath:(NSString *)keyPath;

- (NSData *)dataFromObject:(id)object mapping:(RKMapping *)mapping error:(NSError **)error;

@end
