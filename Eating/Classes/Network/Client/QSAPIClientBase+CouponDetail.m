//
//  QSAPIClientBase+CouponDetail.m
//  Eating
//
//  Created by ysmeng on 14/12/12.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+CouponDetail.h"

@implementation QSAPIClientBase (CouponDetail)

/**
 *  @author             yangshengmeng, 14-12-12 12:12:52
 *
 *  @brief              请求优惠详情
 *
 *  @param couponParam  参数：id-优惠券ID type-优惠券类型
 *  @param callBack     请求成功或失败后的回调
 *
 *  @since              2.0
 */
#pragma mark - 请求优惠详情
- (void)getCouponDetailWithID:(NSDictionary *)couponParam andCallBack:(void(^)(BOOL requestFlag,QSYCouponDetailDataModel *model,NSString *errorInfo,NSString *errorCode))callBack
{
    
    ///重调参数
    couponParam = [self resetCouponParam:couponParam];
    
    ///添加用户信息
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[couponParam mutableCopy]];
    ///post请求列表数据
    [self.dataClient postPath:QSAPIMarchantCouponDetail parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///请求成功解析数据,第一层
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSYCouponDetailReturnData objectMapping] keyPath:nil];
        
        ///取出第一层中的字典
        QSYCouponDetailReturnData *response = (result.dictionary)[[NSNull null]];
                
        ///解析效则返回，第一层中的数组（即第二层），用detailModel（继食物组的模型）装了
        if (response.detailModel && callBack) {
            
            ///回调有效数据
            callBack(YES,response.detailModel,nil,0);
            
        } else {
            
            ///返回解析失败
            callBack(NO,nil,@"数据解析失败",0);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(NO,nil,[NSString stringWithFormat:@"%@",error],0);
        
    }];
     
}

/**
 *  @author         yangshengmeng, 14-12-12 12:12:33
 *
 *  @brief          重新封装优惠券详情参数
 *
 *  @param param    原参数
 *
 *  @return         返回新的参数
 *
 *  @since          2.0
 */
- (NSDictionary *)resetCouponParam:(NSDictionary *)param
{
    NSMutableDictionary *newParam = [param mutableCopy];
    [newParam setObject:[self formatCouponTypeWithType:[[param valueForKey:@"type"] intValue]] forKey:@"type"];
    [newParam setObject:@"0" forKey:@"is_old"];
    
    return newParam;
}

- (NSString *)formatCouponTypeWithType:(MYLUNCHBOX_COUPON_TYPE)subType
{
    switch (subType) {
            
            ///集会卡
        case PREPAIDCARD_MCT:
            return @"7";
            break;
            
            ///菜品优惠
        case FOODOFF_MCT:
            
            return @"2";
            
            break;
            
            ///促销
        case TIMELIMITEDOFF_MCT:
            
            ///会员优惠
        case MEMBERDISCOUNT_MCT:
            return @"4";
            break;
            
            ///兑换卷
        case EXCHANGE_VOLUME_MCT:
            
            ///折扣卷
        case FASTENING_VOLUME_MCT:
            
            ///代金卷
        case VOUCHER_MCT:
            return @"3";
            break;
            
        default:
            break;
    }
    
    return @"0";
}

/**
 *  @author         yangshengmeng, 15-01-08 00:01:45
 *
 *  @brief          储值卡退款
 *
 *  @param params   退款参数
 *  @param callBack 退款成功或失败时的回调
 *
 *  @since          2.0
 */
#pragma mark - 储值卡退款
- (void)prepaidCardRefundWithParams:(NSDictionary *)refundDict andCallBack:(void(^)(int flag,NSString *errorInfo,NSString *errorCode))callBack
{

    /**
     *  storeCard/Back:QSAPIPrepaidCardRefund
     *  user_id 用户id
     *  id 储值卡id（个人领取到的id）
     */
    
    ///初步判断参数
    if (nil == refundDict || (0 >= [refundDict count])) {
        
        callBack(0,@"参数无效",@"ER0021");
        return;
    }
    
    ///添加用户信息
    NSMutableDictionary *params = [QSAPIClientBase SetParams:[refundDict mutableCopy]];
    
    ///post请求列表数据
    [self.dataClient postPath:QSAPIPrepaidCardRefund parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///请求成功解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSPrepaidCardRefundReturdData objectMapping] keyPath:nil];
        QSPrepaidCardRefundReturdData *response = (result.dictionary)[[NSNull null]];
        
        ///解析效则返回
        if (response.type && callBack) {
            
            ///回调有效数据
            callBack(1,response.errorInfo,response.errorCode);
            
        } else {
            
            ///返回解析失败
            callBack(2,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        callBack(0,@"网络繁忙，请稍后再试",@"ER0021");
        
    }];

}

@end
