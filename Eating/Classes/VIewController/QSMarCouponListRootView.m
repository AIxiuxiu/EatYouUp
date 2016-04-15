//
//  QSMarCouponListRootView.m
//  Eating
//
//  Created by ysmeng on 14/12/3.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMarCouponListRootView.h"
#import "QSConfig.h"
#import "MJRefresh.h"
#import "QSPrepaidCardTableViewCell.h"
#import "QSPrepaidHeaderView.h"
#import "QSPrepaidCardListFooterView.h"
#import "QSAPIClientBase+CouponList.h"
#import "QSYCustomHUD.h"

@interface QSMarCouponListRootView ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_dataSource;        //!<数据源
    int _page;                          //!<页码
    int _maxPage;                       //!<服务器最多的页数
    
    //!<tableview相关尺寸
    CGFloat _heightOFheader;            //!<section头高度
    CGFloat _heightOFFooter;            //!<footer高度
    CGFloat _heightOFCell;              //!<footer高度
    
    //!<默认返回的行数
    NSInteger _numberOFRow;             //!<每个section默认的行数
    
    //!<每一个section展开多少行的数组
    NSMutableArray *_numberOFRowLoadArray;
    
    GET_COUPONTLIST_TYPE _listType;     //!<优惠券列表类型
    NSMutableDictionary *_listParamsDict;//!<列表的参数
    
}

@property (nonatomic,copy) void (^callBack)(NSString *marchantName,NSString *marchantID, NSString *volumeID,NSString *couponSubID,MYLUNCHBOX_COUPON_TYPE couponType,MYLUNCHBOX_COUPON_STATUS couponStatus);
@property (nonatomic,strong) UITableView *dataTableView;

@end

@implementation QSMarCouponListRootView

/**
 *  @author         yangshengmeng, 15-01-05 11:01:57
 *
 *  @brief          创建一个优惠券列表
 *
 *  @param frame    列表的大小和位置
 *  @param listType 列表类型
 *  @param params   参数
 *  @param callBack 请求成功或者失败时的回调
 *
 *  @return         返回一个优惠券列表
 *
 *  @since          2.0
 */
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame andCouponListType:(GET_COUPONTLIST_TYPE)listType andParams:(NSDictionary *)params andCallBack:(void (^)(NSString *marchantName,NSString *marchantID, NSString *volumeID,NSString *couponSubID,MYLUNCHBOX_COUPON_TYPE couponType,MYLUNCHBOX_COUPON_STATUS couponStatus))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///数据初始化
        [self initMarchantCouponListData:listType];
        
        ///保存商户ID
        _listParamsDict = [params mutableCopy];
        
        ///保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        ///创建UI
        [self createMarCouponListUI];
    }
    
    return self;

}

/**
 *  @author yangshengmeng, 14-12-11 12:12:59
 *
 *  @brief  根据不同的优惠列表类型初始化数据
 *
 *  @param  couponType 优惠券列表类型
 *
 *  @since  2.0
 */
#pragma mark -  根据不同的优惠列表类型初始化数据
- (void)initMarchantCouponListData:(GET_COUPONTLIST_TYPE)couponType
{
    //数据初始化
    _heightOFheader = 70.0f;
    _heightOFFooter = 20.0f;
    _heightOFCell = 100.0f;
    _dataSource = [[NSMutableArray alloc] init];
    _numberOFRowLoadArray = [[NSMutableArray alloc] init];
    _listType = couponType;
    _page = 1;
    _maxPage = 10;
    
    //初始化优惠券显示个数
    [self initNumberOFRowWithListType:couponType];
    
}

/**
 *  @author yangshengmeng, 14-12-11 12:12:20
 *
 *  @brief  根据不同的优惠券类型初始化列表默认显示的优惠券个数
 *
 *  @param  couponType 优惠券列表类型
 *
 *  @since  2.0
 */
#pragma mark -  根据不同的优惠券类型初始化列表默认显示的优惠券个数
- (void)initNumberOFRowWithListType:(GET_COUPONTLIST_TYPE)couponType
{
    if (couponType == MYLUNCHBOX_COUPONLIST_UNUSE_CGT) {
        
        _numberOFRow = 0;
        return;
        
    }
    
    _numberOFRow = 3;
}

/**
 *  @author yangshengmeng, 14-12-10 16:12:17
 *
 *  @brief  优惠券列表UI的创建
 *
 *  @since  2.0
 */
#pragma mark - 优惠券列表UI的创建
- (void)createMarCouponListUI
{
    //数据列表
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    
    //背景颜色
    self.dataTableView.backgroundColor = [UIColor clearColor];
    
    //分隔样式
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //数据源/代理
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    
    //去除滚动条
    self.dataTableView.showsHorizontalScrollIndicator = NO;
    self.dataTableView.showsVerticalScrollIndicator = NO;
    
    //添加头部/尾部刷新
    [self.dataTableView addHeaderWithTarget:self action:@selector(requestCouponListHeaderData)];
    
    ///如果是指定商户的优惠券列表，则不添加脚部刷新
    if (_listType < MERCHANT_COUPONLIST_CGT) {
        
        [self.dataTableView addFooterWithTarget:self action:@selector(requestCouponListFooterData)];
        
    }
    
    //开始就进行头部刷新
    [self.dataTableView headerBeginRefreshing];
    
    [self addSubview:self.dataTableView];
    
    //将tableView移到最后
    [self sendSubviewToBack:self.dataTableView];
}

/**
 *  @author yangshengmeng, 14-12-10 16:12:58
 *
 *  @brief        点击一个优惠券时将券ID和商户名称回调到所在的VC，并进入详情页面
 *
 *  @param cardID 优惠券ID
 *  @param title  商户名称
 *  @param type   优惠券类型
 *
 *  @since        2.0
 */
#pragma mark - 进入详情页面
- (void)gotoPrepaidCardDetailVC:(NSString *)marchantName andMarID:(NSString *)marchantID andCardID:(NSString *)cardID andCardSubID:(NSString *)cardSubID andType:(MYLUNCHBOX_COUPON_TYPE)type andStatus:(MYLUNCHBOX_COUPON_STATUS)couponStatus
{
    
    if (self.callBack) {
        
        self.callBack(marchantName,marchantID,cardID,cardSubID,type,couponStatus);
        
    }
    
}

//结束刷新动画
- (void)endRefreshAnimate
{
    
    [self.dataTableView headerEndRefreshing];
    [self.dataTableView footerEndRefreshing];
    
}

//*******************************************
//             发起头/尾数据请求
//*******************************************
#pragma mark - 发起头/尾数据请求
- (void)requestCouponListHeaderData
{
    ///判断是否是使用测试样例
    if (_listType == DEFAULT_GCT) {
        [self endRefreshAnimate];
        return;
    }
    
    [self requestCouponListWithPage:1 andCallBack:^(BOOL flag) {
        
        if (!flag) {
         
            ///显示无记录说明
            [self showNoRecordView:YES];
            return;
        }
        
        _page = 1;
        [self showNoRecordView:NO];
        
    }];
    
}

/**
 *  @author yangshengmeng, 15-12-29 14:12:15
 *
 *  @brief  请求优惠券列表数据
 *
 *  @since  2.0
 */
- (void)requestCouponListWithPage:(int)page andCallBack:(void(^)(BOOL flag))callBack
{

    ///普通列表
    [[QSAPIClientBase sharedClient] getCouponListWithType:_listType andPage:page andParams:_listParamsDict andCallBack:^(BOOL resutlFlag,QSMarchantListReturnData *resultModel, NSString *errorInfo, NSString *errorCode) {
        
        ///清空原数据源
        if (page == 1) {
            
            [_dataSource removeAllObjects];
            
        }
        
        ///请求失败
        if (!resutlFlag) {
            
            ///结束刷新动画
            [self endRefreshAnimate];
            
            ///如果是第一页，刷新数据
            if (page == 1) {
                
                [self.dataTableView reloadData];
                
            }
            
            ///回调
            callBack(NO);
            
            return;
        }
        
        /**
         *  商户优惠列表信息请求成功
         *
         *  @param  resultArray 解析完成后的商户数组
         *  @param  errorInfo   错误信息
         *  @param  errorCode   错误代码
         *
         *  @since  2.0
         *
         */
        
        ///重置最大页码
        _maxPage = [resultModel.totalPage intValue];
        
        //保存数据
        [_dataSource addObjectsFromArray:resultModel.marList];
        
        //重整每个section编制个数数组
        [self resetMarchantCouponLoadCount];
        
        ///回调
        callBack(YES);
        
        //刷新数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.dataTableView reloadData];
            //停止刷新动画
            [self endRefreshAnimate];
            
        });
        
    }];

}

- (void)requestCouponListFooterData
{
    ///判断是否是使用测试样例
    if (_listType == DEFAULT_GCT) {
        [self endRefreshAnimate];
        return;
    }
    
    ///判断是否已没有更多数据：已没有更多数据时，不再允许加载更多数据，同时显示没有更多数据
    if (_page == _maxPage) {
        [self endRefreshAnimate];
        return;
    }
    
    ///请求更多数据
    [self requestCouponListWithPage:_page + 1 andCallBack:^(BOOL flag) {
        
        ///请求成功
        if (flag) {
            
            _page += 1;
            
        }
        
    }];
}

//*******************************************
//             优惠卷
//*******************************************
#pragma mark - 优惠卷
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //是否没有优惠卷：显示没有记录
    NSInteger countOFVolume = [((QSMarchantBaseInfoDataModel *)_dataSource[indexPath.section]).couponList count];
    
    if (countOFVolume == 0) {
        static NSString *noneCellName = @"noneCell";
        QSPrepaidCardTableViewCell *cellNone = [tableView dequeueReusableCellWithIdentifier:noneCellName];
        if (nil == cellNone) {
            cellNone = [[QSPrepaidCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noneCellName andCellType:NONEPRPAIDCARD_CELL_PREPAIDCT];
        }
        
        //取消选择状态
        cellNone.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cellNone;
    }
    
    //是否只有一个优惠卷
    if (countOFVolume == 1) {
        
        static NSString *singleCellName = @"singleCell";
        QSPrepaidCardTableViewCell *cellSingle = [tableView dequeueReusableCellWithIdentifier:singleCellName];
        if (nil == cellSingle) {
            cellSingle = [[QSPrepaidCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:singleCellName andCellType:((_listType == MYLUNCHBOX_COUPONLIST_UNUSE_CGT) ? ADDMORE_LASTLINE_CELL_PREPAIDCT : SINGLELINE_CELL_PREPAIDCT)];
        }
        
        cellSingle.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///根据数据源刷新数据
        [cellSingle updatePrepaidCardCellUI:((QSMarchantBaseInfoDataModel *)_dataSource[indexPath.section]).couponList[indexPath.row]];
        
        return cellSingle;
        
    }
    
    //是否是第一行cell
    if (indexPath.row == 0) {
        
        static NSString *headerCellName = @"hearderCell";
        QSPrepaidCardTableViewCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:headerCellName];
        if (nil == cellHeader) {
            cellHeader = [[QSPrepaidCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellName andCellType:FIRSTLINE_CELL_PREPAIDCT];
        }
        
        cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///根据数据源刷新数据
        [cellHeader updatePrepaidCardCellUI:((QSMarchantBaseInfoDataModel *)_dataSource[indexPath.section]).couponList[indexPath.row]];
        
        return cellHeader;
        
    }
    
    //是否最后一个cell：一种情况是个数正好默认行数，另一种情况是默认行数
    int lastIndex = [_numberOFRowLoadArray[indexPath.section] intValue];
    if (countOFVolume > _numberOFRow && (indexPath.row == (lastIndex - 1))) {
        
        static NSString *lastSpecialCellName = @"lastSpecialCell";
        QSPrepaidCardTableViewCell *cellLastSpecial = [tableView dequeueReusableCellWithIdentifier:lastSpecialCellName];
        if (nil == cellLastSpecial) {
            cellLastSpecial = [[QSPrepaidCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastSpecialCellName andCellType:ADDMORE_LASTLINE_CELL_PREPAIDCT];
        }
        
        cellLastSpecial.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///根据数据源刷新数据
        [cellLastSpecial updatePrepaidCardCellUI:((QSMarchantBaseInfoDataModel *)_dataSource[indexPath.section]).couponList[indexPath.row]];
        
        return cellLastSpecial;
        
    }
    
    if (indexPath.row == (lastIndex - 1)) {
        static NSString *lastCellName = @"lastCell";
        QSPrepaidCardTableViewCell *cellLast = [tableView dequeueReusableCellWithIdentifier:lastCellName];
        if (nil == cellLast) {
            cellLast = [[QSPrepaidCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellName andCellType:((_listType == MYLUNCHBOX_COUPONLIST_UNUSE_CGT) ? ADDMORE_LASTLINE_CELL_PREPAIDCT : LASTLINE_CELL_PREPAIDCT)];
        }
        
        cellLast.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///根据数据源刷新数据
        [cellLast updatePrepaidCardCellUI:((QSMarchantBaseInfoDataModel *)_dataSource[indexPath.section]).couponList[indexPath.row]];
        
        return cellLast;
    }
    
    //普通cell
    static NSString *normalCellName = @"normalCell";
    QSPrepaidCardTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCellName];
    if (nil == cellNormal) {
        cellNormal = [[QSPrepaidCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellName andCellType:MIDDLELINE_CELL_PREPAIDCT];
    }
    
    cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///根据数据源刷新数据
    [cellNormal updatePrepaidCardCellUI:((QSMarchantBaseInfoDataModel *)_dataSource[indexPath.section]).couponList[indexPath.row]];
    
    return cellNormal;
}

//返回每个section的header view
#pragma mark - 美食店信息
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewName = @"headerView";
    QSPrepaidHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewName];
    
    if (nil == headerView) {
        headerView = [[QSPrepaidHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 70.0f)];
    }
    
    //刷新UI
    [headerView updatePrepaidCardHeaderUI:_dataSource[section]];
    
    return headerView;
}

//返回section的footerview
#pragma mark - 显示更多/收起控件
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSInteger count = [((QSMarchantBaseInfoDataModel *)_dataSource[section]).couponList count];
    
    //如果优惠卷个数小于3，不加载footerview
    if (count <= _numberOFRow) {
        return nil;
    }
    
    NSString *footerName = [NSString stringWithFormat:@"footerView%d",(int)section];
    QSPrepaidCardListFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerName];
    
    //显示更多/收起
    int couponCount = [_numberOFRowLoadArray[section] intValue];
    BOOL footerStatus = couponCount < count ? NO : YES;
    
    if (nil == footerView) {
        //优惠卷多于3个，则加载footerview
        footerView = [[QSPrepaidCardListFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, _heightOFFooter) andStatus:footerStatus andCallBack:^(PREPAIDCARD_LIST_FOOTER_ACTIONTYPE actionType,BOOL flag) {
            if (actionType == LOADMORE_PLFA) {
                [self loadMoreCouponAction:section andFlag:flag];
            }
        }];
    }
    
    return footerView;
}

//返回有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
}

//返回每个section有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_numberOFRowLoadArray[section] intValue];
}

//点击某一行
#pragma mark - 点击优惠卷
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///商户模型
    QSMarchantBaseInfoDataModel *merchantModel = _dataSource[indexPath.section];
    
    ///商户名称
    NSString *marchantName = merchantModel.marName;
    
    ///商户ID
    NSString *marchantID = merchantModel.marID;
    
    ///优惠券对象
    QSMarCouponDetailDataModel *couponModel = merchantModel.couponList[indexPath.row];
    
    ///优惠券ID
    NSString *couponID = couponModel.couponID;
    
    ///优惠券类型:formatCouponTypeWithType
    MYLUNCHBOX_COUPON_TYPE type = [couponModel formatCouponTypeWithType];
    
    ///获取优惠券的状态
    MYLUNCHBOX_COUPON_STATUS status = [couponModel getCouponCurrentStatus];
    
    ///把商户相关的信息存在暂时文件中
    NSDictionary *merchantBaseInfoDict = @{@"merchantName" : merchantModel.marName,
                                           @"merchantID" : merchantModel.marID,
                                           @"merchantLat" : merchantModel.marLatitude,
                                           @"merchantLong" : merchantModel.marLongitude,
                                           @"merchantIcon" : merchantModel.marIcon,
                                           @"merchantScore" : merchantModel.marRemarkScore,
                                           @"merchantAddress" : merchantModel.marAddress};
    [[NSUserDefaults standardUserDefaults] setObject:merchantBaseInfoDict forKey:@"merchantTempInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ///回调
    [self gotoPrepaidCardDetailVC:marchantName andMarID:marchantID andCardID:couponID andCardSubID:couponModel.couponSubID andType:type andStatus:status];
}

#pragma mark - HeaderView/FooterView/Cell的高度
//返回头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _heightOFheader;
}

//返回每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _heightOFCell;
}

//返回footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger count = [((QSMarchantBaseInfoDataModel *)_dataSource[section]).couponList count];
    
    //如果优惠卷个数小于_numberOFRow，不加载footerview
    if (count <= _numberOFRow) {
        return 0.0f;
    }
    
    return _heightOFFooter;
}

//显示更多/或者收起loadMoreCouponAction
#pragma mark - 显示更多/或者收起
- (void)loadMoreCouponAction:(NSInteger)section andFlag:(BOOL)flag
{
    if (flag) {
        
        //修改加载的行数
        [_numberOFRowLoadArray replaceObjectAtIndex:section withObject:[NSString stringWithFormat:@"%d", (int)[((QSMarchantBaseInfoDataModel *)_dataSource[section]).couponList count]]];
        
    } else {
        
        [_numberOFRowLoadArray replaceObjectAtIndex:section withObject:[NSString stringWithFormat:@"%d", (int)_numberOFRow]];
        
    }
    
    //刷新给定的section
    [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationTop];
}

/**
 *  @author yangshengmeng, 14-12-11 09:12:09
 *
 *  @brief  根据最新的商户列表，计算每个商户默认显示的优惠卷数量：每个商户的优惠记录大于_numberOFRow时，默认显示_numberOFRow条记录，小于等于_numberOFRow时，按记录数显示
 *
 *  @since  2.0
 */
#pragma mark - 根据最新的商户列表，计算每个商户默认显示的优惠卷数量
- (void)resetMarchantCouponLoadCount
{
    ///判断数据源是否有效
    if (0 >= [_dataSource count]) {
        return;
    }
    
    NSInteger index = 0;
    
    ///判断是否头部刷新
    if (_page == 1) {
        
        ///清空原记录数组
        [_numberOFRowLoadArray removeAllObjects];
        
    } else {
        
        index = [_numberOFRowLoadArray count];
        
    }
    
    ///循环取得每个商户的优惠记录数
    for (int i = (int)index;i < [_dataSource count];i++) {
        
        QSMarchantBaseInfoDataModel *obj = _dataSource[i];
        
        ///优惠券个数
        NSInteger couponCount = [obj.couponList count];
        
        ///判断是否大于3
        [_numberOFRowLoadArray addObject:[NSString stringWithFormat:@"%d",(int)((couponCount > _numberOFRow) ? _numberOFRow : couponCount)]];
        
    }
}

/**
 *  @author yangshengmeng, 14-12-10 16:12:34
 *
 *  @brief  商户优惠列表头部刷新
 *
 *  @since  2.0
 */
#pragma mark - 提供外部访问的头部刷新
/**
 *  @author         yangshengmeng, 15-01-05 09:01:35
 *
 *  @brief          根据不同的参数类型，请求不同的数据
 *
 *  @param params   参数
 *
 *  @since          2.0
 */
- (void)couponListSearchRefresh:(NSDictionary *)params
{

    [_listParamsDict removeAllObjects];
    [_listParamsDict addEntriesFromDictionary:params];
    
    ///刷新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.dataTableView headerBeginRefreshing];
        
    });

}

- (void)showNoRecordView:(BOOL)flag
{
    ///获取暂无记录
    UILabel *noRecordLabel = (UILabel *)[self viewWithTag:499];
    
    if (flag) {
        
        if (nil == noRecordLabel) {
            
            noRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 60.0f, self.frame.size.width-60.0f, 60.0f)];
            noRecordLabel.text = @"暂无记录";
            noRecordLabel.textAlignment = NSTextAlignmentCenter;
            noRecordLabel.textColor = kBaseGrayColor;
            noRecordLabel.font = [UIFont boldSystemFontOfSize:40.0f];
            noRecordLabel.tag = 499;
            noRecordLabel.alpha = 0.0f;
            [self addSubview:noRecordLabel];
            [self bringSubviewToFront:noRecordLabel];
            
        }
        
        ///显示无记录
        [UIView animateWithDuration:0.5 animations:^{
            
            noRecordLabel.alpha = 1.0f;
            
        }];
        
        return;
    }
    
    ///不显示无记录
    if (noRecordLabel) {
        
        [noRecordLabel removeFromSuperview];
        
    }
    
}

/**
 *  @author yangshengmeng, 15-01-07 18:01:34
 *
 *  @brief  提供给外部使用的主动头部刷新
 *
 *  @since  2.0
 */
#pragma mark - 提供给外部使用的主动头部刷新
- (void)couponListHeaderRefresh
{

    ///刷新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.dataTableView headerBeginRefreshing];
        
    });

}

@end
