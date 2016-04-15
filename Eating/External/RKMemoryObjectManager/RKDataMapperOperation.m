//
//  RMDataMapperOperation.m
//  MasterPlan
//
//  Created by Kim on 13-4-7.
//  Copyright (c) 2013年 Kim. All rights reserved.
//

#import "RKDataMapperOperation.h"
#import "RestKit.h"

@implementation RKDataMapperOperation

- (id)initWithData:(id)data mappingsDictionary:(NSDictionary *)mappingsDictionary {
    
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:nil];
    if (parsedData) {
        
        self = [super initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
    }
    
    return self;
}

// Adopted fix for "The Deallocation Problem" from AFN
- (void)setCompletionBlock:(void (^)(void))block {
    if (!block) {
        [super setCompletionBlock:nil];
    } else {
        __unsafe_unretained id weakSelf = self;
        [super setCompletionBlock:^ {
            block();
            [weakSelf setCompletionBlock:nil];
        }];
    }
}

- (void)setCompletionBlockWithSuccess:(void (^)(RKDataMapperOperation *operation, RKMappingResult *mappingResult))success
                              failure:(void (^)(RKDataMapperOperation *operation, NSError *error))failure {
    // See above setCompletionBlock:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    self.completionBlock = ^ {
        if ([self isCancelled]) {
            return;
        }
        
        if (self.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(self, self.error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(self, self.mappingResult);
                });
            }
        }
    };
    
#pragma clang diagnostic pop
}


@end
