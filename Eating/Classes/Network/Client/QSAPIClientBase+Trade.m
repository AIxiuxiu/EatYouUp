//
//  QSAPIClientBase+Trade.m
//  Eating
//
//  Created by System Administrator on 12/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Trade.h"
#import "QSAPIModel+Trade.h"

@implementation QSAPIClientBase (Trade)

- (void)userTradeList:(NSInteger)page
              success:(void (^)(QSTradeListReturnData *))success
                 fail:(void (^)(NSError *))fail
{
    NSDictionary *dict = @{
                           @"key" : @"",
                           @"now_page" : [NSString stringWithFormat:@"%d",(int)page],
                           @"order" : @"t.time desc"
                           };
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIBillList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSTradeListReturnData objectMapping] keyPath:nil];
        QSTradeListReturnData *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response) {
            success(response);
        }
        else{
            
            fail(nil);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(nil);
        
    }];
}

@end
