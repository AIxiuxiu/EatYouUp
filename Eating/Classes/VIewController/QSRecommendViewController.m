//
//  QSRecommendViewController.m
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSRecommendViewController.h"
#import "QSYVolumListViewController.h"
#import "QSPrepaidCarViewController.h"
#import "QSMarCouponListRootView.h"
#import "QSYCouponDetailViewController.h"
#import "QSYCustomHUD.h"
#import "QSPrepaidCardDetailViewController.h"
#import "QSFoodOfferDetailViewController.h"

///是否加载HUD宏
//#define __SHOW_CUSTOMHUD__

@interface QSRecommendViewController ()

@end

@implementation QSRecommendViewController

/**
 *  @author yangshengmeng, 15-01-05 11:01:08
 *
 *  @brief  初始化请求参数
 *
 *  @since  2.0
 */
- (NSDictionary *)setOriginalListParams
{
    
    NSDictionary *tempDict = @{@"0":@"1",@"1":@"2",@"2":@"3",
                               @"3":@"4",@"4":@"5",@"5":@"6",@"6":@"7"};
    
    ///封装参数
    NSDictionary *paramsDict = @{@"marker" : @"1",
                                 @"type" : tempDict,
                                 @"key" : @""};
    
    return paramsDict;
    
}

- (void)setupUI
{
    
    self.titleLabel.text = @"优惠精选";
    
    //添加显示列表
    [self createCouponListUI];
    
}

///添加优惠卷显示列表
#pragma mark - 创建优惠卷列表
- (void)createCouponListUI
{
    //优惠列表
    QSMarCouponListRootView *couponList = [[QSMarCouponListRootView alloc] initWithFrame:CGRectMake(0.0f, 150.0f, DeviceWidth, DeviceHeight-210.0f) andCouponListType:RECOMMENT_COUPONLIST_GCT andParams:[self setOriginalListParams] andCallBack:^(NSString *marchantName,NSString *marchantID,NSString *couponID,NSString *couponSubID,MYLUNCHBOX_COUPON_TYPE couponType,MYLUNCHBOX_COUPON_STATUS couponStatus) {
        
#ifndef __SHOW_CUSTOMHUD__
        //进入详情页面
        [self gotoCouponDetailVC:marchantName andMarchantID:marchantID andCouponID:couponID andCouponType:couponType andCouponStatus:couponStatus];
#endif
        
    }];
    [self.view addSubview:couponList];
    [self.view sendSubviewToBack:couponList];
}

///进入详情页面
#pragma mark - 进入详情页面
- (void)gotoCouponDetailVC:(NSString *)marchantName andMarchantID:(NSString *)marID andCouponID:(NSString *)couponID andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType andCouponStatus:(MYLUNCHBOX_COUPON_STATUS)couponStatus
{
    
    ///判断是否储值卡
    if (couponType == PREPAIDCARD_MCT) {
        
        ///进入储值卡独立详情页面
        QSPrepaidCardDetailViewController *src = [[QSPrepaidCardDetailViewController alloc] initWithMarchantName:marchantName andMarID:marID andPrepaidCardID:couponID];
        [self.navigationController pushViewController:src animated:YES];
        
        return;
    }
    
    ///判断是否是菜品:进入菜品优惠页面
    if (couponType == FOODOFF_MCT) {
        
        QSFoodOfferDetailViewController *foodOfferDetail = [[QSFoodOfferDetailViewController alloc] initWithCouponID:couponID andCouponType:couponType andCouponStatus:couponStatus];
        [self.navigationController pushViewController:foodOfferDetail animated:YES];
        
        return;
    }
    
    ///推进优惠券详情页面
    QSYCouponDetailViewController *detailVC = [[QSYCouponDetailViewController alloc] initWithMarName:marchantName andMarchantID:marID andCouponID:couponID andCouponType:couponType];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

///进入促销优惠列表页面
#pragma mark - 进入促销优惠页面
- (IBAction)onSaleQButtonAction:(id)sender
{
    QSYVolumListViewController *viewVC = [[QSYVolumListViewController alloc] init];
    [self.navigationController pushViewController:viewVC animated:YES];
}

///进入储值卡列表页面
#pragma mark - 进入储值卡页面
- (IBAction)onCardQButtonAction:(id)sender
{
    QSPrepaidCarViewController *prepaidCard = [[QSPrepaidCarViewController alloc] init];
    [self.navigationController pushViewController:prepaidCard animated:YES];
}

@end
