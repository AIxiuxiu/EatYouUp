//
//  QSNormalRecommendViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/23.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSNormalRecommendViewController.h"
#import "QSImageView.h"
#import "QSBottomTitleBlockButton.h"
#import "QSYVolumListViewController.h"
#import "QSPrepaidCarViewController.h"
#import "QSMarCouponListRootView.h"
#import "QSYCouponDetailViewController.h"
#import "QSPrepaidCardDetailViewController.h"
#import "QSFoodOfferDetailViewController.h"

@interface QSNormalRecommendViewController (){

    NSMutableDictionary *_searchDict;///商户参数

}

@end

@implementation QSNormalRecommendViewController

/**
 *  @author             yangshengmeng, 14-12-23 14:12:03
 *
 *  @brief              根据给定的商户ID，列出对应商户的优惠页面
 *
 *  @param merchantID   商户ID
 *
 *  @return             返回当前列表对象
 *
 *  @since              2.0
 */
- (instancetype)initWithMerchantID:(NSString *)merchantID
{

    if (self = [super init]) {
        
        ///保存商户ID
        _searchDict = [[NSMutableDictionary alloc] init];
        [_searchDict setObject:merchantID forKey:@"merchant_id"];
        
        ///初始化参数
        [self setOriginalListParams];
        
    }
    
    return self;

}

/**
 *  @author yangshengmeng, 15-01-05 11:01:08
 *
 *  @brief  初始化请求参数
 *
 *  @since  2.0
 */
- (void)setOriginalListParams
{
    
    NSDictionary *tempDict = @{@"0":@"1",@"1":@"2",@"2":@"3",
                               @"3":@"4",@"4":@"5",@"5":@"6",@"6":@"7"};
    
    ///封装参数
    NSDictionary *paramsDict = @{@"marker" : @"0",
                                 @"type" : tempDict,
                                 @"key" : @""};
    
    [_searchDict addEntriesFromDictionary:paramsDict];
    
}

///设置标题
- (void)createNavigationBar
{

    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"优惠精选"];

}

///创建主展示UI
- (void)createMainShowView
{

    ///优惠促销和储值卡按钮:top_index
    QSImageView *topView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, 86.0f)];
    topView.image = [UIImage imageNamed:@"top_index"];
    [self createTopIndexButton:topView];
    [self.view addSubview:topView];
    
    ///列表
    QSMarCouponListRootView *couponList = [[QSMarCouponListRootView alloc] initWithFrame:CGRectMake(0.0f, 150.0f, DeviceWidth, DeviceHeight-150.0f) andCouponListType:MERCHANT_COUPONLIST_CGT andParams:_searchDict andCallBack:^(NSString *marchantName, NSString *marchantID, NSString *volumeID, NSString *couponSubID, MYLUNCHBOX_COUPON_TYPE couponType, MYLUNCHBOX_COUPON_STATUS couponStatus) {
        
        ///进入优惠券详情页面
        [self gotoCouponDetailVC:marchantName andMarchantID:marchantID andCouponID:volumeID andCouponType:couponType andCouponStatus:couponStatus];
        
    }];
    [self.view addSubview:couponList];
    [self.view sendSubviewToBack:couponList];

}

/**
 *  @author     yangshengmeng, 14-12-23 14:12:44
 *
 *  @brief      创建优惠促销/储值卡按钮
 *
 *  @param view 底view
 *
 *  @since      2.0
 */
- (void)createTopIndexButton:(UIView *)view
{

    ///优惠按钮:main_book_btn 90 x 50
    CGFloat subMiddleXPoint = DeviceWidth/4.0f;
    CGFloat ypoint = (view.frame.size.height-70.0f)/2.0f;
    UIButton *couponListButton = [UIButton createBottomTitleButton:CGRectMake(subMiddleXPoint-45.0f, ypoint, 90.0f, 65.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入优惠券页面
        QSYVolumListViewController *volumListVC = [[QSYVolumListViewController alloc] initWithListType:MERCHANT_VOLUME_COUPONLIST_CGT andMerchantID:[_searchDict valueForKey:@"merchant_id"]];
        [self.navigationController pushViewController:volumListVC animated:YES];
        
    }];
    [couponListButton setTitle:@"促销优惠" forState:UIControlStateNormal];
    [couponListButton setImage:[UIImage imageNamed:@"main_book_btn"] forState:UIControlStateNormal];
    couponListButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    couponListButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:couponListButton];
    
    ///储值卡按钮:main_take_btn
    UIButton *prepaidCardListButton = [UIButton createBottomTitleButton:CGRectMake(view.frame.size.width - subMiddleXPoint-45.0f, ypoint, 90.0f, 65.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入优惠券页面
        QSPrepaidCarViewController *prepaidCard = [[QSPrepaidCarViewController alloc] initWithCouponListType:MERCHANT_PREPAIDCARD_COUPONLIST_CGT andMerchantID:[_searchDict valueForKey:@"merchant_id"]];
        [self.navigationController pushViewController:prepaidCard animated:YES];
        
    }];
    [prepaidCardListButton setTitle:@"储值卡优惠" forState:UIControlStateNormal];
    [prepaidCardListButton setImage:[UIImage imageNamed:@"main_take_btn"] forState:UIControlStateNormal];
    prepaidCardListButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    prepaidCardListButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:prepaidCardListButton];
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2.0f-0.5f, ypoint, 1.0f, 70.0f)];
    sepLabel.backgroundColor = kBaseOrangeColor;
    [view addSubview:sepLabel];
    
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

@end
