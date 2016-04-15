//
//  QSFoodGroudViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodGroudViewController.h"
#import "QSNormalNavigationBar.h"
#import "QSBlockActionButton.h"
#import "QSNormalTabBar.h"
#import "MJRefresh.h"
#import "QSFoodGroudTableViewCell.h"
#import "QSAPIClientBase+FoodGroud.h"
#import "QSFoodTypeView.h"
#import "QSNewFoodGroudViewController.h"
#import "QSNewFoodGroudModel.h"
#import "QSAPIModel+User.h"
#import "QSFoodGroudDetailViewController.h"
#import "QSBookFillFormViewController.h"
#import "QSAPIModel+Merchant.h"
#import "QSMapNavViewController.h"
#import "QSImageView.h"
#import "SocaialManager.h"

#import <objc/runtime.h>

///关联
static char FoodGroudListKey;//!<搭吃团列表key

@interface QSFoodGroudViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *_dataSource;            //!<搭食团列表数组

    int _page;                              //!<记录当前页码
    int _currentPage;                       //!<记录当前页
    
    int _isAuthor;                          //!<当前的搭食团是否当前用户创建的
    
    TABBAR_MIDDLEBUTTON_STYLE _middleStatus;//!<中间按钮的状态
    
    FOODGROUD_LIST_TYPE _listType;          //!<列表类型：个人/普通
    
    NSMutableDictionary *_searchKey;        //!<搜索条件
    
}

@end

@implementation QSFoodGroudViewController

//*******************************
//             初始化及UI搭建
//*******************************
#pragma mark - 初始化及UI搭建
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        ///初始化页码
        _page = 1;
        
        _isAuthor = 0;
        _middleStatus = DEFAULT_TMS;
        
        ///初始化数据源
        _dataSource = [[NSMutableArray alloc] init];
        
        ///初始化搜索条件容器
        _searchKey = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;

}

/**
 *  @author         yangshengmeng, 14-12-21 20:12:22
 *
 *  @brief          根据传入的列表类型(个人/普通)创建列表类型
 *
 *  @param listType 列表类型：个人/默认
 *
 *  @return         返回搭食团列表
 *
 *  @since          2.0
 */
- (instancetype)initWithType:(FOODGROUD_LIST_TYPE)listType
{

    if (self = [super init]) {
        
        ///保存类型
        _listType = listType;
        
    }
    
    return self;

}

/**
 *  @author             yangshengmeng, 15-01-04 13:01:23
 *
 *  @brief              获取指定商户的搭食团列表
 *
 *  @param listType     列表类型
 *  @param merchantID   商户的ID
 *
 *  @return             返回当前列表
 *
 *  @since              2.0
 */
- (instancetype)initWithType:(FOODGROUD_LIST_TYPE)listType andMerchantID:(NSString *)merchantID
{

    if (self = [super init]) {
        
        ///保存类型
        _listType = listType;
        
        [_searchKey setObject:merchantID forKey:@"merchant_id"];
        
    }
    
    return self;

}

//创建导航栏
- (void)createNavigationBar
{
    //创建navigation：640 × 172
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"搭吃团"];
    
    //导航栏定位按钮
    QSButtonStyleModel *buttonStyle = [QSButtonStyleModel createLocationButtonStyle];
    UIButton *locationButton = [UIButton createBlockActionButton:fNavigationBarRightViewFrame andStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///获取商户的信息
        NSDictionary *merchantInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"foodgroud_merchant"];
        
        QSMapNavViewController *viewVC = [[QSMapNavViewController alloc] init];
        QSMerchantListReturnData *info = [[QSMerchantListReturnData alloc] init];
        QSMerchantDetailData *merchantModel = [[QSMerchantDetailData alloc] init];
        
        ///设置商户相关的信息
        merchantModel.latitude = [merchantInfo objectForKey:@"merchantLat"];
        merchantModel.longitude = [merchantInfo objectForKey:@"merchantLong"];
        merchantModel.merchant_name = [merchantInfo objectForKey:@"merchantName"];
        merchantModel.merchant_id = [merchantInfo objectForKey:@"merchantID"];
        merchantModel.address = [merchantInfo objectForKey:@"merchantAddress"];
        
        NSMutableArray *data = [[NSMutableArray alloc] init];
        [data addObject:merchantModel];
        info.msg = data;
        viewVC.merchantListReturnData = info;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    }];
    
    [self setNavigationBarRightView:locationButton];
    
}

//创建中间展现视图
- (void)createMainShowView
{
    ///取消自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ///导航栏底图
    QSImageView *channleRootView = [[QSImageView alloc] initWithFrame:CGRectMake(-1.0f, 64.0f, DeviceWidth+1, 35.0f)];
    channleRootView.image = [UIImage imageNamed:@"prepaidcard_channel_image.png"];
    [self.view addSubview:channleRootView];
    
    ///搭吃团列表
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 73.0f, DeviceWidth, DeviceHeight-114.0f)];
    
    ///取消滚动条
    tabelView.showsHorizontalScrollIndicator = NO;
    tabelView.showsVerticalScrollIndicator = NO;
    
    ///添加头/脚部刷新
    [tabelView addHeaderWithTarget:self action:@selector(getFoodGroudHeaderData)];
    [tabelView addFooterWithTarget:self action:@selector(getFoodGroudFooterData)];
    [tabelView headerBeginRefreshing];
    
    ///代理和数据源
    tabelView.dataSource = self;
    tabelView.delegate = self;
    
    ///每次翻一页
    tabelView.pagingEnabled = YES;
    
    ///取消分隔线
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tabelView];
    [self.view sendSubviewToBack:tabelView];
    
    objc_setAssociatedObject(self, &FoodGroudListKey, tabelView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加导航栏按钮
    [self createNavigationBarChannelButton:tabelView];
    
}

///创建导航栏的按钮
- (void)createNavigationBarChannelButton:(UIView *)tabelView
{
    
    CGFloat gap = (DeviceWidth - 44.0f * 4.0f) / 5.0f;
    
    ///各个弹出框的暂时指针
    __block QSFoodTypeView *distantceView;
    __block QSFoodTypeView *foodTypeView;
    __block QSFoodTypeView *limitedView;
    __block QSFoodTypeView *rankTypeView;
    
    ///距离
    UIButton *distanceButton = [UIButton createBlockActionButton:CGRectMake(gap, 64.0f, 44.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///如果是单个商户的列表，不需要进行过滤
        if (_listType == MERCHANT_ALL_FLT) {
            
            return;
            
        }
        
        if (distantceView) {
            
            [distantceView hiddenFoodTypeView];
            distantceView = nil;
            
            return;
        }
        
        ///回收其他视图
        [distantceView hiddenFoodTypeView];
        distantceView = nil;
        [foodTypeView hiddenFoodTypeView];
        foodTypeView = nil;
        [limitedView hiddenFoodTypeView];
        limitedView = nil;
        [rankTypeView hiddenFoodTypeView];
        rankTypeView = nil;
        
        ///菜品
        int distanceIndex = [_searchKey objectForKey:@"distance_index"] ? [[_searchKey objectForKey:@"distance_index"] intValue] : 0;
        distantceView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"从近到远",@"500",@"1000",@"1500",@"2000",@"2500"] andYPoint:74.0f andAboveView:tabelView andCurrentIndex:distanceIndex andCallBack:^(NSString *type, int index) {
            
            ///如果是没选择菜品，则直接返回
            if (index == -1) {
                return;
            }
            
            ///刷新数据
            if (index == 0) {
                
                [_searchKey removeObjectForKey:@"_long"];
                [_searchKey removeObjectForKey:@"_lat"];
                [_searchKey removeObjectForKey:@"distance"];
                [_searchKey removeObjectForKey:@"distance_index"];
                button.selected = NO;
                
            } else {
                
                NSString *userLongitude = [NSString stringWithFormat:@"%.2f",[UserManager sharedManager].userData.location.longitude];
                NSString *userLatitude = [NSString stringWithFormat:@"%.2f",[UserManager sharedManager].userData.location.latitude];
            
                [_searchKey setObject:userLongitude forKey:@"_long"];
                [_searchKey setObject:userLatitude forKey:@"_lat"];
                [_searchKey setObject:type forKey:@"distance"];
                [_searchKey setObject:[NSString stringWithFormat:@"%d",index] forKey:@"distance_index"];
                button.selected = YES;
            
            }
        
            [self beginUITableViewHeaderRefresh];
            distantceView = nil;
            
        }];
        [distantceView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
        
    }];
    [distanceButton setImage:[UIImage imageNamed:@"foodgroud_local_normal"] forState:UIControlStateNormal];
    [distanceButton setImage:[UIImage imageNamed:@"foodgroud_local_highlighted"] forState:UIControlStateSelected];
    [self.view addSubview:distanceButton];
    
    //菜种
    UIButton *foodTypeButton = [UIButton createBlockActionButton:CGRectMake(distanceButton.frame.origin.x+distanceButton.frame.size.width+gap, distanceButton.frame.origin.y+8.0f, 44.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///如果是单个商户的列表，不需要进行过滤
        if (_listType == MERCHANT_ALL_FLT) {
            
            return;
            
        }
        
        if (foodTypeView) {
            
            [foodTypeView hiddenFoodTypeView];
            foodTypeView = nil;
            
            return;
        }
        
        ///回收其他视图
        [distantceView hiddenFoodTypeView];
        distantceView = nil;
        [foodTypeView hiddenFoodTypeView];
        foodTypeView = nil;
        [limitedView hiddenFoodTypeView];
        limitedView = nil;
        [rankTypeView hiddenFoodTypeView];
        rankTypeView = nil;
        
        ///菜品
        int foodTypeIndex = [_searchKey objectForKey:@"flavor_index"] ? [[_searchKey objectForKey:@"flavor_index"] intValue] : 0;
        foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"不限",@"粤菜",@"西餐",@"东南亚菜",@"东北菜",@"台湾菜"] andYPoint:74.0f andAboveView:tabelView andCurrentIndex:foodTypeIndex andCallBack:^(NSString *type, int index) {
            
            ///如果是没选择菜品，则直接返回
            if (index == -1) {
                return;
            }
            
            ///刷新数据
            if (index == 0) {
                
                [_searchKey removeObjectForKey:@"flavor"];
                [_searchKey removeObjectForKey:@"flavor_index"];
                button.selected = NO;
                
            } else {
            
                [_searchKey setObject:type forKey:@"flavor"];
                [_searchKey setObject:[NSString stringWithFormat:@"%d",index] forKey:@"flavor_index"];
                button.selected = YES;
            
            }
            [distantceView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
            [self beginUITableViewHeaderRefresh];
            foodTypeView = nil;
            
        }];
        [foodTypeView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
        
    }];
    [foodTypeButton setImage:[UIImage imageNamed:@"foodgroud_foodtopic_normal"] forState:UIControlStateNormal];
    [foodTypeButton setImage:[UIImage imageNamed:@"foodgroud_foodtopic_highlighted"] forState:UIControlStateSelected];
    [self.view addSubview:foodTypeButton];
    
    ///限制条件
    UIButton *limitedButton = [UIButton createBlockActionButton:CGRectMake(foodTypeButton.frame.origin.x+foodTypeButton.frame.size.width+gap, distanceButton.frame.origin.y+8.0f, 44.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///如果是单个商户的列表，不需要进行过滤
        if (_listType == MERCHANT_ALL_FLT) {
            
            return;
            
        }
        
        if (limitedView) {
            
            [limitedView hiddenFoodTypeView];
            limitedView = nil;
            
            return;
        }
        
        ///回收其他视图
        [distantceView hiddenFoodTypeView];
        distantceView = nil;
        [foodTypeView hiddenFoodTypeView];
        foodTypeView = nil;
        [limitedView hiddenFoodTypeView];
        limitedView = nil;
        [rankTypeView hiddenFoodTypeView];
        rankTypeView = nil;
        
        ///限制条件
        int selectedIndex = 0;
        if ([_searchKey objectForKey:@"team_sex_type"]) {
            
            if ([[_searchKey objectForKey:@"team_sex_type"] isEqualToString:@"男"]) {
                
                selectedIndex = 1;
                
            } else {
            
                selectedIndex = 2;
            
            }
            
        }
        limitedView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"不限",@"男",@"女"] andYPoint:74.0f andAboveView:tabelView andCurrentIndex:selectedIndex andCallBack:^(NSString *type, int index) {
            
            ///刷新数据
            if (index == 0) {
                
                [_searchKey removeObjectForKey:@"team_sex_type"];
                button.selected = NO;
                
            } else {
            
                [_searchKey setObject:type forKey:@"team_sex_type"];
                button.selected = YES;
            
            }
            [self beginUITableViewHeaderRefresh];
            limitedView = nil;
            
        }];
        [limitedView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
        
    }];
    [limitedButton setImage:[UIImage imageNamed:@"foodgroud_interested_normal"] forState:UIControlStateNormal];
    [limitedButton setImage:[UIImage imageNamed:@"foodgroud_interested_highlighted"] forState:UIControlStateSelected];
    [self.view addSubview:limitedButton];
    
    ///排序
    UIButton *rankButton = [UIButton createBlockActionButton:CGRectMake(limitedButton.frame.origin.x+limitedButton.frame.size.width+gap, limitedButton.frame.origin.y-8.0f, 44.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///如果是单个商户的列表，不需要进行过滤
        if (_listType == MERCHANT_ALL_FLT) {
            
            return;
            
        }
        
        if (rankTypeView) {
            
            [rankTypeView hiddenFoodTypeView];
            rankTypeView = nil;
            
            return;
        }
        
        ///回收其他视图
        [distantceView hiddenFoodTypeView];
        distantceView = nil;
        [foodTypeView hiddenFoodTypeView];
        foodTypeView = nil;
        [limitedView hiddenFoodTypeView];
        limitedView = nil;
        [rankTypeView hiddenFoodTypeView];
        rankTypeView = nil;
        
        ///排序
        int orderSelectedIndex = ([_searchKey objectForKey:@"order_index"] ? ([[_searchKey objectForKey:@"order_index"] intValue]) : 0);
        rankTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"默认",@"评价最高",@"最新发布",@"人气最高",@"价格最低",@"价格最高"] andYPoint:74.0f andAboveView:tabelView andCurrentIndex:orderSelectedIndex andCallBack:^(NSString *type, int index) {
            
            ///如果是没选择菜品，则直接返回
            if (index == -1) {
                return;
            }
            
            ///刷新数据
            if(1 == index) {
            
                [_searchKey setObject:@"merchantMsg.score desc" forKey:@"order"];
                [_searchKey setObject:@"1" forKey:@"order_index"];
                button.selected = YES;
            
            } else if(2 == index){
            
                [_searchKey setObject:@"t.add_time desc" forKey:@"order"];
                [_searchKey setObject:@"2" forKey:@"order_index"];
                button.selected = YES;
            
            } else if(3 == index){
            
                [_searchKey setObject:@"t.real_join desc" forKey:@"order"];
                [_searchKey setObject:@"3" forKey:@"order_index"];
                button.selected = YES;
            
            } else if(4 == index){
            
                [_searchKey setObject:@"merchantMsg.merchant_per asc" forKey:@"order"];
                [_searchKey setObject:@"4" forKey:@"order_index"];
                button.selected = YES;
            
            } else if (5 == index){
            
                [_searchKey setObject:@"merchantMsg.merchant_per desc" forKey:@"order"];
                [_searchKey setObject:@"5" forKey:@"order_index"];
                button.selected = YES;
            
            } else {
            
                [_searchKey removeObjectForKey:@"order"];
                [_searchKey removeObjectForKey:@"order_index"];
                button.selected = NO;
            
            }
            
            [self beginUITableViewHeaderRefresh];
            rankTypeView = nil;
            
        }];
        [rankTypeView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
        
    }];
    
    [rankButton setImage:[UIImage imageNamed:@"foodgroud_systemic_normal"] forState:UIControlStateNormal];
    [rankButton setImage:[UIImage imageNamed:@"foodgroud_systemic_highlighted"] forState:UIControlStateSelected];
    
    [self.view addSubview:rankButton];
    
}

///创建tabBar
- (void)createTabBar
{
    [super createTabBar];
    [self createTabBarChannelBarWithType:FOODGROUD_TNT];
    
}

//***********************************
//             底部tabbar导航栏事件分发
//***********************************
#pragma mark - 底部tabbar导航栏事件分发
- (void)customTabBarAction:(TABBAR_NORMAL_ACTION_TYPE)actionType
{
    switch (actionType) {
        case MIDDLE_BUTTON_TNAT:
        {
            ///判断是否已满人
            if (FULL_TEAM_UNLEADER_TMS == _middleStatus) {
                [self showTip:self.view tipStr:@"当前搭食团已满人，请选择其他的搭食团。"];
                
                return;
            }
            
            ///判断是否已登录
            BOOL flag = [self checkIsLogin:nil and:nil callBack:^(LOGINVIEW_STATUS status) {
                
                if (LOGINVIEW_STATUS_SUCCESS == status) {
                    
                    ///重新刷新数据
                    [self beginUITableViewHeaderRefresh];
                    
                }
                
            }];
            
            if (flag) {
                
                ///中间按钮的事件
                [self tabbarMiddleButtonAction];
                
            }
            
        }
            break;
            
        case LEFT_BUTTON_TNAT:
        {
            ///判断是否是作者
            if (_isAuthor) {
                
                ///进入搭食团详情页面
                QSNewFoodGroudViewController *newFoodGroudVC = [[QSNewFoodGroudViewController alloc] initStaticDetailWithModel:[self createFoodGroudModel]];
                [self.navigationController pushViewController:newFoodGroudVC animated:YES];
                return;
            }
            
            ///进入发起搭食团页面
            QSNewFoodGroudViewController *newFoodGroudVC = [[QSNewFoodGroudViewController alloc] init];
            [self.navigationController pushViewController:newFoodGroudVC animated:YES];
        
        }
            break;
            
        case RIGHT_BUTTON_TNAT:
        {
            QSYFoodGroudDataModel *listModel = _dataSource[_currentPage];
            UIImage *tempImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:listModel.marIconUrl]]];
            [[SocaialManager sharedManager] showNewUIShareOnVC:self
                                                       Content:@"省心省力省钱省时间，“吃订你”轻轻一点立即省"
                                                      UserName:[UserManager sharedManager].userData.username
                                                      WorkName:nil
                                                        Images:tempImage
                                                     ImagesUrl:nil];
            
        }
            break;
            
        default:
            break;
    }
}

///点击成团/参团/退团的事件
- (void)tabbarMiddleButtonAction
{
    
    switch (_middleStatus) {
            
            ///团长：未成团状态-点击时可成团
        case UNCOMMIT_LEADER_TEAM_TMS:
            
            [self prepareCommintTeam];
            
            break;
            
            ///团长：已成团状态
        case COMMIT_LEADER_TEAM_TMS:
            
            
            
            break;
            
            ///团长：已取消状态
        case CANCEL_LEADER_TEAM_TMS:
            
            
            
            break;
            
            ///非团长：当前未满团，并且可以参团
        case UNFULL_TEAM_UNLEADER_TMS:
            
            [self joinTeam];///参团
            
            break;
            
            ///非团长：当前搭食团已满人
        case FULL_TEAM_UNLEADER_TMS:
            
            ///提示
            [self showTip:self.view tipStr:@"当前团已满，请加选择其他团。"];
            
            break;
            
            ///非团长：当前用户已参团
        case JOINED_TEAM_UNLEADER_TMS:
        {
            
            [self showTip:@"确认" andCancelTitle:@"取消" andTipsMessage:@"确认退团？" andCallBack:^(UIAlertActionStyle actionStyle) {
                
                ///判断回调
                if (UIAlertActionStyleDefault == actionStyle) {
                    
                    ///退团
                    [self outTeam];
                    
                }
                
            }];
            
        }
            break;
            
        default:
            break;
    }

}

/**
 *  @author yangshengmeng, 14-12-21 19:12:33
 *
 *  @brief  返回一个搭食团数据模型，用来进入详情页时，将信息显示在详情中
 *
 *  @return 返回详情数据模型
 *
 *  @since  2.0
 */
- (QSNewFoodGroudModel *)createFoodGroudModel
{

    QSNewFoodGroudModel *model = [[QSNewFoodGroudModel alloc] init];
    
    if (_listType == DEFAULT_FLT) {
        
        QSYFoodGroudDataModel *listModel = _dataSource[_currentPage];
        model.merchantID = listModel.marID;
        model.merchantName = listModel.marchantName;
        model.membersSumCount = listModel.sumNumber;
        model.activityTime = [NSDate formatIntervalDateToDate:listModel.joinTime];
        model.activityComment = listModel.teamComment;
        model.tagList = listModel.tagList;
        model.payStyle = listModel.payStyle;
        model.addLimited = listModel.addCondiction;
        model.canTakeFamilies = listModel.canTakeFamilies;
        
        return model;
        
    }
    
    QSYMyFoodGroudDataModel *listModel = _dataSource[_currentPage];
    model.merchantID = listModel.marID;
    model.merchantName = listModel.marchantName;
    model.membersSumCount = listModel.sumNumber;
    model.activityTime = [NSDate formatIntervalDateToDate:listModel.joinTime];
    model.activityComment = listModel.teamComment;
    model.tagList = listModel.tagList;
    model.payStyle = listModel.payStyle;
    model.addLimited = listModel.addCondiction;
    model.canTakeFamilies = listModel.canTakeFamilies;
    
    return model;

}

///发起一个地动的头部刷新
#pragma mark - 发起一个主动的头部刷新
- (void)beginUITableViewHeaderRefresh
{

    UITableView *tableView = objc_getAssociatedObject(self, &FoodGroudListKey);
    [tableView headerBeginRefreshing];

}

/**
 *  @author yangshengmeng, 14-12-18 10:12:22
 *
 *  @brief  头部刷新
 *
 *  @since  2.0
 */
#pragma mark - 搭吃团列表头部/脚刷新
- (void)getFoodGroudHeaderData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///是否单独商户的的搭食团
        if (_listType == MERCHANT_ALL_FLT) {
            
            [self requestMerchantFoodGroudList];
            return;
            
        }
        
        ///个人未成团的搭食团列表
        if (PRIVATE_UNCOMMMITED_FLT == _listType) {
            
            ///请求当前用户创建并未成团的列表数据
            [self requestPrivateUnCommittedList];
            return;
        }
        
        ///普通的列表
        [self requestNormalFoodGroudList];
        
    });
    
}

///请求指定商户的搭食团列表
- (void)requestMerchantFoodGroudList
{

    ///普通搭食团列表
    [[QSAPIClientBase sharedClient] getFoodGroudListWithPage:1 andUserID:nil andParams:_searchKey andCallBack:^(BOOL resultFlag, NSArray *foodGroudList, NSString *errorInfo, NSString *errorcode) {
        
        ///判断请法庭成功或失败
        if (resultFlag) {
            
            ///清空数据源
            [_dataSource removeAllObjects];
            
            ///记录码
            _page = 1;
            
            if ([foodGroudList count] <= 0) {
                
                ///显示暂无记录
                [self endTableViewRefreshAnimition];
                [self showNoRecordUI:YES];
                return;
                
            }
            
            ///加载数据
            [_dataSource addObjectsFromArray:foodGroudList];
            
            ///移除暂无记录
            [self showNoRecordUI:NO];
            
            ///刷新数据
            [self reloadFoodGroudList];
            
            ///结束动画
            [self endTableViewRefreshAnimition];
            
        } else {
            
            ///弹出说明
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取搭吃团失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            //显示一秒后返回
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///消失
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [self endTableViewRefreshAnimition];
                
            });
            
        }
        
    }];

}

///请求当前用户发起并未成团的列表
- (void)requestPrivateUnCommittedList
{

    ///开始请求数据
    NSString *userID = [UserManager sharedManager].userData.user_id;
    [[QSAPIClientBase sharedClient] getFoodGroudListWithPage:1 andUserID:userID andParams:_searchKey andStatus:@"0" andCallBack:^(BOOL resultFlag, NSArray *foodGroudList, NSString *errorInfo, NSString *errorcode) {
        
        ///判断请法庭成功或失败
        if (resultFlag) {
            
            ///清空数据源
            [_dataSource removeAllObjects];
            
            ///记录码
            _page = 1;
            
            if ([foodGroudList count] <= 0) {
                
                ///显示暂无记录
                [self endTableViewRefreshAnimition];
                [self showNoRecordUI:YES];
                return;
                
            }
            
            ///加载数据
            [_dataSource addObjectsFromArray:foodGroudList];
            
            ///移除暂无记录
            [self showNoRecordUI:NO];
            
            ///刷新数据
            [self reloadFoodGroudList];
            
            ///结束动画
            [self endTableViewRefreshAnimition];
            
        } else {
            
            ///弹出说明
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取搭吃团失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            //显示一秒后返回
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///消失
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [self endTableViewRefreshAnimition];
                
            });
            
        }
        
    }];

}

///请求普通的搭食团列表
- (void)requestNormalFoodGroudList
{

    ///普通搭食团列表
    NSString *userID = (_listType == PRIVATE_FLT) ? [UserManager sharedManager].userData.user_id : nil;
    [[QSAPIClientBase sharedClient] getFoodGroudListWithPage:1 andUserID:userID andParams:_searchKey andCallBack:^(BOOL resultFlag, NSArray *foodGroudList, NSString *errorInfo, NSString *errorcode) {
        
        ///判断请法庭成功或失败
        if (resultFlag) {
            
            ///清空数据源
            [_dataSource removeAllObjects];
            
            ///记录码
            _page = 1;
            
            if ([foodGroudList count] <= 0) {
                
                ///显示暂无记录
                [self endTableViewRefreshAnimition];
                [self showNoRecordUI:YES];
                return;
                
            }
            
            ///加载数据
            [_dataSource addObjectsFromArray:foodGroudList];
            
            ///移除暂无记录
            [self showNoRecordUI:NO];
            
            ///刷新数据
            [self reloadFoodGroudList];
            
            ///结束动画
            [self endTableViewRefreshAnimition];
            
        } else {
            
            ///弹出说明
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取搭吃团失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            //显示一秒后返回
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///消失
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [self endTableViewRefreshAnimition];
                
            });
            
        }
        
    }];

}

/**
 *  @author yangshengmeng, 14-12-18 10:12:36
 *
 *  @brief  获取搭吃团更多记录
 *
 *  @since  2.0
 */
- (void)getFoodGroudFooterData
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///个人未成团的搭食团列表
        if (PRIVATE_UNCOMMMITED_FLT == _listType) {
            
            ///开始请求数据
            NSString *userID = [UserManager sharedManager].userData.user_id;
            [[QSAPIClientBase sharedClient] getFoodGroudListWithPage:_page+1 andUserID:userID andParams:_searchKey andStatus:@"0" andCallBack:^(BOOL resultFlag, NSArray *foodGroudList, NSString *errorInfo, NSString *errorcode) {
                
                ///判断请法庭成功或失败
                if (resultFlag) {
                    
                    ///记录码
                    _page += 1;
                    
                    if ([foodGroudList count] <= 0) {
                        
                        ///结束刷新动画
                        [self endTableViewRefreshAnimition];
                        return;
                        
                    }
                    
                    ///加载数据
                    [_dataSource addObjectsFromArray:foodGroudList];
                    
                    ///移除暂无记录
                    [self showNoRecordUI:NO];
                    
                    ///刷新数据
                    [self reloadFoodGroudList];
                    
                    ///结束动画
                    [self endTableViewRefreshAnimition];
                    
                    
                } else {
                    
                    ///判断是否已无更新数据
                    if([_dataSource count] > 0){
                        
                        [self endTableViewRefreshAnimition];
                        return;
                    }
                    
                    ///弹出说明
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取搭吃团失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    
                    //显示一秒后返回
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        ///消失
                        [alert dismissWithClickedButtonIndex:0 animated:YES];
                        [self endTableViewRefreshAnimition];
                        
                    });
                    
                }
                
            }];
            
            return;
        }
        
        ///开始请求数据
        NSString *userID = (_listType == PRIVATE_FLT) ? [UserManager sharedManager].userData.user_id : nil;
        [[QSAPIClientBase sharedClient] getFoodGroudListWithPage:_page+1 andUserID:userID andParams:_searchKey andCallBack:^(BOOL resultFlag, NSArray *foodGroudList, NSString *errorInfo, NSString *errorcode) {
            
            ///判断请法庭成功或失败
            if (resultFlag) {
                
                ///记录码
                _page += 1;
                
                if ([foodGroudList count] <= 0) {
                    
                    ///结束刷新动画
                    [self endTableViewRefreshAnimition];
                    return;
                    
                }
                
                ///加载数据
                [_dataSource addObjectsFromArray:foodGroudList];
                
                ///移除暂无记录
                [self showNoRecordUI:NO];
                
                ///刷新数据
                [self reloadFoodGroudList];
                
                ///结束动画
                [self endTableViewRefreshAnimition];
                
                
            } else {
                
                ///判断是否已无更新数据
                if([_dataSource count] > 0){
                
                    [self endTableViewRefreshAnimition];
                    return;
                }
                
                ///弹出说明
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取搭吃团失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                
                //显示一秒后返回
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ///消失
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    [self endTableViewRefreshAnimition];
                    
                });
                
            }
            
        }];
        
    });
    
}

/**
 *  @author yangshengmeng, 14-12-18 10:12:05
 *
 *  @brief  停止刷新动画
 *
 *  @since  2.0
 */
#pragma mark - 停止头/脚刷新的动画
- (void)endTableViewRefreshAnimition
{

    UITableView *tableView = objc_getAssociatedObject(self, &FoodGroudListKey);
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
    
}

/**
 *  @author yangshengmeng, 14-12-18 10:12:14
 *
 *  @brief              每个搭吃团的信息
 *
 *  @param tableView    传入的tableView
 *  @param indexPath    传入的当前section/row
 *
 *  @return             返回一个搭吃团信息
 *
 *  @since              2.0
 */
#pragma mark - 返回每个搭吃团的信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///默认cell
    static NSString *cellName = @"cellNormal";
    QSFoodGroudTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == myCell) {
        
        myCell = [[QSFoodGroudTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    
    ///取消选择状态
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///绑定回调
    myCell.clickMerchantLogoCallBack = ^(UIViewController *vc){
        
        ///进入搭食团详情页面
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    ///更新tabbar按钮状态
    [self updateTabbarButtonStyle:_dataSource[indexPath.row]];
    
    ///刷新UI
    if (_listType == DEFAULT_FLT || (_listType == MERCHANT_ALL_FLT)) {
        
        [myCell updateFoodGroudUIWithModel:_dataSource[indexPath.row]];
        
    }
    
    if ((_listType == PRIVATE_FLT) || (_listType == PRIVATE_UNCOMMMITED_FLT)) {
        
        [myCell updateMyFoodGroudUIWithModel:_dataSource[indexPath.row]];
        
    }
    
    return myCell;

}

/**
 *  @author             yangshengmeng, 14-12-18 10:12:54
 *
 *  @brief              返回有多少个搭吃团
 *
 *  @param tableView    传入的tableView
 *  @param section      当前行/section
 *
 *  @return             返回总数
 *
 *  @since              2.0
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_dataSource count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return tableView.frame.size.height;
    
}

/**
 *  @author yangshengmeng, 14-12-18 16:12:26
 *
 *  @brief  刷新列表
 *
 *  @since  2.0
 */
#pragma mark - 刷新列表数据
- (void)reloadFoodGroudList
{

    UITableView *tableView = objc_getAssociatedObject(self, &FoodGroudListKey);
    [tableView reloadData];

}

/**
 *  @author             yangshengmeng, 14-12-21 15:12:00
 *
 *  @brief              更新底部tabbar相关按钮的状态
 *
 *  @param actionType   当前需要更新按钮：是否满团/是否可编辑
 *  @param flag         变为选择状态/或者普通状态
 *
 *  @since              2.0
 */
#pragma mark - 更新底部tabbar相关按钮的状态
- (void)updateTabbarButtonStyle:(QSYFoodGroudDataModel *)model
{

    NSString *leaderID = model.leaderID;//!<团长ID
    NSString *teamStatus = model.teamStatus;//!<团状态
    NSString *teamSumNum = model.sumNumber;//!<团总的可报名人数
    NSString *joinedNum = model.joinedNumber;//!<已参团人数
    
    ///判断是否团长本人
    BOOL flag = [self checkISTeamLeader:leaderID];
    
    if (flag) {
        
        ///更新团长状态
        _isAuthor = YES;
        [self showEditButton:flag];
        
        ///根据不同的状态修改中间按钮
        _middleStatus = [self formatLeaderTeamStatus:teamStatus];
        [self resetMiddleButtonStyle:_middleStatus];
        
    } else {
    
        ///如若不是团长本身，则只需要修改当前用户的对应的状态
        _isAuthor = NO;
        [self showEditButton:flag];
        
        ///判断是否已参团
        BOOL joinedFlag = [self checkCurrentUserISJoined:model];
        if (joinedFlag) {
            
            _middleStatus = JOINED_TEAM_UNLEADER_TMS;
            [self resetMiddleButtonStyle:_middleStatus];
            return;
        }
        
        ///更新中间按钮
        _middleStatus = [self formatNotLeaderteamStatus:teamSumNum andJoinNumber:joinedNum];
        [self resetMiddleButtonStyle:_middleStatus];
    
    }

}

- (BOOL)checkCurrentUserISJoined:(QSYFoodGroudDataModel *)model
{

    NSString *currentUserID = [UserManager sharedManager].userData.user_id;
    for (QSYFoodGroudMemberDataModel *obj in model.memberList) {
        
        if ([obj.userID isEqualToString:currentUserID]) {
            
            return YES;
            
        }
        
    }
    return NO;

}

- (TABBAR_MIDDLEBUTTON_STYLE)formatNotLeaderteamStatus:(NSString *)sumNumberString andJoinNumber:(NSString *)joinString
{

    ///判断是否已满人
    int sumNum = [sumNumberString intValue];
    int joinNum = [joinString intValue];
    
    if (sumNum == joinNum + 1) {
        
        return FULL_TEAM_UNLEADER_TMS;
        
    }
    
    
    return UNFULL_TEAM_UNLEADER_TMS;

}

///返回团长时：团的当前状态
- (TABBAR_MIDDLEBUTTON_STYLE)formatLeaderTeamStatus:(NSString *)statusString
{
    ///已成团
    if (1 == [statusString intValue]) {
        
        return COMMIT_LEADER_TEAM_TMS;
        
    }
    
    ///已取消
    if (4 == [statusString intValue]) {
        
        return CANCEL_LEADER_TEAM_TMS;
        
    }
    
    ///成团并已完成活动
    if (2 == [statusString intValue]) {
        
        return COMMIT_LEADER_TEAM_TMS;
        
    }
    
    return UNCOMMIT_LEADER_TEAM_TMS;

}


///判断是否是中文
- (BOOL)checkISTeamLeader:(NSString *)leaderID
{

    NSString *currentUserID = [UserManager sharedManager].userData.user_id;
    if ([leaderID isEqualToString:currentUserID]) {
        
        return YES;
        
    }
    
    return NO;

}

/**
 *  @author             yangshengmeng, 14-12-21 19:12:47
 *
 *  @brief              每次滚动时，记录当前的页码，方便取数据模型
 *
 *  @param scrollView   当前滚动的scrollView
 *
 *  @since              2.0
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    ///记录当前是第几页
    _currentPage = (int)(scrollView.contentOffset.y / (DeviceHeight-114.0f));

}

///成团-先请求生成订单，再提交成团
#pragma mark - 成团准备
- (void)prepareCommintTeam
{

    ///提交成团订单，并返回成团的订单号
    QSYFoodGroudDataModel *model = _dataSource[_currentPage];
    
    ///判断是否已满人，或者未满人
    int sumMembers = [model.sumNumber intValue];
    int joinedNumbers = [model.joinedNumber intValue];
    
    NSString *tipsString = (sumMembers == joinedNumbers + 1) ? @"确认成团？" : @"当前的团成员未满，确认成团？";
    
    ///先弹出提示信息
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:tipsString delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 403;
    [alert show];
    
}

///成团
- (void)createTeamOrder
{
    
    ///提交成团订单，并返回成团的订单号
    QSYFoodGroudDataModel *model = _dataSource[_currentPage];
    
    QSBookFillFormViewController *viewVC = [[QSBookFillFormViewController alloc] init];
    viewVC.merchant_id = model.marID;
    
    ///封装商户信息
    QSMerchantIndexReturnData *bookModel = [[QSMerchantIndexReturnData alloc] init];
    bookModel.data = [[QSMerchantDetailData alloc] init];
    [bookModel.data setValue:model.marchantName forKey:@"merchant_name"];
    [bookModel.data setValue:model.marIconUrl forKey:@"merchant_logo"];
    
    ///初始化页面元素
    viewVC.teamModel = model;
    
    ///回调block
    viewVC.commitTeamCallBack = ^(BOOL flag,NSString *ibookID){
    
        ///判断是否预约成功
        if (flag) {
            
            [self commitTeam:ibookID andTeamID:model.teamID];
            
        } else {
        
            
        
        }
    
    };
    
    ///进入预约页面
    viewVC.merchantIndexReturnData = bookModel;
    [self.navigationController pushViewController:viewVC animated:YES];

}

- (void)commitTeam:(NSString *)ibookID andTeamID:(NSString *)teamID
{
    
    [[QSAPIClientBase sharedClient] commitTeamWithID:ibookID andTeamID:teamID andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否参团成功
        if (flag) {
            
            [self showTip:self.view tipStr:errorInfo ? errorInfo : @"您的搭食团已成团!"];
            
            ///刷新数据
            [self beginUITableViewHeaderRefresh];
            
            return;
            
        }
        
        ///参团失败
        [self showTip:self.view tipStr:errorInfo ? errorInfo : @"成团失败，请稍后再试。"];
        
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    ///判断是否是成团的提醒
    if (alertView.tag == 403) {
        
        ///成团
        if (buttonIndex == 0) {
            
            ///去预约并生成订单
            [self createTeamOrder];
            return;
        }
        
    }

}

///退团
#pragma mark - 退团
- (void)outTeam
{

    ///获取团ID
    QSYFoodGroudDataModel *model = _dataSource[_currentPage];
    
    [[QSAPIClientBase sharedClient] outTeamWithID:model.teamID andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否参团成功
        if (flag) {
            
            [self showTip:self.view tipStr:errorInfo ? errorInfo : @"退团成功!"];
            
            ///刷新数据
            [self beginUITableViewHeaderRefresh];
            
            return;
            
        }
        
        ///参团失败
        [self showTip:self.view tipStr:errorInfo ? errorInfo : @"退团失败，请稍后再试。"];
        
    }];

}

///参团
#pragma mark - 参团
- (void)joinTeam
{
    ///获取团ID
    QSYFoodGroudDataModel *model = _dataSource[_currentPage];

    [[QSAPIClientBase sharedClient] joinTeamWithID:model.teamID andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否参团成功
        if (flag) {
            
            [self showTip:self.view tipStr:errorInfo ? errorInfo : @"参团成功！"];
            
            ///刷新数据
            [self beginUITableViewHeaderRefresh];
            
            return;
            
        }
        
        ///参团失败
        [self showTip:self.view tipStr:errorInfo ? errorInfo : @"参团失败，请稍后再试！"];
        
    }];

}

@end
