//
//  QSAPIClientBase+CouponList.m
//  Eating
//
//  Created by ysmeng on 14/12/10.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIClientBase+CouponList.h"

@implementation QSAPIClientBase (CouponList)

/**
 *  @author                 yangshengmeng, 15-01-05 12:01:47
 *
 *  @brief                  请求优惠券列表
 *
 *  @param couponListType   列表的类型
 *  @param page             获取第几页
 *  @param tempDict         参数字典
 *  @param callBack         回调
 *
 *  @since                  2.0
 */
- (void)getCouponListWithType:(GET_COUPONTLIST_TYPE)couponListType andPage:(int)page andParams:(NSDictionary *)tempDict andCallBack:(void(^)(BOOL flag,QSMarchantListReturnData *resultData,NSString *errorInfo,NSString *errorCode))callBack
{
    
    ///初步判断参数
    if ((nil == tempDict) || (0 == [tempDict count])) {
        
        callBack(NO,nil,@"参数无效",@"ER0021");
        return;
        
    }

    ///获取不同列表类型的参数
    NSMutableDictionary *listParamsDict = [[self getDifferentListTypeParams:couponListType andPage:1] mutableCopy];
    if (nil == listParamsDict) {
        
        ///如果不能获取有效的参数类型，不执行网络请求
        return;
        
    }
    
    ///加载其他参数
    [listParamsDict addEntriesFromDictionary:tempDict];
    
    ///封装请求参数
    NSMutableDictionary *params = [QSAPIClientBase SetParams:listParamsDict];
    ///请求的地址判断
    NSString *requestURL = [self getRequestURLWithType:couponListType];
    
    ///post请求列表数据
    [self.dataClient postPath:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ///解析数据
        RKMappingResult *result = [[RKDataObjectManager sharedManager] objectFromData:operation.responseData mapping:[QSMarchantCouponListReturnData objectMapping] keyPath:nil];
        QSMarchantCouponListReturnData *response = (result.dictionary)[[NSNull null]];
        
        ///回调
        if (([response.recordModel.marList count] > 0) && callBack) {
            
            ///重整返回数据
            NSArray *tempArray = [self combinationCouponList:response.recordModel.marList];
            if ([tempArray count] > 0) {
                
                [response.recordModel.marList removeAllObjects];
                [response.recordModel.marList addObjectsFromArray:tempArray];
                
            }
            
            callBack(YES,response.recordModel,nil,nil);
            
        } else {
            
            ///数据请求成功，但是无优惠券，则返回nil
            callBack(NO,nil,response.errorInfo,response.errorCode);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ///请求失败
        if (callBack) {
            
            callBack(NO,nil,[NSString stringWithFormat:@"%@",error],@"ER0021");
            
        }
        
    }];
    
}

/**
 *  @author         yangshengmeng, 15-01-05 13:01:16
 *
 *  @brief          返回不同的列表类型请求的URL
 *
 *  @param listType 列表类型
 *
 *  @return         返回对应的请求地址
 *
 *  @since          2.0
 */
- (NSString *)getRequestURLWithType:(GET_COUPONTLIST_TYPE)listType
{

    switch (listType) {
            
            ///个人的优惠券列表
        case MYLUNCHBOX_COUPONLIST_UNUSE_CGT:
            
        case MYLUNCHBOX_COUPONLIST_USED_CGT:
            
            return QSAPIMyMarchantCouponList;
            
            break;
            
            ///其他的优惠券列表
        default:
            
            return QSAPIMarchantCouponList;
            
            break;
    }
    
    return QSAPIMarchantCouponList;

}

/**
 *  @author        yangshengmeng, 14-12-11 09:12:05
 *
 *  @brief         将每个商户的优惠数据组合为一个数组
 *
 *  @param marList 商户数组
 *
 *  @since         2.0
 */
#pragma mark - 将每个商户的优惠数据组合为一个数组
- (NSArray *)combinationCouponList:(NSMutableArray *)marList
{
    ///遍历调整商户优惠券数组
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (QSMarchantBaseInfoDataModel *obj in marList) {
        
        obj.couponList = [[NSMutableArray alloc] init];
        
        ///整合限时优惠
        [obj.couponList addObjectsFromArray:obj.limitedTimeOfferList];
        [obj.limitedTimeOfferList removeAllObjects];
        
        ///整合菜品优惠
        [obj.couponList addObjectsFromArray:obj.foodOfferList];
        [obj.foodOfferList removeAllObjects];
        
        ///整合会员优惠
        [obj.couponList addObjectsFromArray:obj.memberDiscountList];
        [obj.memberDiscountList removeAllObjects];
        
        ///整合代金券
        [obj.couponList addObjectsFromArray:obj.voucherList];
        [obj.voucherList removeAllObjects];
        
        ///整合折扣券
        [obj.couponList addObjectsFromArray:obj.fasteningVolumeList];
        [obj.fasteningVolumeList removeAllObjects];
        
        ///整合菜品兑换券
        [obj.couponList addObjectsFromArray:obj.exchangeVolumeList];
        [obj.exchangeVolumeList removeAllObjects];
        
        ///整合个人的优惠券数组
        [obj.couponList addObjectsFromArray:obj.myCouponList];
        [obj.myCouponList removeAllObjects];
        
        ///整合储值卡
        [obj.couponList addObjectsFromArray:obj.prepaidCardList];
        [obj.prepaidCardList removeAllObjects];
        
        ///将重整后的数组放到临时结果数组中
        [resultArray addObject:obj];
        
    }
    
    ///将可变数组变成不可变数组返回
    return [NSArray arrayWithArray:resultArray];
}

/**
 *  @author yangshengmeng, 14-12-10 15:12:07
 *
 *  @brief  根据请求的列表类型，返回不同的参数
 *
 *  @param  listType 列表类型
 *
 *  @return 返回不同列表类型的字典参数
 *
 *  @since  2.0
 */
#pragma mark - 返回不同类型列表的参数
- (NSDictionary *)getDifferentListTypeParams:(GET_COUPONTLIST_TYPE)listType andPage:(int)page
{
    
    ///封装参数
    NSDictionary *paramsDict = @{@"is_old" : @"0",
                                 @"page_num" : @"5",
                                 @"now_page" : [NSString stringWithFormat:@"%d",page]};
    
    return paramsDict;
}

@end
