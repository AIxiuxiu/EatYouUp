//
//  QSAPIClientBase+Index.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Index.h"
#import "QSAPIModel+Index.h"

@implementation QSAPIClientBase (Index)

- (void)indexBannerWithSuccess:(void (^)(QSIndexBannerReturnData *))success
                          fail:(void (^)(NSError *))fail
{
    // . setup params
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *params = [QSAPIClientBase SetParams:dict];
    
    // . request
    [self.dataClient postPath:QSAPIIndexBanner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSIndexBannerReturnData objectMapping] keyPath:nil];
        QSIndexBannerReturnData *response = (result.dictionary)[[NSNull null]];

        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
//            CHAErrorResponseData *error = [[CHAErrorResponseData alloc] init];
//            error.str_err = response.str_err;
//            if (fail) {
//                fail(error);
//            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
//        if (fail) {
//            fail(response);
//        }
    }];
}

@end
