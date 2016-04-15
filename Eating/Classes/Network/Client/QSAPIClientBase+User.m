//
//  QSAPIClientBase+User.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "QSAPIModel+Merchant.h"
#import "QSAPIModel+Food.h"
#import "NSString+JSON.h"

@implementation QSAPIClientBase (User)

- (void)userRegister:(NSString *)mobile
            password:(NSString *)password
             success:(void (^)(QSAPIModel *))success
                fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"iphone" : mobile ? mobile : @"",
                           @"password" : password ? password : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParamsWithoutUserID:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserRegister parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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
            
            success(response);//!请勿删除：储值卡购买时需要此回调
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(error);//!请勿删除：储值卡购买时需要此回调
        
        //        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
        //        if (fail) {
        //
        //            fail(response);
        //
        //        }
        
    }];
}

- (void)changePasswordByPhone:(NSString *)mobile
                     password:(NSString *)password
                      success:(void (^)(QSAPIModel *))success
                         fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"iphone" : mobile ? mobile : @"",
                           @"new_psw" : password ? password : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserChangePasswordByPhone parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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
            
            success(response);//!请勿删除：储值卡购买时需要此回调
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(error);//!请勿删除：储值卡购买时需要此回调
        
        //        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
        //        if (fail) {
        //
        //            fail(response);
        //
        //        }
        
    }];
}

- (void)updateUserName:(NSString *)name
                   Sex:(NSString *)sex
               success:(void (^)(QSAPIModel *))success
                  fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"user_name" : name ? name : @"",
                           @"sex" : sex ? sex : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserUpdate parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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

- (void)updateUserPassword:(NSString *)password
               NewPassword:(NSString *)newpassowrd
                   success:(void (^)(QSAPIModel *))success
                      fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"old_psw" : password ? password : @"",
                           @"new_psw" : newpassowrd ? newpassowrd : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserUpdatePassword parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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

- (void)getVerCode:(NSString *)phone
        merchantId:(NSString *)merchant_id
           success:(void(^)(QSAPIModelString *response))success
              fail:(void(^)(NSError *error))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @"",
                           @"iphone" : phone ? phone : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIVerCode parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelString objectMapping] keyPath:nil];
        QSAPIModelString *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
        //        if (fail) {
        //            fail(response);
        //        }
    }];
}

- (void)bindMobile:(NSString *)old_mobile
         newMobile:(NSString *)new_mobile
           verCode:(NSString *)vercode
           success:(void (^)(QSAPIModel *))success
              fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"old_phone" : old_mobile ? old_mobile : @"",
                           @"new_phone" : new_mobile ? new_mobile : @"",
                           @"code" : vercode ? vercode : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserBindPhone parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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

- (void)bindEmail:(NSString *)old_email
         newEmail:(NSString *)new_email
          verCode:(NSString *)vercode
          success:(void (^)(QSAPIModel *))success
             fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"email" : new_email ? new_email : @"",
                           @"code" : vercode ? vercode : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserBindEmail parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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

- (void)uploadUserPortrait:(UIImage *)image
                   success:(void (^)(QSAPIModelString *))success
                      fail:(void (^)(NSError *))fail
{
    
    ///将图片转为二进制数据流
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
    ///封装图片上传的post参数
    NSURLRequest *request = [self.dataClient multipartFormRequestWithMethod:@"POST" path:@"http://117.41.235.110:8888/site/upImage" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:@"files" fileName:@"userheader.jpeg" mimeType:@"image/jpeg"];
        
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *temp = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
        ///修改头像url
        NSArray *array = [[temp JSON] objectForKey:@"files"];
        NSDictionary *dict = array[0];
        
        ///修改个人信息：头像URL
        [self changeUserPortraitUrl:[dict objectForKey:@"url"] success:^(QSAPIModel *response) {
            
            QSAPIModelString *response1 = [[QSAPIModelString alloc] init];
            response1.msg = [dict objectForKey:@"url"];
            
            ///回调
            if (success && response && response.type) {
                
                success(response1);
                
            }
            
        } fail:^(NSError *error) {
            
            if (fail) {
                
                fail(error);
                
            }
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (fail) {
            
            fail(error);
            
        }
        
    }];
    
    [self.dataClient.operationQueue addOperation:op];
    
}

- (void)randomTagListSuccess:(void (^)(QSTagListReturnData *))success
                        fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"num" : @"5"
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIRandomTagList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSTagListReturnData objectMapping] keyPath:nil];
        QSTagListReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)changeUserPortraitUrl:(NSString *)url
                      success:(void (^)(QSAPIModel *))success
                         fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"logo" : url ? url : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserChnageLogo parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            
            fail(nil);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(nil);
        
        
    }];
}

- (void)userTagListSuccess:(void (^)(QSTagListReturnData *))success fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{};
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserTagList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSTagListReturnData objectMapping] keyPath:nil];
        QSTagListReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userTagUpdate:(NSMutableArray *)tag_list
              success:(void (^)(QSAPIModel *))success
                 fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"tag_list" : tag_list ? tag_list : @[]
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUpdateTag parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userTagAdd:(NSString *)tag_id
           success:(void (^)(QSAPIModel *))success
              fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"tag_id" : tag_id ? tag_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIAddTag parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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


- (void)userTagDelete:(NSString *)tag_id
              success:(void (^)(QSAPIModel *))success
                 fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"tag_id" : tag_id ? tag_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIDelTag parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModel objectMapping] keyPath:nil];
        QSAPIModel *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userMerchantAddCollect:(NSString *)merchant_id
                       success:(void (^)(QSAPIModelDict *))success
                          fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserLikeMer parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userMerchantDelCollect:(NSString *)merchant_id
                       success:(void (^)(QSAPIModelDict *))success
                          fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserUnLikeMer parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userMerchantList:(NSInteger)page
                 success:(void (^)(QSMerchantListReturnData *))success
                    fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"startPage" : @(page) ? @(page) : @"1"
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserStoreMer parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSMerchantListReturnData objectMapping] keyPath:nil];
        QSMerchantListReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userMerchantIsCollect:(NSString *)merchant_id
                      success:(void (^)(QSAPIModelDict *))success
                         fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"merchant_id" : merchant_id ? merchant_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIIsMerStore parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userFoodAddCollect:(NSString *)goods_id
                   success:(void (^)(QSAPIModelDict *))success
                      fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"goods_id" : goods_id ? goods_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPUserLikeGreens parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userFoodDelCollect:(NSString *)goods_id
                   success:(void (^)(QSAPIModelDict *))success
                      fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"goods_id" : goods_id ? goods_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserUnLikeGreens parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userFoodList:(NSInteger)page
             success:(void (^)(QSFoodListReturnData *))success
                fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"startPage" : @(page) ? @(page) : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserStoreGreens parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSFoodListReturnData objectMapping] keyPath:nil];
        QSFoodListReturnData *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userFoodIsCollect:(NSString *)goods_id
                  success:(void (^)(QSAPIModelDict *))success
                     fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"goods_id" : goods_id ? goods_id : @""
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIIsGoodStore parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
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

- (void)userAddGood:(NSString *)be_id
               type:(kUserGoodType)type
            success:(void (^)(QSAPIModelDict *))success
               fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"be_id" : be_id ? be_id : @"",
                           @"type" : [NSString stringWithFormat:@"%d",(int)type]
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserGood parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            
            fail(nil);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(nil);
        
    }];
}

- (void)userDelGood:(NSString *)be_id
               type:(kUserGoodType)type
            success:(void (^)(QSAPIModelDict *))success
               fail:(void (^)(NSError *))fail
{
    // . setup params
    NSDictionary *dict = @{
                           @"be_id" : be_id ? be_id : @"",
                           @"type" : [NSString stringWithFormat:@"%d",(int)type]
                           };
    
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    // . request
    [self.dataClient postPath:QSAPIUserUnGood parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // . object mapping.
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIModelDict objectMapping] keyPath:nil];
        QSAPIModelDict *response = (result.dictionary)[[NSNull null]];
        
        // . handling.
        if (success && response && response.type) {
            success(response);
        }
        else{
            
            fail(nil);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(nil);
        
    }];
}

- (void)translateWithUrl:(NSString *)url
                    type:(NSString *)type
                 success:(void (^)(NSData *))success
                    fail:(void (^)(NSError *))fail
{
    // . request
    [self.dataClient postPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *temp = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *json = [temp JSON];
        NSArray* translation = json?[json objectForKey:@"trans_result"]:nil;
        
        NSDictionary* tword = [translation objectAtIndex:0];
        NSString* tw = [tword objectForKey:@"dst"];
        
        
        [self getTranslateData:[NSString stringWithFormat:@"http://fanyi.baidu.com/gettts?lan=%@&text=%@&spd=2&source=web",type,[tw stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                       success:^(NSData *data) {
                           
                           if (success) {
                               success(data);
                           }
                           
                       } fail:^(NSError *error) {
                           
                       }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
        //        if (fail) {
        //            fail(response);
        //        }
    }];
}

- (void)getTranslateData:(NSString *)url
                 success:(void (^)(NSData *data))success
                    fail:(void (^)(NSError *error))fail
{
    // . request
    [self.dataClient postPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(operation.responseData);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        CHAErrorResponseData *response = [self errorResponseDataWith:operation with:error];
        //        if (fail) {
        //            fail(response);
        //        }
    }];
}

/**
 *  @author         yangshengmeng, 14-12-23 10:12:14
 *
 *  @brief          给当前用户发送短信
 *
 *  @param msg      短信内容
 *  @param callBack 发送成功或失败后的回调
 *
 *  @since          2.0
 */
- (void)sendPhoneMessageForCurrentUser:(NSString *)msg andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack
{
    
    ///验证短信内容
    if (nil == msg || 0 >= [msg length]) {
        callBack(NO,@"短信内容不能为空",@"ER0021");
        return;
    }
    
    ///开始发送短信
    NSDictionary *dict = @{@"send_msg":msg,@"merchant_id":@"0"};
    
    ///封装用户信息
    NSDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    ///开始发送
    [self.dataClient postPath:QSAPISendPhoneMessage parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端响应成功，解析数据:
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPIBaseInfoModel objectMapping] keyPath:nil];
        QSAPIBaseInfoModel *response = (result.dictionary)[[NSNull null]];
        
        ///判断是否发送成功
        if (response.flag) {
            
            callBack(YES,response.errorInfo,response.errorCode);
            
        } else {
            
            callBack(NO,response.errorInfo,response.errorCode);
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///服务端响应失败
        callBack(NO,[NSString stringWithFormat:@"%@",error],@"ER0021");
        
    }];
    
}

#pragma mark - 获取token
- (void)getToken:(void(^)(BOOL flag,NSString *token))callBack
{

    ///开始发送
    [self.dataClient postPath:QSGetToken parameters:[QSAPIClientBase SetParams:[@{@"device":@"iOS"} mutableCopy]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///服务端响应成功，解析数据:
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSAPITokenModel objectMapping] keyPath:nil];
        QSAPITokenModel *response = (result.dictionary)[[NSNull null]];
        
        ///判断是否发送成功
        if (response.type) {
            
            callBack(YES,response.msg);
            
        } else {
            
            callBack(NO,nil);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///服务端响应失败
        callBack(NO,nil);
        
    }];

}

@end
