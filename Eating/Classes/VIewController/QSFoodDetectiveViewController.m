//
//  QSFoodDetectiveViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodDetectiveViewController.h"
#import "QSNormalNavigationBar.h"
#import "QSNormalTabBar.h"
#import "QSAddFoodDetectiveViewController.h"
#import "QSAPIClientBase+FoodDetective.h"
#import "QSMarAcNoticeTableViewCell.h"
#import "MJRefresh.h"
#import "QSArticleFoodDetectiveViewController.h"
#import "QSAPIModel+QSFoodDetectiveRecommendReturnData.h"
#import "QSAPIModel+QSFoodDetectiveMarchAcNoticeReturnData.h"
#import "QSFreeFoodStoreViewController.h"
#import "QSShareFoodStoreViewController.h"
#import "QSTryActivitiesViewController.h"

#import <objc/runtime.h>

//关联key
static char FoodDetectiveTableViewKey;
@interface QSFoodDetectiveViewController () <UITableViewDataSource,UITableViewDelegate>{
    int _page;//页码
    NSMutableArray *_dataSource;//数据源
    NSInteger _headerIndext;//推荐菜单当前显示的图片
}

@end

@implementation QSFoodDetectiveViewController

//*****************************
//      初始化/UI塔建
//*****************************
#pragma mark - 初始化/UI塔建
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _page = 1;
        _dataSource = [[NSMutableArray alloc] init];
        _headerIndext = 0;
    }
    
    return self;
    
}



//创建导航栏
- (void)createNavigationBar
{
    //创建navigation：640 × 172
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"美食侦探社"];
}

//创建中间展现视图
- (void)createMainShowView
{
    [super createMainShowView];
    
#if 1
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64.0f, DeviceWidth, DeviceHeight - 64.0f)];
    [self.view addSubview:webView];
    [self.view sendSubviewToBack:webView];
    
    ///设置背景颜色
    webView.backgroundColor = [UIColor whiteColor];
    
    ///取消滚动条
    for (UIView *obj in [webView subviews]) {
        
        if ([obj isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)obj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)obj).showsVerticalScrollIndicator = NO;
            
        }
        
        
    }
    
    ///加载活动信息
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://117.41.235.110:800/ad/201518.php"]]];

    
#endif
    
    
#if 0
    //底tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.height-64.0f-40.0f)];
    [self.view addSubview:tableView];
    [self.view sendSubviewToBack:tableView];
    
    //隐藏滚动条
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    
    //数据源代理
    tableView.dataSource = self;
    tableView.delegate = self;
    
    //去除分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //默认背景颜色
    tableView.backgroundColor = kBaseBackgroundColor;
    
    //首尾刷新：暂时只添加头部刷新
    [tableView addHeaderWithTarget:self action:@selector(requestFoodDetectiveData)];
    
    //开始就进入头部刷新
    [tableView headerBeginRefreshing];
    
    //关联
    objc_setAssociatedObject(self, &FoodDetectiveTableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);
#endif
}

//创建tabBar
- (void)createTabBar
{
    
#if 0
    [super createTabBar];
    [self createTabBarChannelBarWithType:FOODDETECTIVE_TNT];
#endif
    
}

//*****************************
//             导航栏事件分发
//*****************************
#pragma mark - 导航栏事件分发
- (void)navigationBarAction:(NAVIGATION_BAR_NORMAL_ACTION_TYPE)actionType
{
    switch (actionType) {
        case TURN_BACK_NBNAT:
        {
            //返回按钮事件
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

//*****************************
//          导航栏事件分发
//*****************************
#pragma mark - tabBar事件分发
- (void)customTabBarAction:(TABBAR_NORMAL_ACTION_TYPE)actionType
{
    switch (actionType) {
        case MIDDLE_BUTTON_TNAT:
        {
#if 0
      //测试VC
            UIViewController *src = [[NSClassFromString(@"QSMyDetectiveViewController") alloc] init];
            [self.navigationController pushViewController:src animated:YES];
            
#endif
#if 1
            QSShareFoodStoreViewController *src = [[QSShareFoodStoreViewController alloc] init];
            [self.navigationController pushViewController:src animated:YES];
#endif
        }
            break;
            
        case LEFT_BUTTON_TNAT:
        {
            //判断是否已登录
#if 0
            BOOL isLogin = [self checkIsLogin];
            if (!isLogin) {
                return;
            }
#endif
            
            QSAddFoodDetectiveViewController *addFoodDetective = [[QSAddFoodDetectiveViewController alloc] init];
            [self.navigationController pushViewController:addFoodDetective animated:YES];
        }
            break;
            
        case RIGHT_BUTTON_TNAT:
        {
            QSFreeFoodStoreViewController *src = [[QSFreeFoodStoreViewController alloc] init];
            [self.navigationController pushViewController:src animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//*****************************
//    tableView header Refresh
//*****************************
#pragma mark - tableview刷新事件
- (void)requestFoodDetectiveData
{
    _page = 1;
    [[QSAPIClientBase sharedClient] foodDetectedRecommendWithPage:_page andPageNum:5 successCallBack:^(NSArray *respondArray) {
        if ([respondArray count] > 0) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:respondArray];
            [self updateTableView];
        }
        
        //停止刷新
        [self stopUITableViewRefresh];
    } failCallBack:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"美食侦探社数据下载失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
        //停止刷新
        [self stopUITableViewRefresh];
    }];
}

//tableView脚刷新
- (void)loadMoreData
{
    _page++;
    [[QSAPIClientBase sharedClient] foodDetectedRecommendWithPage:_page andPageNum:5 successCallBack:^(NSArray *respondArray) {
        if ([respondArray count] > 0) {
            [_dataSource addObjectsFromArray:respondArray];
            [self updateTableView];
        }
        //停止刷新
        [self stopUITableViewRefresh];
    } failCallBack:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"美食侦探社数据下载失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
        //停止刷新
        [self stopUITableViewRefresh];
    }];
}

//停止头尾刷新
- (void)stopUITableViewRefresh
{
    UITableView *tableView = objc_getAssociatedObject(self, &FoodDetectiveTableViewKey);
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
}

//*****************************
//    tableView数据源
//*****************************
#pragma mark - tableview数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //头图片
    if (indexPath.row == 0) {
        static NSString *headerName = @"headerCell";
        QSMarAcNoticeTableViewCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:headerName];
        if (nil == cellHeader) {
            cellHeader = [[QSMarAcNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerName andCellType:FOODDETECTIVE_HEADER_CT];
        }
        
        //绑定当前显示的图片下标block
        cellHeader.callBack = ^(NSInteger index){
            _headerIndext = index;
        };
        
        //刷新UI
        [cellHeader updateUIWithModel:_dataSource[indexPath.row] andType:FOODDETECTIVE_HEADER_CT];
        
        //消除选择状态
        cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cellHeader;
    }
    
    //普通cell
    if ([_dataSource count] > 1 && indexPath.row >= 1) {
        static NSString *normalName = @"normalCell";
        QSMarAcNoticeTableViewCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:normalName];
        if (nil == cellHeader) {
            cellHeader = [[QSMarAcNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalName andCellType:FOODDETECTIVE_NORMAL_CT];
        }
        
        //刷新UI
        [cellHeader updateUIWithModel:_dataSource[indexPath.row] andType:FOODDETECTIVE_NORMAL_CT];
        
        //消除选择状态
        cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cellHeader;
    }
    
    //normal cell
    static NSString *normalCellName = @"normalCell";
    UITableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCellName];
    if (nil == cellNormal) {
        cellNormal = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellName];
    }
    cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cellNormal;
}

//返回每个section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

//返回每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CGFloat width = DeviceWidth;
        CGFloat height = (345.0f / 640.0f) * width;
        return height;
    }
    
    CGFloat width = DeviceWidth;
    CGFloat height = (340.0f / 640.0f) * width;
    return height;
}

#pragma mark - 进入每一个推荐店详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //进入header详情
    if ((indexPath.row == 0) && ([_dataSource count] > 0)) {
        QSTryActivitiesViewController *src = [[QSTryActivitiesViewController alloc] init];
        QSFoodDetectiveRecommendModel *model = _dataSource[indexPath.row][_headerIndext];
        [src setValue:model.userID forKey:@"userID"];
        [src setValue:model.actID forKey:@"tryActivitiesID"];
        [self.navigationController pushViewController:src animated:YES];
        return;
    }
    
    //进入普通推荐店详情
    if ((indexPath.row > 0) && ([_dataSource count] > 1)) {
        QSArticleFoodDetectiveViewController *src = [[QSArticleFoodDetectiveViewController alloc] init];
        [src loadArticleWithID:((QSFoodDetectiveMarchAcNoticeModel *)_dataSource[indexPath.row]).actID];
        [src setMiddleTitle:((QSFoodDetectiveMarchAcNoticeModel *)_dataSource[indexPath.row]).share_title];
        [self.navigationController pushViewController:src animated:YES];
        return;
    }
}

#pragma mark - UITableView进行头部刷新
- (void)tableViewBeginHeaderRefresh
{
    UITableView *tableView = objc_getAssociatedObject(self, &FoodDetectiveTableViewKey);
    [tableView headerBeginRefreshing];
}

#pragma mark - UITableView进行尾部刷新
- (void)tableViewBeginFooterRefresh
{
    UITableView *tableView = objc_getAssociatedObject(self, &FoodDetectiveTableViewKey);
    [tableView footerBeginRefreshing];
}

#pragma mark - UITableView刷新消息
- (void)updateTableView
{
    UITableView *tableView = objc_getAssociatedObject(self, &FoodDetectiveTableViewKey);
    [tableView reloadData];
}

@end
