//
//  QSMerchantSelectedViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantSelectedViewController.h"
#import "QSConfig.h"
#import "QSResetImageFrameButton.h"
#import "MJRefresh.h"
#import "QSMerchantBaseTableViewCell.h"
#import "QSYCustomHUD.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIClientBase+Merchant.h"
#import "QSAPIModel+Merchant.h"

#import <objc/runtime.h>

///关联key
static char MerchantListKey;//!<商户列表

@interface QSMerchantSelectedViewController ()<UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *_dataSource;//!<商户列表的数据源，存的是每个商户的信息
    
    int _page;                  //!<保存当前页码
    
    int _listType;              //!<当前列表类型：1-我的收藏   2-推荐列表

}

@end

@implementation QSMerchantSelectedViewController

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
     
        _page = 1;
        
        _dataSource = [[NSMutableArray alloc] init];
        
        _listType = 1;
        
    }
    
    return self;

}

///UI创建
#pragma mark - UI创建
- (void)createNavigationBar
{

    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"餐厅选择"];

}

- (void)createMainShowView
{
    [super createMainShowView];
    
    ///我的收藏/推荐商户
    UIView *myCollectMerchant = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, 94.0f, DEFAULT_MAX_WIDTH, 44.0f)];
    myCollectMerchant.backgroundColor = [UIColor whiteColor];
    myCollectMerchant.layer.cornerRadius = 6.0f;
    [self.view addSubview:myCollectMerchant];
    [self createMerchantSelectedBox:myCollectMerchant];
    
    ///推荐商户
    CGFloat listYPoint = myCollectMerchant.frame.origin.y+myCollectMerchant.frame.size.height+8.0f;
    UITableView *merList = [[UITableView alloc] initWithFrame:CGRectMake(myCollectMerchant.frame.origin.x, listYPoint, DEFAULT_MAX_WIDTH, DeviceHeight-listYPoint-5.0f)];
    
    ///取消滚动条
    merList.showsHorizontalScrollIndicator = NO;
    merList.showsVerticalScrollIndicator = NO;
    
    ///取消背景颜色
    merList.backgroundColor = [UIColor clearColor];
    
    ///取消分隔线
    merList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///添加数据源和代理
    merList.dataSource = self;
    merList.delegate = self;
    
    ///添加头/脚刷新
    [merList addHeaderWithTarget:self action:@selector(merchantHeaderRefresh)];
    [merList addFooterWithTarget:self action:@selector(merchantFooterRefresh)];
    [merList headerBeginRefreshing];
    
    ///设置固定行高
    merList.rowHeight = 70.0f;
    
    [self.view addSubview:merList];
    
    ///关联
    objc_setAssociatedObject(self, &MerchantListKey, merList, OBJC_ASSOCIATION_ASSIGN);

}

/**
 *  @author yangshengmeng, 14-12-20 13:12:42
 *
 *  @brief  获取商户列表的UITableView
 *
 *  @return 返回商户列表的UITabelView
 *
 *  @since  2.0
 */
- (UITableView *)getMerchantListTableView
{

    UITableView *tableView = objc_getAssociatedObject(self, &MerchantListKey);
    return tableView;

}

///结束列表的头部和尾部刷新
- (void)endUITableViewHeaderAndFooterAnimination
{

    [[self getMerchantListTableView] headerEndRefreshing];
    [[self getMerchantListTableView] footerEndRefreshing];

}

/**
 *  @author     yangshengmeng, 14-12-20 12:12:28
 *
 *  @brief      创建商户类型选择的复选框
 *
 *  @param view 复选框所在的复选框
 *
 *  @since      2.0
 */
- (void)createMerchantSelectedBox:(UIView *)view
{

    ///创建选择按钮
    UIButton *myCollectedButton = [UIButton createRightTitleButton:^(UIButton *button) {
        
        ///如果本来就是选择状态，不回调
        if (button.selected) {
            return;
        }
        
        ///修改列表类型
        _listType = 1;
        
        ///刷新我的收藏列表
        [[self getMerchantListTableView] headerBeginRefreshing];
        
    }];
    ///设置标题
    [myCollectedButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [myCollectedButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [myCollectedButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    myCollectedButton.translatesAutoresizingMaskIntoConstraints = NO;
    myCollectedButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [myCollectedButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    myCollectedButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    myCollectedButton.selected = YES;
    [myCollectedButton addTarget:self action:@selector(merchantChoiceListUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:myCollectedButton];
    
    UIButton *recommendButton = [UIButton createRightTitleButton:^(UIButton *button) {
        
        ///如果本来就是选择状态，不回调
        if (button.selected) {
            return;
        }
        
        ///修改列表类型
        _listType = 2;
        
        ///刷新推荐商户列表
        [[self getMerchantListTableView] headerBeginRefreshing];
        
    }];
    ///设置标题
    [recommendButton setTitle:@"精选商家" forState:UIControlStateNormal];
    [recommendButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [recommendButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    recommendButton.translatesAutoresizingMaskIntoConstraints = NO;
    recommendButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [recommendButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    recommendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [recommendButton addTarget:self action:@selector(merchantChoiceListUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:recommendButton];
    
    ///编写约束
    NSString *___hVFL_allButton = @"H:|-10-[myCollectedButton]-(>=10)-[recommendButton]-10-|";
    NSString *___vVFL_myCollectedButton = @"V:|[myCollectedButton]|";
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_allButton options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(myCollectedButton,recommendButton)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_myCollectedButton options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(myCollectedButton)]];

}

/**
 *  @author         yangshengmeng, 14-12-20 12:12:35
 *
 *  @brief          根据点击的不同按钮刷新商户选择列表
 *
 *  @param button   当前点击的按钮
 *
 *  @since          2.0
 */
- (void)merchantChoiceListUpdateAction:(UIButton *)button
{

    ///如果点击的按钮当就就是选择状态，不进行刷新
    if (button.selected) {
        return;
    }
    
    ///交换选择状态
    for (UIButton *obj in [button.superview subviews]) {
        obj.selected = NO;
    }
    button.selected = YES;
    
}

#pragma mark - 商户列头/脚刷新
/**
 *  @author yangshengmeng, 14-12-20 13:12:17
 *
 *  @brief  商户列表头部刷新
 *
 *  @since  2.0
 */
- (void)merchantHeaderRefresh
{

    ///根据不同的列表类型，表求不同的数据
    if (_listType == 1) {
        
        [self requestMyCollectMerchantList:1];
        return;
        
    }
    
    if (_listType == 2) {
        
        [self requestRecommendMerchantList:1];
        return;
        
    }

}

- (void)requestRecommendMerchantList:(int)page
{
    ///开始HUD
    [QSYCustomHUD showOperationHUD:self.view];
    
    ///隐藏暂无记录
    [self showNoRecordUI:NO];

    [[QSAPIClientBase sharedClient] merchantListWithMerchantid:nil success:^(QSMerchantListReturnData *response) {
        
        ///请求成功
        ///重置页码
        _page = page;
        
        ///如果请求的是第一页数据，需要将数据源清空一次
        if (1 == page) {
            
            [_dataSource removeAllObjects];
            
        }
        
        ///加载新数据
        [_dataSource addObjectsFromArray:response.msg];
        
        ///刷新数据
        [[self getMerchantListTableView] reloadData];
        
        ///判断是否有数据
        if (1 == page && [response.msg count] <= 0) {
            
            ///显示暂无记录
            [self showNoRecordUI:YES];
            
        }
        
        ///结束刷新动画
        [self endUITableViewHeaderAndFooterAnimination];
        
        ///移除HUD
        [QSYCustomHUD hiddenOperationHUD];
        
    } fail:^(NSError *error) {
        
        ///请求失败
        ///如果是第一页请求失败，恢复原数据
        if (1 == page) {
            
            _page = 1;
            
            [_dataSource removeAllObjects];
            
            [[self getMerchantListTableView] reloadData];
            
            ///显示暂无记录
            [self showNoRecordUI:YES];
            
        }
        
        ///结束刷新动画
        [self endUITableViewHeaderAndFooterAnimination];
        
        ///移除HUD
        [QSYCustomHUD hiddenOperationHUD];
        
    }];

}

- (void)requestMyCollectMerchantList:(int)page
{
    ///开始HUD
    [QSYCustomHUD showOperationHUD:self.view];
    
    ///隐藏暂无记录
    [self showNoRecordUI:NO];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[QSAPIClientBase sharedClient] userMerchantList:page success:^(QSMerchantListReturnData *response) {
            
            ///重置页码
            _page = page;
            
            ///如果请求的是第一页数据，需要将数据源清空一次
            if (1 == page) {
                
                [_dataSource removeAllObjects];
                
            }
            
            ///加载新数据
            [_dataSource addObjectsFromArray:response.msg];
            
            ///刷新数据
            [[self getMerchantListTableView] reloadData];
            
            ///判断是否有数据
            if (1 == page && [response.msg count] <= 0) {
                
                ///显示暂无记录
                [self showNoRecordUI:YES];
                
            }
            
            ///结束刷新动画
            [self endUITableViewHeaderAndFooterAnimination];
            
            ///移除HUD
            [QSYCustomHUD hiddenOperationHUD];
            
            
        } fail:^(NSError *error) {
            
            ///如果是第一页请求失败，恢复原数据
            if (1 == page) {
                
                _page = 1;
                
                [_dataSource removeAllObjects];
                
                [[self getMerchantListTableView] reloadData];
                
                ///显示暂无记录
                [self showNoRecordUI:YES];
                
            }
            
            ///结束刷新动画
            [self endUITableViewHeaderAndFooterAnimination];
            
            ///移除HUD
            [QSYCustomHUD hiddenOperationHUD];
            
        }];
        
    });

}

/**
 *  @author yangshengmeng, 14-12-20 13:12:18
 *
 *  @brief  商户列表尾部刷新
 *
 *  @since  2.0
 */
- (void)merchantFooterRefresh
{

    ///根据不同的列表类型，进不同行请求
    ///根据不同的列表类型，表求不同的数据
    if (_listType == 1) {
        
        [self requestMyCollectMerchantList:_page+1];
        return;
        
    }
    
    if (_listType == 2) {
        
        ///结束刷新动画
        [self endUITableViewHeaderAndFooterAnimination];
        
        ///移除HUD
        [QSYCustomHUD hiddenOperationHUD];
        
        return;
        
    }

}

/**
 *  @author             yangshengmeng, 14-12-20 13:12:14
 *
 *  @brief              创建每个商户的基本信息项
 *
 *  @param tableView    所在的UITabelView
 *  @param indexPath    当前行下标
 *
 *  @return             返回一个商户基本信息的cell
 *
 *  @since              2.0
 */
#pragma mark - 创建每个商户基本信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellName = @"normalCell";
    
    QSMerchantBaseTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == myCell) {
        
        myCell = [[QSMerchantBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    
    ///取消选择时的底色
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///更新数据
    [myCell updateMerchantBaseTableViewWithModel:_dataSource[indexPath.row]];
    
    return myCell;

}

/**
 *  @author             yangshengmeng, 14-12-20 13:12:41
 *
 *  @brief              返回有多少行
 *
 *  @param tableView    商户信息显示所在的列表
 *  @param section      当前的section
 *
 *  @return             返回当前的分区中有多少行
 *
 *  @since              2.0
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_dataSource count];

}

/**
 *  @author             yangshengmeng, 14-12-21 10:12:12
 *
 *  @brief              选择某一个商家时，返回商家信息，并触发返回事件
 *
 *  @param tableView    商户列表
 *  @param indexPath    当前选择的商户坐标
 *
 *  @since              2.0
 */
#pragma mark - 选择某一个商家时，返回商家信息，并触发返回事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.callBack) {
        
        QSMerchantDetailData *model = _dataSource[indexPath.row];
        self.callBack(model.merchant_id,model.merchant_name,nil);
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

@end
