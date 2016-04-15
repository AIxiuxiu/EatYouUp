//
//  QSMyLunchBoxViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/3.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyLunchBoxViewController.h"
#import "QSMyDiaryNavigationMiddleItemView.h"
#import "QSLunchBoxCouponDetailViewController.h"
#import "QSMarCouponListRootView.h"

#import <objc/runtime.h>

//关联
static char UsableVolumeListKey;
static char UnUsableVolumeListKey;
static char navigationMiddleItemKey;
@interface QSMyLunchBoxViewController (){
    
}

@end

@implementation QSMyLunchBoxViewController

/**
 *  @author yangshengmeng, 15-01-05 11:01:08
 *
 *  @brief  初始化请求参数
 *
 *  @since  2.0
 */
#pragma mark - 初始化列表参数
- (NSDictionary *)setOriginalListParams:(GET_COUPONTLIST_TYPE)GET_COUPONTLIST_TYPE
{
    
    ///状态
    NSString *myCouponType = GET_COUPONTLIST_TYPE == MYLUNCHBOX_COUPONLIST_UNUSE_CGT ? @"1" : @"2";
    
    ///封装参数
    NSDictionary *paramsDict = @{@"marker" : @"0",
                                 @"type" : myCouponType,
                                 @"key" : @""};
    
    return paramsDict;
    
}

//*************************************
//             初始化/UI搭建
//*************************************
#pragma mark - 初始化/UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
    
    QSMyDiaryNavigationMiddleItemView *middleItem = [[QSMyDiaryNavigationMiddleItemView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140, 30.0f) andLeftTitle:@"可使用" andRightTitle:@"已使用" andCallBack:^(MYDETECTIVE_TOPIC_CALLBACK_TYPE actionType) {
        
        [self navigationMiddleItemAction:actionType];
        
    }];
    [self setNavigationBarMiddleView:middleItem];
}

- (void)createMainShowView
{
    [super createMainShowView];
    
    //可用与不可用子视图
    QSMarCouponListRootView *usableList = [[QSMarCouponListRootView alloc] initWithFrame:CGRectMake(0.0f, 94.0f, DeviceWidth, DeviceHeight-94.0f) andCouponListType:MYLUNCHBOX_COUPONLIST_UNUSE_CGT andParams:[self setOriginalListParams:MYLUNCHBOX_COUPONLIST_UNUSE_CGT] andCallBack:^(NSString *marchantName,NSString *marchantID, NSString *volumeID,NSString *couponSubID,MYLUNCHBOX_COUPON_TYPE couponType,MYLUNCHBOX_COUPON_STATUS couponStatus) {
        
        //进入详情页面
        [self gotoVolumeDetailWithMarchantID:marchantID andMarName:marchantName andCouponID:volumeID andCouponSubID:couponSubID andCouponType:couponType andCouponStatus:couponStatus];
        
    }];
    [self.view addSubview:usableList];
    objc_setAssociatedObject(self, &UsableVolumeListKey, usableList, OBJC_ASSOCIATION_ASSIGN);
    
    QSMarCouponListRootView *unUsableList = [[QSMarCouponListRootView alloc] initWithFrame:CGRectMake(DeviceWidth, 94.0f, DeviceWidth, DeviceHeight-94.0f) andCouponListType:MYLUNCHBOX_COUPONLIST_USED_CGT andParams:[self setOriginalListParams:MYLUNCHBOX_COUPONLIST_USED_CGT] andCallBack:^(NSString *marchantName,NSString *marchantID, NSString *volumeID,NSString *couponSubID,MYLUNCHBOX_COUPON_TYPE couponType,MYLUNCHBOX_COUPON_STATUS couponStatus) {
        
        //进入详情页面
        [self gotoVolumeDetailWithMarchantID:marchantID andMarName:marchantName andCouponID:volumeID andCouponSubID:couponSubID andCouponType:couponType andCouponStatus:couponStatus];
        
    }];
    [self.view addSubview:unUsableList];
    objc_setAssociatedObject(self, &UnUsableVolumeListKey, unUsableList, OBJC_ASSOCIATION_ASSIGN);
    
    [self addLeftAndRightGuesture];
}

//*****************************
//             获取可用/不可用
//*****************************
#pragma mark - 获取可用/不可用
- (QSMarCouponListRootView *)getUnUsableListView
{
    return (QSMarCouponListRootView *)objc_getAssociatedObject(self, &UnUsableVolumeListKey);
}

- (QSMarCouponListRootView *)getUsableListView
{
    return (QSMarCouponListRootView *)objc_getAssociatedObject(self, &UsableVolumeListKey);
}

//*****************************
//             导航栏中间按钮事件
//*****************************
#pragma mark - 导航栏中间按钮事件
- (void)navigationMiddleItemAction:(MYDETECTIVE_TOPIC_CALLBACK_TYPE)actionType
{
    switch (actionType) {
        case MYTASK_ACTIONTYPE:
            
            [self showUsableListView:YES];
            
            break;
            
        case MYDIARY_ACTIONTYPE:
            
            [self showUsableListView:NO];
            
            break;
            
        default:
            break;
    }
}

//*****************************
//             任务/日记视图切换
//*****************************
#pragma mark - 任务/日记视图切换
- (void)showUsableListView:(BOOL)flag
{
    if (flag) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self getUsableListView].frame = CGRectMake(0.0f, [self getUsableListView].frame.origin.y, [self getUsableListView].frame.size.width, [self getUsableListView].frame.size.height);
            
            [self getUnUsableListView].frame = CGRectMake(DeviceWidth, [self getUnUsableListView].frame.origin.y, [self getUnUsableListView].frame.size.width, [self getUnUsableListView].frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
        
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self getUsableListView].frame = CGRectMake(-DeviceWidth, [self getUsableListView].frame.origin.y, [self getUsableListView].frame.size.width, [self getUsableListView].frame.size.height);
        
        [self getUnUsableListView].frame = CGRectMake(0.0f, [self getUnUsableListView].frame.origin.y, [self getUnUsableListView].frame.size.width, [self getUnUsableListView].frame.size.height);
        
    }];
    [[self getUnUsableListView] couponListHeaderRefresh];
    
}

//********************************
//             任务/日记视图手势切换
//********************************
#pragma mark - 任务/日记视图手势切换
- (void)addLeftAndRightGuesture
{
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipRightAction:)];
    [swipRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipRight];
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipLeftAction:)];
    [swipLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipLeft];
}

- (void)swipLeftAction:(UISwipeGestureRecognizer *)swip
{
    //左滑显示已使用
    if ([self getUnUsableListView].frame.origin.x == 0.0f) {
        return;
    }
    
    //显示"美食日记"
    [self showUsableListView:NO];
    
    //导航栏按钮状态修改
    [self resetNavigationMiddleItemStatu];
}

- (void)swipRightAction:(UISwipeGestureRecognizer *)swip
{
    //判断"我的任务"当前是否显示
    if ([self getUsableListView].frame.origin.x == 0.0f) {
        return;
    }
    
    //显示"我的任务"
    [self showUsableListView:YES];
    [self resetNavigationMiddleItemStatu];
}

- (void)resetNavigationMiddleItemStatu
{
    QSMyDiaryNavigationMiddleItemView *nav = objc_getAssociatedObject(self, &navigationMiddleItemKey);
    [nav resetTopicButtonSelectedStyle];
}

#pragma mark - 进入详情页面
- (void)gotoVolumeDetailWithMarchantID:(NSString *)marchantID andMarName:(NSString *)marName andCouponID:(NSString *)volumeID andCouponSubID:(NSString *)couponSubID andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType andCouponStatus:(MYLUNCHBOX_COUPON_STATUS)couponStatus
{
    
    //进入详情页
    QSLunchBoxCouponDetailViewController *couponDetail = [[QSLunchBoxCouponDetailViewController alloc] initWithMarchantName:marName andMarchantID:marchantID andCouponID:volumeID andCouponSubID:couponSubID andCouponType:couponType andCouponStatus:couponStatus];
    
    ///绑定储值卡退款时，若成功则刷新数据
    couponDetail.refundCommitedCallBack = ^(int flag){
    
        if (1 == flag) {
            
            [[self getUsableListView] couponListHeaderRefresh];
            
        }
    
    };
    
    [self.navigationController pushViewController:couponDetail animated:YES];
    
}

@end
