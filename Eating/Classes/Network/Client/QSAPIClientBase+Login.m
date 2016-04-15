//
//  QSAPIClientBase+Login.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+Login.h"
#import "QSAPIModel+User.h"

@implementation QSAPIClientBase (Login)

- (void)userLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                      success:(void (^)(BOOL flag,QSUserReturnData *model,NSString *errorInfo,NSString *errorCode))success
                         fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"accountName" : username ? username : @"",
                           @"password" : password ? password : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPILogin parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSUserReturnCheckData objectMapping] keyPath:nil];
        QSUserReturnCheckData *response = (result.dictionary)[[NSNull null]];
        
        if (response.type) {
            
            RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSUserReturnData objectMapping] keyPath:nil];
            QSUserReturnData *resultData = (result.dictionary)[[NSNull null]];
            
            // . handling.
            if (success && response && resultData.type) {
                success(YES,resultData,@"登录成功",@"ER0000");
            }
            
        } else {
            
            ///登录失败
            success(NO,nil,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///回调失败
//        success(NO,nil,[NSString stringWithFormat:@"%@",error],@"ER0021");
        fail(error);
        
    }];
}

@end
