//
//  QSAPIClientBase.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "QSAPIModel.h"
#import "QSAPI.h"
#import "RestKit.h"
#import "RKDataObjectManager.h"
#import "UserManager.h"

@interface QSAPIClientBase : NSObject

@property (nonatomic, strong) AFHTTPClient *authClient;
@property (nonatomic, strong) AFHTTPClient *dataClient;

@property (nonatomic, strong) NSString *sessionId;

+ (id)sharedHTTPClient;
+ (id)sharedClient;

+(NSMutableDictionary *)SetParams:(NSMutableDictionary*)params;

/**
 *  @author         yangshengmeng, 14-12-18 14:12:38
 *
 *  @brief          返回一个没有用户ID的post参数
 *
 *  @param params   传进来的参数
 *
 *  @return         返回参数串
 *
 *  @since          2.0
 */
+(NSMutableDictionary *)SetParamsWithoutUserID:(NSMutableDictionary*)params;

/**
 *  @author         yangshengmeng, 14-12-24 15:12:00
 *
 *  @brief          对一个已经有用户ID的参数进行封装
 *
 *  @param params   给定的原参数
 *
 *  @return         返回一个新的请求参数
 *
 *  @since          2.0
 */
+(NSMutableDictionary *)SetParamsUnchangeUserID:(NSMutableDictionary*)params;

@end
