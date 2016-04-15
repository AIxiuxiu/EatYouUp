//
//  RKMemoryObjectManager.m
//  MasterPlan
//
//  Created by Kim on 13-4-6.
//  Copyright (c) 2013年 Kim. All rights reserved.
//

#import "RKDataObjectManager.h"
#import "RestKit.h"

#import "RKDataMapperOperation.h"
#import "RKObjectMappingOperationDataSource.h"
#import "RKMappingErrors.h"

@implementation RKDataObjectManager

+ (RKDataObjectManager *)sharedManager {
    static dispatch_once_t pred = 0;
	static RKDataObjectManager *shared_manager = nil;
	
	dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
	
	return shared_manager;
}

- (id)init {
    if (self = [super init]) {
        self.operationQueue = [NSOperationQueue new];
    }
    
    return self;
}

- (void)enqueueObjectRequestOperation:(RKMapperOperation *)objectRequestOperation {
    [self.operationQueue addOperation:objectRequestOperation];
}

- (RKMapperOperation *)importObjectFromData:(NSData *)data
                     mapping:(RKMapping *)mapping
                     keyPath:(NSString *)keyPath
                     success:(void (^)(RKMapperOperation *operation, RKMappingResult *mappingResult))success
                     failure:(void (^)(RKMapperOperation *operation, NSError *error))failure {
    NSParameterAssert(data);
    NSParameterAssert(mapping);
    
    NSDictionary *mappingDictionary = @{ (keyPath ?: [NSNull null]) : mapping};
    RKDataMapperOperation *operation = [[RKDataMapperOperation alloc] initWithData:data mappingsDictionary:mappingDictionary];
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [self enqueueObjectRequestOperation:operation];
    
    return operation;
}

- (RKMappingResult *)objectFromData:(NSData *)data
                                         mapping:(RKMapping *)mapping
                                         keyPath:(NSString *)keyPath {
    NSParameterAssert(data);
    NSParameterAssert(mapping);
    
    NSDictionary *mappingDictionary = @{ (keyPath ?: [NSNull null]) : mapping};
    RKDataMapperOperation *operation = [[RKDataMapperOperation alloc] initWithData:data mappingsDictionary:mappingDictionary];
    [operation start];
    [operation waitUntilFinished];
    
    return operation.mappingResult;
}

- (NSData *)dataFromObject:(id)object mapping:(RKMapping *)mapping error:(NSError **)error {
    NSData *data = nil;
        
    RKObjectMappingOperationDataSource *dataSource = [RKObjectMappingOperationDataSource new];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    RKMappingOperation *operation = [[RKMappingOperation alloc] initWithSourceObject:object destinationObject:dictionary mapping:mapping];
    operation.dataSource = dataSource;
    [operation start];
    if (operation.error) {
        if (operation.error.code == RKMappingErrorUnmappableRepresentation) {
            // If the mapped object is empty, return an empty dictionary and no error
        }
        
        if (error) *error = operation.error;
        return data;
    }    
    
    data = [RKMIMETypeSerialization dataFromObject:dictionary MIMEType:@"application/json" error:nil];
    
    return data;
}

@end
