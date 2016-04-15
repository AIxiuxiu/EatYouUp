//
//  QSPrepaidCarViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidCarViewController.h"
#import "QSPrepaidCardDetailViewController.h"
#import "QSBlockActionButton.h"
#import "QSSearchBar.h"
#import "QSVolumeTypeView.h"
#import "QSFoodTypeView.h"
#import "QSMarCouponListRootView.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"

@interface QSPrepaidCarViewController ()
{
    
    QSMarCouponListRootView *_prepaidCardListView;//!<优惠卷列表
    
    GET_COUPONTLIST_TYPE _listType;     //!<列表类型，一般是用来区分单个商户还是普通的列表
    NSMutableDictionary *_searchDict;   //!<参数字典
    
}

@end

@implementation QSPrepaidCarViewController

//*******************************************
//             初始化
//*******************************************
#pragma mark - 初始化
- (instancetype)init
{

    if (self = [super init]) {
        
        _listType = PREPAIDCARD_COUPONLIST_GCT;
        
        ///初始化参数
        _searchDict = [[NSMutableDictionary alloc] init];
        
        [self setOriginalListParams];
        
    }
    
    return self;

}

/**
 *  @author                 yangshengmeng, 14-12-23 17:12:04
 *
 *  @brief                  创建一个指定商户的储值卡列表
 *
 *  @param couponListType   列表类型：一般是指定商户的储值卡列表类型
 *  @param merchantID       商户ID
 *
 *  @return                 返回一个储值卡列表
 *
 *  @since                  2.0
 */
- (instancetype)initWithCouponListType:(GET_COUPONTLIST_TYPE)couponListType andMerchantID:(NSString *)merchantID
{

    if (self = [super init]) {
        
        ///保存列表类型
        _listType = couponListType;
        
        ///初始化参数
        _searchDict = [[NSMutableDictionary alloc] init];
        
        ///保存商户ID
        [_searchDict setObject:merchantID forKey:@"merchant_id"];
        
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
    
    NSDictionary *tempDict = @{@"6":@"7"};
    
    ///封装参数
    NSDictionary *paramsDict = @{@"marker" : @"0",
                                 @"type" : tempDict,
                                 @"key" : @""};
    
    [_searchDict addEntriesFromDictionary:paramsDict];
    
}

//*******************************************
//             UI搭建
//*******************************************
#pragma mark - UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
    
    //添加搜索栏
    QSSearchBar *searchBar = [[QSSearchBar alloc] initWithFrame:CGRectMake(50.0f, 0.0f, DeviceWidth-100.0f, 30.0f) andCallBack:^(SEARCHBAR_ACTION_TYPE actionType, NSString *result) {
        
        ///如果是商户列表，则不处理
        if (_listType == MERCHANT_PREPAIDCARD_COUPONLIST_CGT) {
            
            return;
            
        }
        
        [self searchBarCallBackAction:actionType andInput:result];
        
    }];
    [self setNavigationBarMiddleView:searchBar];
}

- (void)createMainShowView
{    
    ///添加channel栏
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1.0f, 64.0f, DeviceWidth+1, 35.0f)];
    imageView.image = [UIImage imageNamed:@"prepaidcard_channel_image"];
    [self.view addSubview:imageView];
    
    ///创建过滤按钮
    [self createChannelButton];
    
    ///判断是否是加载单个列表的储值卡列表
    _prepaidCardListView = [[QSMarCouponListRootView alloc] initWithFrame:CGRectMake(0.0f, 120.0f, DeviceWidth, DeviceHeight-120.0f) andCouponListType:_listType andParams:_searchDict andCallBack:^(NSString *marchantName, NSString *marchantID, NSString *volumeID, NSString *couponSubID, MYLUNCHBOX_COUPON_TYPE couponType, MYLUNCHBOX_COUPON_STATUS couponStatus) {
        
        //进入详情页面
        [self gotoPrepaidCardDetailVC:marchantName andMarID:marchantID andCardID:volumeID];
        
    }];
    [self.view addSubview:_prepaidCardListView];
    [self.view sendSubviewToBack:_prepaidCardListView];
    
}

//创建过滤按钮
- (void)createChannelButton
{
    CGFloat xpoint = DeviceWidth / 2.0f - 44.0f - 22.0f - 40.0f;
    
    ///所有弹窗口的指针
    __block QSFoodTypeView *rankingTypeView;
    __block QSFoodTypeView *foodTypeView;
    __block QSFoodTypeView *distanceTypeView;
    
    //排序
    UIButton *customButton = [UIButton createBlockActionButton:CGRectMake(xpoint, 64.0f+4, 44.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///判断是否是商户列表
        if (_listType == MERCHANT_PREPAIDCARD_COUPONLIST_CGT) {
            
            return;
            
        }
        
        ///所有的弹窗回收
        [foodTypeView hiddenFoodTypeView];
        foodTypeView = nil;
        [distanceTypeView hiddenFoodTypeView];
        distanceTypeView = nil;
        
        //判断状态，如果当前已推出，则返回
        if (rankingTypeView) {
            
            [rankingTypeView hiddenFoodTypeView];
            rankingTypeView = nil;
            
            return;
        }
        
        int currentIndex = [_searchDict valueForKey:@"order_index"] ? [[_searchDict valueForKey:@"order_index"] intValue] : 0;
        rankingTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"不限",@"评价最高",@"最新发布",@"人气最高",@"价格最低",@"价格最高"] andYPoint:74.0f andAboveView:_prepaidCardListView andCurrentIndex:currentIndex andCallBack:^(NSString *type,int index) {
            
            ///如果是没选择排序，则直接返回
            if (index == -1) {
                
                rankingTypeView = nil;
                return;
                
            }
            
            ///评价最高
            if (1 == index){
                
                [_searchDict setObject:@"1001" forKey:@"order"];
                [_searchDict setObject:@"1" forKey:@"order_index"];
                button.selected = YES;
                
                ///最新发布
            } else if (2 == index){
                
                [_searchDict setObject:@"1002" forKey:@"order"];
                [_searchDict setObject:@"2" forKey:@"order_index"];
                button.selected = YES;
                
                ///人气最高
            } else if (3 == index){
                
                [_searchDict setObject:@"1003" forKey:@"order"];
                [_searchDict setObject:@"3" forKey:@"order_index"];
                button.selected = YES;
                
                ///价格最低
            } else if (4 == index){
                
                [_searchDict setObject:@"1004" forKey:@"order"];
                [_searchDict setObject:@"4" forKey:@"order_index"];
                button.selected = YES;
                
                ///价格最高
            } else if (5 == index){
                
                [_searchDict setObject:@"1005" forKey:@"order"];
                [_searchDict setObject:@"5" forKey:@"order_index"];
                button.selected = YES;
                
                ///选择不限时，删除排序条件
            } else {
                
                ///删除排序关键字
                [_searchDict removeObjectForKey:@"order"];
                [_searchDict removeObjectForKey:@"order_index"];
                button.selected = NO;
                
            }
            
            ///接取到所选择的排序
            [_prepaidCardListView couponListSearchRefresh:_searchDict];
            
            ///弹回去的时候，重置指针
            rankingTypeView = nil;
            
        }];
        [rankingTypeView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
        
    }];
    [customButton setImage:[UIImage imageNamed:@"prepaidcard_topic_all_normal"] forState:UIControlStateNormal];
    [customButton setImage:[UIImage imageNamed:@"prepaidcard_topic_all_highlighted"] forState:UIControlStateSelected];
    [self.view addSubview:customButton];
    
    //菜种
    UIButton *foodTypeButton = [UIButton createBlockActionButton:CGRectMake(xpoint+44.0f+40.0f, 64.0f+14.0f, 44.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///判断是否是商户列表
        if (_listType == MERCHANT_PREPAIDCARD_COUPONLIST_CGT) {
            
            return;
            
        }
        
        ///所有的弹窗回收
        [rankingTypeView hiddenFoodTypeView];
        rankingTypeView = nil;
        [distanceTypeView hiddenFoodTypeView];
        distanceTypeView = nil;
        
        //如果已推出美食类型，则不再推出
        if (foodTypeView) {
            
            [foodTypeView hiddenFoodTypeView];
            foodTypeView = nil;
            
            return;
        }
        
        int currentIndex = [_searchDict valueForKey:@"flavor_index"] ? [[_searchDict valueForKey:@"flavor_index"] intValue] : 0;
        foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"不限",@"粤菜",@"西餐",@"东南亚菜",@"东北菜",@"台湾菜"] andYPoint:74.0f andAboveView:_prepaidCardListView andCurrentIndex:currentIndex andCallBack:^(NSString *keyString,int index){
            
            ///如果是没选择菜品，则直接返回
            if (index == -1) {
                
                foodTypeView = nil;
                return;
            }
            
            ///刷新数据
            if (index == 0) {
                
                [_searchDict removeObjectForKey:@"flavor"];
                [_searchDict setObject:[NSString stringWithFormat:@"%d",index] forKey:@"flavor_index"];
                button.selected = NO;
                
            } else {
                
                [_searchDict setObject:keyString forKey:@"flavor"];
                [_searchDict setObject:[NSString stringWithFormat:@"%d",index] forKey:@"flavor_index"];
                button.selected = YES;
                
            }
            
            ///接取到所选择的菜品
            [_prepaidCardListView couponListSearchRefresh:_searchDict];
            
            ///弹回去的时候，重置指针
            foodTypeView = nil;
            
        }];
        [foodTypeView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
        
    }];
    [foodTypeButton setImage:[UIImage imageNamed:@"prepaidcard_topic_foodtype_normal"] forState:UIControlStateNormal];
    [foodTypeButton setImage:[UIImage imageNamed:@"prepaidcard_topic_foodtype_highlighted"] forState:UIControlStateSelected];
    [self.view addSubview:foodTypeButton];
    
    ///距离
    UIButton *distanceButton = [UIButton createBlockActionButton:CGRectMake(xpoint+44.0f*2+40.0f*2, 64.0f+4, 44.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///判断是否是商户列表
        if (_listType == MERCHANT_PREPAIDCARD_COUPONLIST_CGT) {
            
            return;
            
        }
        
        ///所有的弹窗回收
        [rankingTypeView hiddenFoodTypeView];
        rankingTypeView = nil;
        [foodTypeView hiddenFoodTypeView];
        foodTypeView = nil;
        
        ///如若本身已弹出，则直接回收
        if (distanceTypeView) {
            
            [distanceTypeView hiddenFoodTypeView];
            distanceTypeView = nil;
            
            return;
            
        }
        
        ///弹出距离选择框
        int currentIndex = [_searchDict valueForKey:@"distance_index"] ? [[_searchDict valueForKey:@"distance_index"] intValue] : 0;
        distanceTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"不限",@"500m",@"1000m",@"2000m"] andYPoint:74.0f andAboveView:_prepaidCardListView andCurrentIndex:currentIndex andCallBack:^(NSString *type, int index) {
            
            ///如果是直接返回，未选择，不进行任务处理
            if (index == -1) {
                
                distanceTypeView = nil;
                return;
            }
            
            ///刷新数据
            if (index == 0) {
                
                [_searchDict removeObjectForKey:@"_long"];
                [_searchDict removeObjectForKey:@"_lat"];
                [_searchDict removeObjectForKey:@"distance"];
                [_searchDict removeObjectForKey:@"distance_index"];
                button.selected = NO;
                
            } else {
                
                NSString *userLongitude = [NSString stringWithFormat:@"%.2f",[UserManager sharedManager].userData.location.longitude];
                NSString *userLatitude = [NSString stringWithFormat:@"%.2f",[UserManager sharedManager].userData.location.latitude];
                
                [_searchDict setObject:userLongitude forKey:@"_long"];
                [_searchDict setObject:userLatitude forKey:@"_lat"];
                [_searchDict setObject:type forKey:@"distance"];
                [_searchDict setObject:[NSString stringWithFormat:@"%d",index] forKey:@"distance_index"];
                button.selected = YES;
                
            }
            
            ///刷新数据
            [_prepaidCardListView couponListSearchRefresh:_searchDict];
            
            ///弹回去的时候，重置指针
            distanceTypeView = nil;
            
        }];
        [distanceTypeView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
        
    }];
    [distanceButton setImage:[UIImage imageNamed:@"prepaidcard_topic_distance_normal"] forState:UIControlStateNormal];
    [distanceButton setImage:[UIImage imageNamed:@"prepaidcard_topic_distance_highlighted"] forState:UIControlStateSelected];
    [self.view addSubview:distanceButton];
    
}

//*******************************************
//             进入详情页面
//*******************************************
#pragma mark - 进入详情页面
- (void)gotoPrepaidCardDetailVC:(NSString *)marchantName andMarID:(NSString *)marID andCardID:(NSString *)cardID
{
    QSPrepaidCardDetailViewController *src = [[QSPrepaidCardDetailViewController alloc] initWithMarchantName:marchantName andMarID:marID andPrepaidCardID:cardID];
    [self.navigationController pushViewController:src animated:YES];
}

//******************************
//             搜索事件
//******************************
#pragma mark - 搜索事件
- (void)searchBarCallBackAction:(SEARCHBAR_ACTION_TYPE)actionType andInput:(NSString *)inputString
{
    switch (actionType) {
        case SEARCH_ACTION_SAT:
            
            ///关键字刷新
            [_searchDict setObject:inputString ? : @"" forKey:@"key"];
            [_prepaidCardListView couponListSearchRefresh:_searchDict];
            
            break;
            
        case DIDBEGINEDIT_SAT:
            
            
            
            break;
            
        case TEXTCHANGED_SAT:
            
            
            
            break;
            
        case DIDENDEDITING_SAT:
            
            
            
            break;
            
        case CLEARINPUT_SAT:
            
            [_searchDict setObject:@"" forKey:@"key"];
            
            break;
            
        default:
            
            
            
            break;
    }
}

#pragma mark - 点击主窗体时回收键盘通知
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sendTouchBeganAction:touches withEvent:event];
}

@end