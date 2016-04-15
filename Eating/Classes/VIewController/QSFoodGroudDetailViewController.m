//
//  QSFoodGroudDetailViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodGroudDetailViewController.h"
#import "QSFoodGroudMerchantView.h"
#import "QSFoodGroudMembersTableViewCell.h"
#import "MJRefresh.h"
#import "QSAPIClientBase+FoodGroud.h"
#import "QSImageView.h"
#import "QSBlockActionButton.h"
#import "QSFoodGroudMerchantAroundView.h"
#import "QSFoodGroudAllTalkViewController.h"
#import "QSMerchantIndexViewController.h"
#import "QSMemberInfoHeaderView.h"
#import "CustomAnnotationView.h"

#import <MAMapKit/MAMapKit.h>
#import <objc/runtime.h>

///关联
static char RootScrollViewKey;//!<所有信息的底view
static char MerchantAroundViewKey;//!<商户周边环境的view
static char MerchantInfoViewKey;//!<商户信息view
static char MembersListKey;//!<成员列表
//static char MembersHeaderViewKey;//!<成员列表的头信息
static char ChannelImageViewKey;//!<频道栏

@interface QSFoodGroudDetailViewController ()<MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate>{

    NSString *_teamLeaderID;//!<搭食团的团长ID
    NSString *_teamID;      //!<搭食团ID
    
    NSString *_merchantName;//!<商户名称
    NSString *_merchantLatitude;//!<商户的地理纬度
    NSString *_merchantLongitude;//!<商户的地理经度
    
    MAMapView *_mapView;        //!<地图对象
    MAPointAnnotation *_merchantLocalANN;//!<商户所在地的大头针
    
    NSMutableArray *_membersList;//!<团成员数组
    
    NSMutableArray *_merchantImageList;//!<商户环境数据

}

@end

@implementation QSFoodGroudDetailViewController

/**
 *  @author         yangshengmeng, 14-12-24 10:12:48
 *
 *  @brief          初始化一个搭食团详情页面，需要传入当前搭食团的ID及用户ID
 *
 *  @param userID   用户ID
 *  @param teamID   搭食团的ID
 *
 *  @return         返回详情页
 *
 *  @since          2.0
 */
#pragma mark - 初始化搭食团详情页面
- (instancetype)initWithID:(NSString *)userID andTeamID:(NSString *)teamID andMerchantName:(NSString *)merName
{

    if (self = [super init]) {
        
        ///保存搭食团的ID信息
        _teamLeaderID = [userID copy];
        _teamID = [teamID copy];
        _merchantName = [merName copy];
        
        ///初始化数据源
        _membersList = [[NSMutableArray alloc] init];
        
        _merchantImageList = [[NSMutableArray alloc] init];
        
        ///初始化大头针
        _merchantLocalANN = [[MAPointAnnotation alloc] init];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBar
{

    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:_merchantName];

}

///创建主展示信息UI
- (void)createMainShowView
{

    ///创建二级导航栏
    [self createChannelBar];
    
    ///取消滚动时的自应适
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ///创建一个scrollView，当为一个底view，方便纵向自适应
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, DeviceHeight-64.0f)];
    
    ///取消滚动
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    ///添加子视图
    [self createMainShowView:scrollView];
    
    ///刷新
    [scrollView addHeaderWithTarget:self action:@selector(requestFoodGroudDetail)];
    [scrollView headerBeginRefreshing];
    
    ///添加到主视图上
    [self.view addSubview:scrollView];
    [self.view sendSubviewToBack:scrollView];
    
    objc_setAssociatedObject(self, &RootScrollViewKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
    
    ///商户环境view
    QSFoodGroudMerchantAroundView *aroundView = [[QSFoodGroudMerchantAroundView alloc] initWithFrame:CGRectMake(DeviceWidth, 64.0f, DeviceWidth, DeviceHeight-64.0f)];
    [self.view addSubview:aroundView];
    [self.view sendSubviewToBack:aroundView];
    objc_setAssociatedObject(self, &MerchantAroundViewKey, aroundView, OBJC_ASSOCIATION_ASSIGN);

}

/**
 *  @author yangshengmeng, 14-12-24 17:12:16
 *
 *  @brief  创建二级导航按钮
 *
 *  @since  2.0
 */
- (void)createChannelBar
{
    ///频道按钮的底view
    UIView *channelRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, 57.0f)];
    [self.view addSubview:channelRootView];
    objc_setAssociatedObject(self, &ChannelImageViewKey, channelRootView, OBJC_ASSOCIATION_ASSIGN);

    ///频道栏的底图
    QSImageView *channelImageView = [[QSImageView alloc] initWithFrame:CGRectMake(-1.0f, 0.0f, DeviceWidth+1, 35.0f)];
    channelImageView.image = [UIImage imageNamed:@"foodgroud_detail_channel_bg"];
    [channelRootView addSubview:channelImageView];
    
    ///创建频道按钮
    [self createChannelBarButton:channelRootView];

}

///创建频道栏的三个按钮
- (void)createChannelBarButton:(UIView *)view
{

    ///获取按钮信息数组
    NSArray *buttonInfoList = [self getChannelBarButtonList];
    
    CGFloat xpoint = DeviceWidth / 2.0f - 44.0f - 22.0f - 40.0f;
    int i = 0;
    for (NSDictionary *obj in buttonInfoList) {
        
        UIButton *button = [UIButton createBlockActionButton:CGRectMake(xpoint, i == 1 ? 10.0f : 0.0f, 44.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
            
            ///如果原来已是选择状态，不进行动作
            if (button.selected) {
                return;
            }
            
            ///点击频道栏的按钮事件
            [self channelButtonAction:[obj valueForKey:@"index"]];
            
            
        }];
        [button setImage:[UIImage imageNamed:[obj valueForKey:@"normal"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[obj valueForKey:@"highlighted"]] forState:UIControlStateHighlighted];
        
        if (i != 2) {
            
            [button addTarget:self action:@selector(resetSelectedButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        ///如果是第三个按钮：添加选择状态
        if (i != 2) {
            [button setImage:[UIImage imageNamed:[obj valueForKey:@"highlighted"]] forState:UIControlStateSelected];
        }
        
        
        [view addSubview:button];
        if (i == 0) {
            button.selected = YES;
        }
        
        ///重置xpoint
        xpoint += (44.0f + 40.f);
        i++;
        
    }

}

///获取频道栏的按钮图片等相关信息数组
- (NSArray *)getChannelBarButtonList
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"FoodGroudDetailChannelBar" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return [dict valueForKey:@"channel"];

}

/**
 *  @author             yangshengmeng, 14-12-24 11:12:00
 *
 *  @brief              在滚动视图上添加各种不同信息集合的子视图
 *
 *  @param scrollView   滚动视图
 *
 *  @since              2.0
 */
- (void)createMainShowView:(UIScrollView *)scrollView
{

    ///地图view:h-250
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DeviceWidth, 220.0f)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    ///跟随
    _mapView.zoomLevel = 13.00;
    _mapView.logoCenter = CGPointMake(MARGIN_LEFT_RIGHT+30.0f, _mapView.frame.size.height-50.0f);
    [scrollView addSubview:_mapView];
    
    ///商店信息
    QSFoodGroudMerchantView *merchantView = [[QSFoodGroudMerchantView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, _mapView.frame.origin.y+_mapView.frame.size.height-40.0f, DEFAULT_MAX_WIDTH, 80.0f) andCallBack:^(NSString *merchantID, NSString *merchantName) {
        
        ///进入商户介绍页面
        QSMerchantIndexViewController *marDetail = [[QSMerchantIndexViewController alloc] init];
        marDetail.merchant_id = merchantID;
        [self.navigationController pushViewController:marDetail animated:YES];
        
    }];
    [scrollView addSubview:merchantView];
    objc_setAssociatedObject(self, &MerchantInfoViewKey, merchantView, OBJC_ASSOCIATION_ASSIGN);
    
    ///成员列表
    CGFloat ypointOfMembersList = merchantView.frame.origin.y+merchantView.frame.size.height+10.0f;
    UITableView *membersList = [[UITableView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, ypointOfMembersList, DEFAULT_MAX_WIDTH, DeviceHeight-ypointOfMembersList-64.0f-5.0f) style:UITableViewStyleGrouped];
    
    ///设置圆角
    membersList.layer.cornerRadius = 6.0f;
    membersList.backgroundColor = [UIColor whiteColor];
    
    ///取消滚动条
    membersList.showsHorizontalScrollIndicator = NO;
    membersList.showsVerticalScrollIndicator = NO;
    
    ///数据源和代理
    membersList.dataSource = self;
    membersList.delegate = self;
    
    ///设置固定的行高
    membersList.rowHeight = 90.0f;
    
    membersList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [scrollView addSubview:membersList];
    
    objc_setAssociatedObject(self, &MembersListKey, membersList, OBJC_ASSOCIATION_ASSIGN);

}

/**
 *  @author             yangshengmeng, 14-12-24 14:12:45
 *
 *  @brief              地图代理相关方法，用来更新用户当前坐标及更新用户方向
 *
 *  @param mapView      当前的地图
 *  @param userLocation 用户最新的坐标
 *
 *  @since              2.0
 */
#pragma mark - 地图设置相关方法
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{

    

}

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    

}

/**
 *  @author             yangshengmeng, 14-12-24 14:12:08
 *
 *  @brief              返回每个成员的信息
 *
 *  @param tableView    成员列表
 *  @param indexPath    当前成员的下标
 *
 *  @return             返回一个成员信息项
 *
 *  @since              2.0
 */
#pragma mark - 返回每个成员的信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellName = @"normalCell";
    QSFoodGroudMembersTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    ///判断是否可以复用，没有复用则新创建
    if (nil == myCell) {
        
        myCell = [[QSFoodGroudMembersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName andCallBack:^(NSDictionary *params) {
            
            ///cell中的回调
            
            
        }];
        
    }
    
    ///取消选择时的状态
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///更新数据
    [myCell updateFoodGroudMembersCellUI:_membersList[indexPath.row]];
    
    return myCell;

}

///返回有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_membersList count];

}

///返回有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;

}

/**
 *  @author             yangshengmeng, 14-12-25 12:12:47
 *
 *  @brief              创建成员列表的头view
 *
 *  @param tableView    头view所在的列表
 *  @param section      当前的section区域
 *
 *  @return             返回一个头视图
 *
 *  @since              2.0
 */
#pragma mark - 创建成员列表的头view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    static NSString *headerName = @"headerName";
    QSMemberInfoHeaderView *headerView = [tableView dequeueReusableCellWithIdentifier:headerName];
    
    if (nil == headerView) {
        
        headerView = [[QSMemberInfoHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEFAULT_MAX_WIDTH, 40.0f)];
        
    }
    
    ///更新数据
    [headerView updateMemberCounts:[NSString stringWithFormat:@"%d",(int)[_membersList count]]];
    
    return headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 40.0f;

}

///点击成员时，也进入聊天窗口
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///进入聊天窗口
    [self gotoTalk];

}

/**
 *  @author yangshengmeng, 14-12-24 15:12:57
 *
 *  @brief  请求搭食团详情信息
 *
 *  @since  2.0
 */
#pragma mark - 请求搭食团详情信息
- (void)requestFoodGroudDetail
{

    ///延迟0.22秒后再请求数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///进行数据请求
        [[QSAPIClientBase sharedClient] getFoodGroudDetailInfo:_teamLeaderID andTeamID:_teamID andCallBack:^(BOOL resultFlag, QSFoodGroudDetailDataModel *detailModel, NSString *errorInfo, NSString *errorcode) {
            
            ///判断是否请求成功
            if (resultFlag) {
                
                ///更新商户坐标
                [self updateMerchantLocale:detailModel.merchantModel.merchantLongitude andLatitude:detailModel.merchantModel.merchantLatitude];
                
                ///更新商户信息
                [self updateMerchantInfo:detailModel.merchantModel];
                
                ///更新成员列表
                [self updateMembersList:detailModel.memberList];
                
                ///更新环境视图
                [self updateMerchantAroundImage:detailModel.merchantModel.imageList];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ///结束刷新动画
                    [self endRefreshAnimination];
                    
                });
                
                return;
            }
            
            ///请求失败
            [self showAlertMessageWithTime:0.5 andMessage:@"搭食团详情信息下载失败" andCallBack:^(CGFloat showTime) {
                
                ///结束刷新动画
                [self endRefreshAnimination];
                
                ///返回列表
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
        }];
        
    });

}

/**
 *  @author             yangshengmeng, 14-12-25 10:12:51
 *
 *  @brief              更新商户周边环境
 *
 *  @param imageList    图片数组
 *
 *  @since              2.0
 */
#pragma mark - 请求完成后刷新UI
- (void)updateMerchantAroundImage:(NSArray *)imageList
{
    
    QSFoodGroudMerchantAroundView *view = objc_getAssociatedObject(self, &MerchantAroundViewKey);
    if (view && imageList) {
        
        [view updateMerchantAround:imageList];
        
    }
    
}

/**
 *  @author             yangshengmeng, 14-12-24 16:12:15
 *
 *  @brief              更新成员列表
 *
 *  @param membersList  成员信息数组
 *
 *  @since              2.0
 */
- (void)updateMembersList:(NSArray *)membersList
{

    ///判断是否存在新成员
    if (!([membersList count] > 0)) {
        return;
    }
    
    [_membersList removeAllObjects];
    [_membersList addObjectsFromArray:membersList];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UITableView *tableView = objc_getAssociatedObject(self, &MembersListKey);
        if (tableView) {
            [tableView reloadData];
        }
        
    });

}

/**
 *  @author                 yangshengmeng, 14-12-24 16:12:13
 *
 *  @brief                  更新商户信息
 *
 *  @param merchantModel    商户信息模型
 *
 *  @since                  2.0
 */
- (void)updateMerchantInfo:(QSFoodGroudMerchantDataModel *)merchantModel
{

    QSFoodGroudMerchantView *view = objc_getAssociatedObject(self, &MerchantInfoViewKey);
    [view updateMerchantInfoView:merchantModel];

}

/**
 *  @author             yangshengmeng, 14-12-24 16:12:32
 *
 *  @brief              更新商户的坐标到地图上
 *
 *  @param longitude    经度
 *  @param lat          纬度
 *
 *  @since              2.0
 */
- (void)updateMerchantLocale:(NSString *)longitude andLatitude:(NSString *)lat
{
    
    //把每个结果用大头针显示到界面上
    _merchantLocalANN.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [longitude doubleValue]);
    _merchantLocalANN.title = @"商户";
    [_mapView addAnnotation:_merchantLocalANN];

}

#if 1
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{

    if ([annotation.title isEqualToString:@"商户"]) {
        
        static NSString *customReuseIndetifier = @"merchant";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
            
            annotationView.image = [UIImage imageNamed:@"map_merchantPointIcon.png"];
        }
        
        annotationView.userInteractionEnabled = NO;
        
        return annotationView;
        
    } else {
    
        static NSString *customReuseIndetifier = @"user";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
            
            annotationView.image = [UIImage imageNamed:@"map_userPointIcon.png"];
        }
        
        annotationView.userInteractionEnabled = NO;
        
        return annotationView;
    
    }
    
    return nil;

}
#endif

/**
 *  @author yangshengmeng, 14-12-24 15:12:50
 *
 *  @brief  结束头部刷新
 *
 *  @since  2.0
 */
- (void)endRefreshAnimination
{

    UIScrollView *scrollView = objc_getAssociatedObject(self, &RootScrollViewKey);
    [scrollView headerEndRefreshing];

}

/**
 *  @author         yangshengmeng, 14-12-24 17:12:14
 *
 *  @brief          频道栏的按钮事件
 *
 *  @param index    当前点击的是第几个按钮
 *
 *  @since          2.0
 */
#pragma mark - 频道栏按钮的事件
- (void)channelButtonAction:(NSString *)index
{

    ///点击第一个按钮
    if ([index intValue] == 0) {
        
        ///显示列表详情
        UIScrollView *scrollView = objc_getAssociatedObject(self, &RootScrollViewKey);
        UIView *aroundView = objc_getAssociatedObject(self, &MerchantAroundViewKey);
        [UIView animateWithDuration:0.3 animations:^{
            
            scrollView.frame = CGRectMake(0.0f, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
            aroundView.frame = CGRectMake(aroundView.frame.size.width, aroundView.frame.origin.y, aroundView.frame.size.width, aroundView.frame.size.height);
            
        }];
        
        return;
    }
    
    ///如果点击的是环境按钮
    if ([index intValue] == 1) {
        
        ///显示环境视图
        UIScrollView *scrollView = objc_getAssociatedObject(self, &RootScrollViewKey);
        UIView *aroundView = objc_getAssociatedObject(self, &MerchantAroundViewKey);
        [UIView animateWithDuration:0.3 animations:^{
            
            scrollView.frame = CGRectMake(-scrollView.frame.size.width, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
            aroundView.frame = CGRectMake(0.0f, aroundView.frame.origin.y, aroundView.frame.size.width, aroundView.frame.size.height);
            
        }];
        
        return;
    }
    
    ///如果点击的是第三个按钮
    if ([index intValue] == 2) {
        
        ///判断是否已登录
        if (![self checkIsLogin]) {
            return;
        }
        
        ///进入聊天窗口
        [self gotoTalk];
        
        return;
    }

}

///重置频道栏的选择状态
- (void)resetSelectedButtonStatus:(UIButton *)button
{
    if (button.selected) {
        
        return;
    }

    UIView *view = objc_getAssociatedObject(self, &ChannelImageViewKey);
    for (UIView *obj in [view subviews]) {
        
        if ([obj isKindOfClass:[UIButton class]]) {
            
            ((UIButton *)obj).selected = NO;
            
        }
        
    }
    
    button.selected = YES;

}

/**
 *  @author yangshengmeng, 14-12-27 09:12:48
 *
 *  @brief  进入聊天窗口
 *
 *  @since  2.0
 */
#pragma mark - 进入聊天窗口
- (void)gotoTalk
{
    
    if (![self checkIsLogin]) {
        
        return;
        
    }

    ///进入聊天窗口
    QSFoodGroudAllTalkViewController *allTalkVC = [[QSFoodGroudAllTalkViewController alloc] initWithTeamID:_teamID];
    [self.navigationController pushViewController:allTalkVC animated:YES];

}

@end
