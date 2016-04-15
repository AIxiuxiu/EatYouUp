//
//  QSAPIClientBase.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"
#import "QSAPI.h"
#import "AFHTTPClientLogger.h"
#import <CommonCrypto/CommonDigest.h>
#import "UserManager.h"
#import "QSAPIModel+User.h"

static const NSString *mkey = @"mmzybydxwdjcl";

@implementation QSAPIClientBase

+ (id)sharedHTTPClient {
    static dispatch_once_t pred;
    static AFHTTPClient *shared_instance = nil;
    
    dispatch_once(&pred, ^{
        
        ///检测是否用域名地址
        NSData *checkData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.77cdn.net/site/t"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f] returningResponse:nil error:nil];
        
        NSString *urlString;
        
        if (checkData && (5 < [checkData length])) {
            
            urlString = QSAPIBaseUrlDomain;
            [[NSUserDefaults standardUserDefaults] setObject:@"admin.77cdn.net/files/" forKey:@"default_file_super_url"];
            
        } else {
        
            urlString = QSAPIBaseUrlIP;
            [[NSUserDefaults standardUserDefaults] setObject:@"http://117.41.235.110:8888/files/" forKey:@"default_file_super_url"];
        
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        shared_instance = [[self alloc] init];
        shared_instance = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:urlString]];
        
        shared_instance.defaultSSLPinningMode = AFSSLPinningModeNone;
        shared_instance.allowsInvalidSSLCertificate = YES;
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
        [shared_instance registerHTTPOperationClass:[AFJSONRequestOperation class]];
        shared_instance.parameterEncoding = AFJSONParameterEncoding;
        
        shared_instance.logger.enabled = YES;
        shared_instance.logger.level = AFHTTPClientLogLevelDebug;
    });
    
    return shared_instance; 
}

+ (id)sharedClient {
    static dispatch_once_t pred;
    static QSAPIClientBase *shared_instance = nil;
    
    dispatch_once(&pred, ^{
        shared_instance = [[self alloc] init];
        shared_instance.authClient = [self sharedHTTPClient];
    });
    
    return shared_instance;
}

- (AFHTTPClient *)dataClient {
    
    if (!_dataClient) {
        NSURL *dataURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.authClient.baseURL.absoluteString]];
        
        _dataClient = [AFHTTPClient clientWithBaseURL:dataURL];
        
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/x-www-form-urlencoded"]];
        [_dataClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        _dataClient.parameterEncoding = AFFormURLParameterEncoding;
        
    }
    
    return _dataClient;
}

/**
 *  @author         yangshengmeng, 14-12-24 15:12:03
 *
 *  @brief          封装默认的请求参数：添加用户ID和手机号码
 *
 *  @param params   原参数
 *
 *  @return         返回一个新封装的请求参数
 *
 *  @since          2.0
 */
+(NSMutableDictionary*)SetParams:(NSMutableDictionary*)params
{
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    NSString *t = [NSString stringWithFormat:@"%li",(long)timestamp];
    
    QSUserData *userData = [UserManager sharedManager].userData;
    if (userData.user_id.length > 0) {
        [params setValue:userData.user_id forKey:@"user_id"];
    }else{
        [params setValue:@"0" forKey:@"user_id"];
    }
    [params setValue:userData.iphone ? userData.iphone : @"1" forKeyPath:@"iphone"];
    NSString *d;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        d = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    }
    
    NSString *k_key = [t stringByAppendingString:mkey];
    NSString *k_temp = [d stringByAppendingString:k_key];
    NSString *k = [QSAPIClientBase md5:k_temp];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setValue:k forKey:@"k"];
    [data setValue:d forKey:@"d"];
    [data setValue:t forKey:@"t"];
    
    return data;
}

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
+(NSMutableDictionary*)SetParamsWithoutUserID:(NSMutableDictionary*)params
{
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    NSString *t = [NSString stringWithFormat:@"%li",(long)timestamp];
    
    [params setValue:@"0" forKey:@"user_id"];
    [params setValue:@"1" forKeyPath:@"phone"];
    NSString *d;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        d = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    }
    
    NSString *k_key = [t stringByAppendingString:mkey];
    NSString *k_temp = [d stringByAppendingString:k_key];
    NSString *k = [QSAPIClientBase md5:k_temp];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setValue:k forKey:@"k"];
    [data setValue:d forKey:@"d"];
    [data setValue:t forKey:@"t"];
    
    return data;
}

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
+(NSMutableDictionary*)SetParamsUnchangeUserID:(NSMutableDictionary*)params
{
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    NSString *t = [NSString stringWithFormat:@"%li",(long)timestamp];
    
    [params setValue:@"1" forKeyPath:@"phone"];
    NSString *d;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        d = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    }
    
    NSString *k_key = [t stringByAppendingString:mkey];
    NSString *k_temp = [d stringByAppendingString:k_key];
    NSString *k = [QSAPIClientBase md5:k_temp];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setValue:k forKey:@"k"];
    [data setValue:d forKey:@"d"];
    [data setValue:t forKey:@"t"];
    
    return data;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
