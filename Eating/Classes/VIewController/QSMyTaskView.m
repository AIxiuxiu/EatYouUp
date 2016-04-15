//
//  QSMyTaskView.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyTaskView.h"
#import "MJRefresh.h"
#import "QSMyTaskTableViewCell.h"
#import "QSAPIClientBase+MyTask.h"
#import "QSConfig.h"

#import <objc/runtime.h>

//关联
static char MyTaskListKey;
@interface QSMyTaskView ()<UITableViewDataSource,UITableViewDelegate>{
    int _page;//页码
    NSMutableArray *_myTaskList;//数据源
}

@end

@implementation QSMyTaskView

//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //数据源数组初始化
        _myTaskList = [[NSMutableArray alloc] init];
        
        //初始化页码
        _page = 1;
        
        //创建UI
        [self createMyTaskViewUI];
    }
    return self;
}

//创建UI
- (void)createMyTaskViewUI
{
    
#if 1
    
    ///显示敬请期待
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 160.0f, DeviceWidth-60.0f, 30.0f)];
    tipsLabel.text = @"暂未开放";
    tipsLabel.font = [UIFont systemFontOfSize:30.0f];
    tipsLabel.textColor = kBaseGrayColor;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipsLabel];
    
#endif
    
#if 0
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    
    //不显示滚动条
    tableView.showsHorizontalScrollIndicator = YES;
    tableView.showsVerticalScrollIndicator = NO;
    
    //数据源
    tableView.dataSource = self;
    tableView.delegate = self;
    
    //背景颜色
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //头部刷新
    [tableView addHeaderWithTarget:self action:@selector(requestMyTaskHeaderData)];
    
    //开始就进行头部转新
    [tableView headerBeginRefreshing];
    
    //添加
    [self addSubview:tableView];
    
    //关联
    objc_setAssociatedObject(self, &MyTaskListKey, tableView, OBJC_ASSOCIATION_ASSIGN);
#endif
    
}

//*******************************
//             请求头数据
//*******************************
#pragma mark - 请求头数据
- (void)requestMyTaskHeaderData
{
    [[QSAPIClientBase sharedClient] myTaskListDataRequest:^(NSArray *myTaskList) {
        
        if ([myTaskList count] > 0) {
            [_myTaskList removeAllObjects];
            [_myTaskList addObjectsFromArray:myTaskList];
            
            //刷新数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reloadDateAfertRequest];
            });
        }
        //结束头尾刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endDataRequestAnim];
        });
        
    } andFailCallBack:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"免费活动数据下载失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
        
        //结束头尾刷新
        [self endDataRequestAnim];
        
    }];
}

//UITableView结束刷新动画
- (void)endDataRequestAnim
{
    UITableView *tableView = objc_getAssociatedObject(self, &MyTaskListKey);
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
}

//刷新UI
- (void)reloadDateAfertRequest
{
    UITableView *tableView = objc_getAssociatedObject(self, &MyTaskListKey);
    [tableView reloadData];
}

//*******************************
//             UITableView数据返回
//*******************************
#pragma mark - UITableView数据返回
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //数据源有数据，则加载有效cell
    //活动列表cell
    if ([_myTaskList count] > 0) {
        static NSString *actCellName = @"actCellName";
        QSMyTaskTableViewCell *cellAct = [tableView dequeueReusableCellWithIdentifier:actCellName];
        if (nil == cellAct) {
            cellAct = [[QSMyTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:actCellName];
        }
        
        //去除选择状态
        cellAct.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //刷新数据
        QSMyTaskDataModel *model = _myTaskList[indexPath.row];
        [cellAct updateMyTaskCellUIWithModel:model];
        
        //返回
        return cellAct;
    }
    
    //系统cell
    static NSString *systemCellName = @"systemCell";
    UITableViewCell *cellSystem = [tableView dequeueReusableCellWithIdentifier:systemCellName];
    if (nil == cellSystem) {
        cellSystem = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCellName];
    }
    
    return cellSystem;
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_myTaskList count];
}

//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

//*******************************
//             重新请求头部数据
//*******************************
#pragma mark - 重新请求头部数据
- (void)loadMyTaskData
{
    UITableView *tableView = objc_getAssociatedObject(self, &MyTaskListKey);
    [tableView headerBeginRefreshing];
}

@end
