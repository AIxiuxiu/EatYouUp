//
//  QSAPIClientBase+Others.m
//  Eating
//
//  Created by System Administrator on 12/4/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Others.h"
#import "NSString+Name.h"
@implementation QSAPIClientBase (Others)

- (void)getMerchantSounds:(NSString *)urlStr
                  success:(void(^)(NSData *response))success
                     fail:(void(^)(NSError *error))fail
{
    NSDictionary *dict = @{};
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient getPath:[urlStr imageUrl] parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%ld",operation.responseData.length);
        // . object mapping.
        
        // . handling.
        if (success && operation.responseData) {
            success(operation.responseData);
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
