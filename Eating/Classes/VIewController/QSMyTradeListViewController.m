//
//  QSMyTradeListViewController.m
//  Eating
//
//  Created by System Administrator on 12/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMyTradeListViewController.h"
#import "QSAPIClientBase+Trade.h"
#import "QSAPIModel+Trade.h"
#import "MJRefresh.h"
#import "QSMyTradeListCell.h"
#import "QSCommitOrderViewController.h"
#import "QSYOrderNormalFormModel.h"
#import "QSPrepaidCarPayViewController.h"

typedef enum
{
    kRefreshType_No,
    kRefreshType_Header,
    kRefreshType_Footer
}kRefreshType;

@interface QSMyTradeListViewController ()<UITableViewDataSource,UIScrollViewDelegate>{

    NSString *_comeBackVCIndext;//!<返回：返回到指定个数之前的页面

}

@property (nonatomic, strong) QSTradeListReturnData *tradeListReturnData;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, unsafe_unretained) NSInteger page;
@property (nonatomic, unsafe_unretained) kRefreshType refreshType;
@end

@implementation QSMyTradeListViewController

#pragma mark - 更新数据
- (void)setTradeListReturnData:(QSTradeListReturnData *)tradeListReturnData
{
    
    _tradeListReturnData = tradeListReturnData;
    if (self.refreshType == kRefreshType_Header) {
        
        self.dataSource = [NSMutableArray arrayWithArray:_tradeListReturnData.data];
        
    } else {
        
        [self.dataSource addObjectsFromArray:_tradeListReturnData.data];
        
    }
    
    [self.tradeTableView reloadData];
    
}

#pragma mark - UI搭建
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc] init];
    [self setupTableView];
    
    [self.tradeTableView headerBeginRefreshing];
}

- (void)setupUI
{
    self.titleLabel.text = @"我的交易";
    
    CGRect frame = self.tradeTableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 89;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 89 - 3;
    self.tradeTableView.frame = frame;
}

- (void)setupTableView
{
    [self.tradeTableView addHeaderWithCallback:^{
        self.refreshType = kRefreshType_Header;
        self.page = 1;
        [self getTradeList];
    }];
    
    [self.tradeTableView addFooterWithCallback:^{
        self.refreshType = kRefreshType_Footer;
        self.page++;
        [self getTradeList];
    }];
}

#pragma mark - 获取交易数据
- (void)getTradeList
{
    __weak QSMyTradeListViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] userTradeList:self.page success:^(QSTradeListReturnData *response) {
        
        [weakSelf hideLoadingHud];
        [weakSelf.tradeTableView headerEndRefreshing];
        [weakSelf.tradeTableView footerEndRefreshing];
        weakSelf.tradeListReturnData = response;
        
    } fail:^(NSError *error) {
        
        [weakSelf hideLoadingHud];
        [weakSelf.tradeTableView headerEndRefreshing];
        [weakSelf.tradeTableView footerEndRefreshing];
        
    }];
}

///重写返回事件：需要返回给定的位置
#pragma mark - 重写返回：实现返回指定的VC
- (IBAction)onBackButtonAction:(id)sender
{
    if (_comeBackVCIndext) {
        
        int cal = [_comeBackVCIndext intValue];
        NSInteger sum = [self.navigationController.viewControllers count];
        
        if (sum > cal) {
            
            UIViewController *tempVC = self.navigationController.viewControllers[sum - cal];
            [self.navigationController popToViewController:tempVC animated:YES];
            
        } else {
        
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 返回列表相关参数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0f;
    
}

#pragma mark - 返回每个交易信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    QSMyTradeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMyTradeListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            
            cell = nibs[0];
            
        }
        
    }
    
    ///刷新UI
    cell.item = self.dataSource[indexPath.row];
    
    //取消选中时的样式
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///获取模型
    QSTradeDetailData *model = self.dataSource[indexPath.row];
    
    ///获取当前记录的状态
    int status = [model.status intValue];
   
    ///2表示待付款
    if (2 == status) {
        
        [self payAgin:model];
        
    }
    
}

/**
 *  @author         yangshengmeng, 15-12-30 15:12:40
 *
 *  @brief          对未完成付款的记录进行再次付款
 *
 *  @param model    订单模型
 *
 *  @since          2.0
 */
#pragma mark - 对未完成付款的记录进行再次付款
- (void)payAgin:(QSTradeDetailData *)model
{
    
    ///如果是使用储值卡的情况，再次进入储值卡支付的页面
    if ([model.type isEqualToString:@"3"]) {
        
//        [self gotoPrepaidCardPay:model];
        return;
        
    }
    
    ///购买储值卡，未支付完成，则进入在线支付
#if 1
    ///创建订单的支付模型
    QSYOrderNormalFormModel *orderFormModel = [[QSYOrderNormalFormModel alloc] init];
    
    ///模型转换
    orderFormModel.orderID = model.indent_id;
    orderFormModel.formPayType = BUY_PREPAIDCARD_PAYAGENT_COPT;
    orderFormModel.orderNumber = model.order_num;
    orderFormModel.orderFormTitle = model.desc;
    orderFormModel.orderFormType = model.type;
    orderFormModel.payType = model.type;
    orderFormModel.userID = model.user_id;
    orderFormModel.totalPrice = model.pay_num;
    
    ///进入支付页面
    [self gotoOrderCommited:orderFormModel];
#endif

}

///进入储值卡支付页面
- (void)gotoPrepaidCardPay:(QSTradeDetailData *)model
{

    ///封装参数
    NSDictionary *prepaidCardDict = @{@"store_id" : @"储值卡ID",          //!<储值卡ID
                                      @"use_val" : model.pay_num,        //!<支付额
                                      @"limit_val" : model.pay_num,      //!<储值卡剩余额
                                      @"name" : model.pay_num};          //!<储值卡名字
    
    NSDictionary *paramsDict = @{@"indent_id" : model.trade_id,          //!<订单ID
                                 @"online_money" : @"0",                 //!<在线支付的金额
                                 @"pay_type" : @"3",                     //!<支付方式
                                 @"indent_type" : @"2",                  //!<订单类型
                                 @"store_card_list" : @[prepaidCardDict],//!<储值卡列表
                                 @"store_card_money" : model.pay_num,    //!<储值卡支付金额
                                 @"limit_val" : model.pay_num,           //!<储值卡剩余额
                                 @"merchant_id" : model.merchantID,      //!<商户ID
                                 @"merchant_name" : model.merchantID,    //!<商户名
                                 @"food_count" : @"1"};                  //!<货物数量
    
    ///直接使用储值卡支付，进入支付确认页面
    QSPrepaidCarPayViewController *prepaidCommitVC = [[QSPrepaidCarPayViewController alloc] initWithPrepaidCardPayParams:paramsDict];
    [self.navigationController pushViewController:prepaidCommitVC animated:YES];

}

///进入购买储值卡的支付页面
- (void)gotoOrderCommited:(QSYOrderNormalFormModel *)model
{

    ///进入订单页面
    QSCommitOrderViewController *commitVC = [[QSCommitOrderViewController alloc] initWithOrderModel:model];
    [self.navigationController pushViewController:commitVC animated:YES];

}

@end
