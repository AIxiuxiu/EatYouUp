//
//  QSFreeFoodStoreViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFreeFoodStoreViewController.h"
#import "MJRefresh.h"
#import "QSAPIModel+QSFreeActivitiesStore.h"
#import "QSAPIClientBase+QSFreeFoodStore.h"
#import "QSFreeActivitiesTableViewCell.h"
#import "QSTryActivitiesViewController.h"

#import <objc/runtime.h>

//UITabelView关联
static char FreeFoodStoreListKey;
@interface QSFreeFoodStoreViewController () <UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataSource;//数据源
}

@end

@implementation QSFreeFoodStoreViewController

//*******************************
//             创建UI
//*******************************
#pragma mark - 创建UI
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setMiddleTitle:@"免费大餐"];
}

//创建主显示视图
- (void)createMiddleMainShowView
{
    //设置scrollview的不自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //UITableView：FreeFoodStoreListKey
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 80.0f, DeviceWidth, DeviceHeight - 110.0f) style:UITableViewStylePlain];
    
    //去除滚动条
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    
    //设置数据源和代理
    tableView.dataSource = self;
    tableView.delegate = self;
    
    //设置透明颜色
    tableView.backgroundColor = [UIColor clearColor];
    
    //关联
    objc_setAssociatedObject(self, &FreeFoodStoreListKey, tableView, OBJC_ASSOCIATION_ASSIGN);
    
    //添加头尾刷新
    [tableView addHeaderWithTarget:self action:@selector(headerDataRequest)];
    
    //消除分隔线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加到主视图
    [self.view addSubview:tableView];
    
    //开始头部刷新
    [tableView headerBeginRefreshing];
}

//*******************************
//             cell创建
//*******************************
#pragma mark - cell创建
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //活动列表cell
    if ([_dataSource count] > 0) {
        static NSString *actCellName = @"actCellName";
        QSFreeActivitiesTableViewCell *cellAct = [tableView dequeueReusableCellWithIdentifier:actCellName];
        if (nil == cellAct) {
            cellAct = [[QSFreeActivitiesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:actCellName];
        }
        
        //去除选择状态
        cellAct.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //刷新数据
        QSFreeActivitiesStoreModel *model = _dataSource[indexPath.row];
        [cellAct updateFreeActivityCellUIWithModel:model];
        
        //返回
        return cellAct;
    }

#if 1
    //默认系统cell
    static NSString *systemCellName = @"systemCell";
    UITableViewCell *systemCell = [tableView dequeueReusableCellWithIdentifier:systemCellName];
    if (nil == systemCell) {
        systemCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCellName];
    }
    
    //消除选择状态
    systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return systemCell;
#endif
}

//返回每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

//返回每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

//*******************************
//请求数据：头部数据请求，翻页数据请求
//*******************************
#pragma mark - 请求数据：头部数据请求，翻页数据请求
- (void)headerDataRequest
{
    [[QSAPIClientBase sharedClient] freeActivitiesStoreListWithCallBack:^(NSArray *respondArray) {
        if ([respondArray count] > 0) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:respondArray];
            
            //刷新数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reloadDateAfertRequest];
            });
        }
        //结束头尾刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endReloadDataAnimin];
        });
        
    } failCallBack:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"免费活动数据下载失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
        
        //结束头尾刷新
        [self endReloadDataAnimin];
    }];
}

#pragma mark - 刷新数据
- (void)reloadDateAfertRequest
{
    UITableView *tableView = objc_getAssociatedObject(self, &FreeFoodStoreListKey);
    [tableView reloadData];
}

#pragma mark - 结束刷新数据动画
- (void)endReloadDataAnimin
{
    UITableView *tableView = objc_getAssociatedObject(self, &FreeFoodStoreListKey);
    [tableView headerEndRefreshing];
}

#pragma mark - 进入活动详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource count] > 0 && _dataSource[indexPath.row]) {
        QSTryActivitiesViewController *src = [[QSTryActivitiesViewController alloc] init];
        QSFreeActivitiesStoreModel *model = _dataSource[indexPath.row];
        [src setValue:model.userID forKey:@"userID"];
        [src setValue:model.actID forKey:@"tryActivitiesID"];
        [self.navigationController pushViewController:src animated:YES];
    }
}

@end
