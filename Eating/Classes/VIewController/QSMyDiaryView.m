//
//  QSMyDiaryView.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyDiaryView.h"
#import "MJRefresh.h"
#import "QSConfig.h"
#import "QSAPIClientBase+MyDiary.h"
#import "QSMyDiaryTableViewCell.h"

#import <objc/runtime.h>

//关联
static char MyDiaryListKey;
@interface QSMyDiaryView ()<UITableViewDataSource,UITableViewDelegate>{
    int _page;//页码
    NSMutableArray *_myDiaryList;//数据源
}

@end

@implementation QSMyDiaryView

//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //数据源数组初始化
        _myDiaryList = [[NSMutableArray alloc] init];
        
        //初始化页码
        _page = 1;
        
        //创建UI
        [self createMyDiaryViewUI];
        
    }
    return self;
}

//创建UI
- (void)createMyDiaryViewUI
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
    [tableView addHeaderWithTarget:self action:@selector(requestMyDiaryHeaderData)];
    
    //开始就进行头部转新
//    [tableView headerBeginRefreshing];
    
    //添加
    [self addSubview:tableView];
    
    //关联
    objc_setAssociatedObject(self, &MyDiaryListKey, tableView, OBJC_ASSOCIATION_ASSIGN);
#endif
    
}

//*******************************
//             请求头数据
//*******************************
#pragma mark - 请求头数据
- (void)requestMyDiaryHeaderData
{
    [[QSAPIClientBase sharedClient] myDiaryListDataRequest:^(NSArray *resultArray) {
        if ([resultArray count] > 0) {
            [_myDiaryList removeAllObjects];
            [_myDiaryList addObjectsFromArray:resultArray];
            [self updateTableView];
        }
        //停止刷新
        [self endDataRequestAnim];
    } andFailCallBack:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"美食侦探社数据下载失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
        //停止刷新
        [self endDataRequestAnim];
        
    }];
}

//UITableView结束刷新动画
- (void)endDataRequestAnim
{
    UITableView *tableView = objc_getAssociatedObject(self, &MyDiaryListKey);
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
}

//刷新UI
- (void)updateTableView
{
    UITableView *tableView = objc_getAssociatedObject(self, &MyDiaryListKey);
    [tableView reloadData];
}

//*******************************
//             UITableView数据返回
//*******************************
#pragma mark - UITableView数据返回
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //数据源有数据，则加载有效cell
    if ([_myDiaryList count] > 0) {
        static NSString *normalName = @"normalCell";
        QSMyDiaryTableViewCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:normalName];
        if (nil == cellHeader) {
            cellHeader = [[QSMyDiaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalName];
        }
        
        //刷新UI
        [cellHeader updateMyTaskCellUIWithModel:_myDiaryList[indexPath.row]];
        
        //消除选择状态
        cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cellHeader;
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
    return [_myDiaryList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = DeviceWidth;
    CGFloat height = (340.0f / 640.0f) * width;
    return height;
}

//*******************************
//             重新请求头部数据
//*******************************
#pragma mark - 重新请求头部数据
- (void)loadMyDiaryData
{
    UITableView *tableView = objc_getAssociatedObject(self, &MyDiaryListKey);
    [tableView headerBeginRefreshing];
}

@end
