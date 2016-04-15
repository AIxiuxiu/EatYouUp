//
//  QSAPIClientBase+GetCoupon.m
//  Eating
//
//  Created by ysmeng on 14/12/17.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+GetCoupon.h"

@implementation QSAPIClientBase (GetCoupon)

/**
 *  @author         yangshengmeng, 14-12-17 21:12:45
 *
 *  @brief          领取优惠券
 *
 *  @param couponID 优惠券ID
 *  @param callBack 领取成功/失败的回调
 *
 *  @since          2.0
 */
- (void)getCouponWithID:(NSString *)couponID andCallBack:(void(^)(BOOL getResult,NSString *errorInfo,NSString *errorCode))callBack
{

    ///判断参数是否效
    if (0 >= [couponID intValue]) {
        
        callBack(NO,@"无效参数",nil);
        
        return;
        
    }
    
    // . setup params
    NSDictionary *dict = @{@"coup_id" : (couponID ? couponID : @"")};
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[dict mutableCopy]];
    
    //请求数据
    [self.dataClient postPath:QSAPIGetCoupon parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSGetCouponReturnData objectMapping] keyPath:nil];
        QSGetCouponReturnData *response = (result.dictionary)[[NSNull null]];
        
        //判断解析的数据，并回调
        if (callBack && response && response.type) {
            
            callBack(response.type,response.errorInfo,response.errorCode);
            
        } else {
            
            ///领取失败
            callBack(NO,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,[NSString stringWithFormat:@"%@",error],@"-1");
        
    }];

}

@end
