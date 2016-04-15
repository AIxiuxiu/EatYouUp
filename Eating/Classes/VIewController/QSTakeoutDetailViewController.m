//
//  QSTakeoutDetailViewController.m
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSTakeoutDetailViewController.h"
#import "QSAPIClientBase+Takeout.h"
#import "QSAPIModel+Takeout.h"
#import "QSRecommendFoodListCell.h"
#import "QSAPIModel+Food.h"
#import "QSAPIClientBase+Book.h"
#import "QSAPIModel+Book.h"
#import "QSTakeoutProgressViewController.h"
#import "QSPrepaidCarPayViewController.h"
#import "QSAPIClientBase+Takeout.h"
#import "QSAlixPayManager.h"
#import "QSYCustomHUD.h"
#import "AppDelegate.h"
#import "QSAPIClientBase+StoreCard.h"
#import "QSAPIModel+StoreCard.h"
#import "ASDepthModalViewController.h"
#import "QSAlixPayManager.h"
#import "QSYOrderNormalFormModel.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"
#import "QSCommitOrderViewController.h"

#import <ASDepthModalViewController.h>

@interface QSTakeoutDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) QSTakeoutDetailReturnData *takeoutDetailReturnData;
@property (nonatomic, strong) QSBookDetailReturnData *bookDetailReturnData;
@property (nonatomic, strong) NSMutableArray *foodlist;//!<外卖订单所点的餐列表数据源
@property (nonatomic,strong) UITableView *myStoreCardView;//!<我的储值卡列表
@property (nonatomic,retain) QSStoreCardListReturnData *storeCardListReturnData;//!<我的储值卡数据源

@end

@implementation QSTakeoutDetailViewController

- (void)setTakeoutDetailReturnData:(QSTakeoutDetailReturnData *)takeoutDetailReturnData
{
    
    _takeoutDetailReturnData = takeoutDetailReturnData;
    
    _foodlist = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [_takeoutDetailReturnData.data.detail objectForKey:@"greens"]) {
        
        QSFoodDetailData *info = [[QSFoodDetailData alloc] init];
        info.goods_name = [dict objectForKey:@"goods_name"];
        info.goods_pice = [dict objectForKey:@"b_gold"];
        info.goods_image = [dict objectForKey:@"goods_image"];
        info.status = [dict objectForKey:@"status"];
        info.num = [dict objectForKey:@"num"];
        [_foodlist addObject:info];
        
    }
    self.takeoutStatus = [_takeoutDetailReturnData.data.status intValue];
    [self setupLogoAndTitle];
    [self setupStatusView];
    [self setupInfoView];
    [self setupTableView];
    
    self.orderScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.foodTableView.frame)+10);
    
}

- (void)setBookDetailReturnData:(QSBookDetailReturnData *)bookDetailReturnData
{
    
    _bookDetailReturnData = bookDetailReturnData;
    
    self.bookStatus = [bookDetailReturnData.data.status intValue];
    if (self.bookStatus == 1 && (!bookDetailReturnData.data.book_type || !bookDetailReturnData.data.book_no)) {
        
        self.bookStatus = kBookOrderStatus_Booking;
        
    }
    [self setupLogoAndTitle];
    [self setupStatusView];
    [self setupInfoView];
    
    self.foodTableView.hidden = YES;
    
    self.orderScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.infoView.frame)+10);
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.orderDetailType == kOrderDetailType_Takeout) {
        
        [self getTakeoutOrderDetail];
        
    } else if (self.orderDetailType == kOrderDetailType_Book){
        
        [self getBookOrderDetail];
        
    }
}

- (void)setupUI
{
    self.seatLabel.textColor = kBaseOrangeColor;
    self.dateLabel.textColor = kBaseOrangeColor;
    self.timeLabel.textColor = kBaseOrangeColor;
    [self.dateView roundCornerRadius:5];
    [self.addressView roundCornerRadius:5];
    [self.contactView roundCornerRadius:5];
    [self.mobileView roundCornerRadius:5];
    [self.couponView roundCornerRadius:5];
    [self.payWayView roundCornerRadius:5];
    [self.memoView roundCornerRadius:5];
}

- (void)setupLogoAndTitle
{
    
    if (self.orderDetailType == kOrderDetailType_Takeout) {
        
        [self.logoImageView takeoutDetailOrderLogoView:self.takeoutStatus];
        self.titleLabel.text = [_takeoutDetailReturnData.data.merchant_msg objectForKey:@"merchant_name"];
        
    } else if (self.orderDetailType == kOrderDetailType_Book){
        
        [self.logoImageView bookDetailOrderLogoView:self.bookStatus bookno:[NSString stringWithFormat:@"%@%@",self.bookDetailReturnData.data.book_type,self.bookDetailReturnData.data.book_no]];
        self.titleLabel.text = [_bookDetailReturnData.data.merchant_msg objectForKey:@"merchant_name"];
        
    }

}

#pragma mark - 刷新头信息
- (void)setupStatusView
{
    
    CGRect frame = self.baseView.frame;
    frame.origin.y = 20;
    frame.size.width = DeviceWidth;
    UIColor *borderColor;
    NSString *statusTitle;
    
    if (self.orderDetailType == kOrderDetailType_Takeout) {
        
        [self.progressButton customButton:kCustomButtonType_TakeoutOrderProgree];
        
        if (self.takeoutStatus == kTakeoutOrderStatus_Unpay) {
            
            self.payButton.hidden = NO;
            frame.size.height = CGRectGetMaxY(self.payButton.frame)+10;
            self.baseView.frame = frame;
            [self.payButton roundCornerRadius:18];
            
            borderColor = kBaseGreenColor;
            statusTitle = @"等待付款";
            
        } else if (self.takeoutStatus == kTakeoutOrderStatus_Pay) {
            
            self.payButton.hidden = YES;
            frame.size.height = CGRectGetMaxY(self.progressButton.frame)+10;
            self.baseView.frame = frame;
            
            borderColor = kBaseOrangeColor;
            statusTitle = @"已安排送餐";
            
        } else if (self.takeoutStatus == kTakeoutOrderStatus_Delivered) {
            
            self.payButton.hidden = YES;
            frame.size.height = CGRectGetMaxY(self.progressButton.frame)+10;
            self.baseView.frame = frame;
            
            borderColor = kBaseGrayColor;
            statusTitle = @"订单已签收";
            
        } else if (self.takeoutStatus == kTakeoutOrderStatus_Cancelled) {
            
            self.payButton.hidden = YES;
            frame.size.height = CGRectGetMaxY(self.progressButton.frame)+10;
            self.baseView.frame = frame;
            
            borderColor = kBaseGrayColor;
            statusTitle = @"订单已取消";
            
        }
        
        self.orderSnLabel.text = _takeoutDetailReturnData.data.take_out_num;
        
    } else if (self.orderDetailType == kOrderDetailType_Book){
        
        [self.progressButton customButton:kCustomButtonType_ChatToMerchant];
        
        if (self.bookStatus == kBookOrderStatus_UnConfirm) {
            
            self.payButton.hidden = YES;
            frame.size.height = CGRectGetMaxY(self.progressButton.frame)+10;
            self.baseView.frame = frame;
            [self.payButton roundCornerRadius:18];
            
            borderColor = kBaseGreenColor;
            statusTitle = @"待确认";
            
        } else if (self.bookStatus == kBookOrderStatus_Booking) {
            
            self.payButton.hidden = YES;
            frame.size.height = CGRectGetMaxY(self.progressButton.frame)+10;
            self.baseView.frame = frame;
            
            borderColor = kBaseGreenColor;
            statusTitle = @"已确认,预约中";
        } else if (self.bookStatus == kBookOrderStatus_Inqueue) {
            self.payButton.hidden = YES;
            frame.size.height = CGRectGetMaxY(self.progressButton.frame)+10;
            self.baseView.frame = frame;
            
            borderColor = kBaseOrangeColor;
            statusTitle = @"排位中,等待叫号";
            
        } else if (self.bookStatus == kBookOrderStatus_Confirmed) {
            
            self.payButton.hidden = NO;
            frame.size.height = CGRectGetMaxY(self.payButton.frame)+10;
            self.baseView.frame = frame;
            [self.payButton roundCornerRadius:18];
            
            borderColor = kBaseOrangeColor;
            statusTitle = [NSString stringWithFormat:@"已到号,请到%@%@位",self.bookDetailReturnData.data.book_type,self.bookDetailReturnData.data.book_no];
            [self.payButton setTitle:@"延时时间" forState:UIControlStateNormal];
            
        } else if (self.bookStatus == kBookOrderStatus_Inshop) {
            
            self.payButton.hidden = YES;
            frame.size.height = CGRectGetMaxY(self.progressButton.frame)+10;
            self.baseView.frame = frame;
            
            borderColor = kBaseGreenColor;
            statusTitle = @"已确认";
            
        } else if (self.bookStatus == kBookOrderStatus_ClientCanceled || self.bookStatus == kBookOrderStatus_RestCanceled) {
            
            self.payButton.hidden = YES;
            frame.size.height = CGRectGetMaxY(self.progressButton.frame)+10;
            self.baseView.frame = frame;
            
            borderColor = kBaseGrayColor;
            statusTitle = @"已取消预约";
            
        }
        
        self.orderSnLabel.text = _bookDetailReturnData.data.book_or_num;
    }
    

    [self.orderStatusButton setTitle:statusTitle forState:UIControlStateNormal];
    [self.orderStatusButton.layer setBorderColor:borderColor.CGColor];
    [self.orderStatusButton setTitleColor:borderColor forState:UIControlStateNormal];
    [self.orderStatusButton.layer setBorderWidth:0.7];
    [self.orderStatusButton roundCornerRadius:5];
    
    frame = self.ellImageView.frame;
    frame.origin.y = CGRectGetMaxY(self.baseView.frame);
    frame.size.width = DeviceWidth;
    frame.size.height = 15;
    self.ellImageView.frame = frame;
    
    frame = self.statusView.frame;
    frame.size.height = CGRectGetMaxY(self.ellImageView.frame)+10;
    frame.size.width = DeviceWidth;
    self.statusView.frame = frame;
    

    [self.callButton customButton:kCustomButtonType_CallToMerchant];
    
    self.orderSnLabel.textColor = kBaseGrayColor;
    
}

- (void)setupInfoView
{
    
    if (self.orderDetailType == kOrderDetailType_Takeout) {
        
        self.seatItemLabel.text = @"外卖数量";
        self.dateItemLabel.text = @"送餐日期";
        self.timeItemLabel.text = @"送餐时间";
        
        self.seatLabel.text = [NSString stringWithFormat:@"%@份",_takeoutDetailReturnData.data.take_num_count];
        self.dateLabel.text = _takeoutDetailReturnData.data.take_out_date;
        self.timeLabel.text = _takeoutDetailReturnData.data.take_out_time;
        
        self.mobileTextField.text = _takeoutDetailReturnData.data.take_out_phone;
        self.contactTextField.text = _takeoutDetailReturnData.data.take_out_name;
        self.addressTextField.text = _takeoutDetailReturnData.data.add;
        
        ///显示优惠券
        NSString *couponInfo = _takeoutDetailReturnData.data.couponInfo.couponName ? _takeoutDetailReturnData.data.couponInfo.couponName : @"不使用优惠券";
        [self.couponButton setTitle:couponInfo forState:UIControlStateNormal];
        
        NSArray *temp = @[@"在线支付",@"餐到付款",@"储值卡支付"];
        if ([_takeoutDetailReturnData.data.pay_type integerValue] <= 3) {
            
            int index = [_takeoutDetailReturnData.data.pay_type intValue]-1;
            self.payWayLabel.text = index > 0 ? temp[index] : temp[0];
            
        }
        
        [self.sexButton setTitle:[_bookDetailReturnData.data.book_sex isEqualToString:@"1"] ? @"先生" : @"女士"  forState:UIControlStateNormal];
        CGRect frame = self.infoView.frame;
        frame.origin.y = CGRectGetMaxY(self.statusView.frame);
        frame.size.height = CGRectGetMaxY(self.memoView.frame)+5;
        self.infoView.frame = frame;
        
    } else if (self.orderDetailType == kOrderDetailType_Book){
        
        self.seatItemLabel.text = @"就餐人数";
        self.dateItemLabel.text = @"预约日期";
        self.timeItemLabel.text = @"预约时间";
        
        self.seatLabel.text = [NSString stringWithFormat:@"%@人",_bookDetailReturnData.data.book_num];
        self.dateLabel.text = _bookDetailReturnData.data.book_date;
        self.timeLabel.text = _bookDetailReturnData.data.book_time;
        
        self.mobileTextField.text = _bookDetailReturnData.data.book_phone;
        self.contactTextField.text = _bookDetailReturnData.data.book_name;
        self.addressItemLabel.text = @"优先包厢";
        self.addressTextField.text = [_bookDetailReturnData.data.book_seat_type isEqualToString:@"1"] ? @"是" : @"否";
        
        [self.sexButton setTitle:[_bookDetailReturnData.data.book_sex isEqualToString:@"1"] ? @"先生" : @"女士"  forState:UIControlStateNormal];
        
        CGRect frame = self.infoView.frame;
        frame.origin.y = CGRectGetMaxY(self.statusView.frame);
        frame.size.width = DeviceWidth;
        frame.size.height = CGRectGetMaxY(self.mobileView.frame) + 5;
        self.infoView.frame = frame;
        
    }

    [self.sexButton customButton:kCustomButtonType_ItemSelect];

}

- (void)setupTableView
{
    
    [self.foodTableView reloadData];
    
    self.foodTableView.tableHeaderView = [UIView listHeaderView:@"外卖餐单"];
    CGRect frame = self.foodTableView.frame;
    frame.origin.y = CGRectGetMaxY(self.infoView.frame)+30;
    frame.size.width = DeviceWidth;
    frame.size.height = 50+68*self.foodlist.count;
    self.foodTableView.frame = frame;
    
}

- (void)getTakeoutOrderDetail
{
    
    __weak QSTakeoutDetailViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] takeoutOrderDetail:self.order_id
                                               success:^(QSTakeoutDetailReturnData *response) {
                                                   
                                                   [weakSelf hideLoadingHud];
                                                   weakSelf.takeoutDetailReturnData = response;
                                                   
                                               } fail:^(NSError *error) {
                                                   
                                                   [weakSelf hideLoadingHud];
                                                   
                                               }];
    
}

- (void)getBookOrderDetail
{
    
    __weak QSTakeoutDetailViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] bookDetailWithBookId:self.order_id
                                                 success:^(QSBookDetailReturnData *response) {
                                                     [weakSelf hideLoadingHud];
                                                     weakSelf.bookDetailReturnData = response;
                                                 } fail:^(NSError *error) {
                                                     [weakSelf hideLoadingHud];
                                                 }];
}

#pragma mark - 预约延迟/外卖重新支付按钮事件
- (IBAction)onPayButtonAction:(id)sender
{
    
    ///预约定单:延迟预约
    if (self.bookStatus == kBookOrderStatus_Confirmed) {
        
        [self bookDelay];
        return;
        
    }
    
    ///外卖订单:重新支付
    if (self.takeoutStatus == kTakeoutOrderStatus_Unpay) {
        
        [self payTakeOutOrderAgent];
        return;
        
    }

}

- (IBAction)onPhoneCallButtonAction:(id)sender
{
    
    if (self.orderDetailType == kOrderDetailType_Takeout) {
        
        [self makeCall:_takeoutDetailReturnData.data.merchant_call];
        
    } else if (self.orderDetailType == kOrderDetailType_Book){
        
        [self makeCall:[_bookDetailReturnData.data.merchant_msg objectForKey:@"merchant_call"]];
        
    }

}

- (IBAction)onProgressButtonAction:(id)sender
{
    if (self.orderDetailType == kOrderDetailType_Takeout) {
        QSTakeoutProgressViewController *viewVC = [[QSTakeoutProgressViewController alloc] init];
        viewVC.item = self.takeoutDetailReturnData.data;
        [ASDepthModalViewController presentView:viewVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
            
        }];
    }
        else if (self.orderDetailType == kOrderDetailType_Book){
        [self makeCall:[_bookDetailReturnData.data.merchant_msg objectForKey:@"merchant_call"]];
    }

}

#pragma mark - 重新支付外卖单
- (void)payTakeOutOrderAgent
{
    
    ///获取模型
    QSTakeoutDetailData *model = self.takeoutDetailReturnData.data;
    int payType = [model.pay_type intValue];

    ///在线支付
    if (1 == payType) {
        
        ///显示HUD
        [QSYCustomHUD showOperationHUD:self.view];
        
        ///还需要在线支付时，跳转到支付宝
        [[QSAPIClientBase sharedClient] makePayOrder:model.takeout_id online_money:model.price_count pay_type:[NSString stringWithFormat:@"%d",payType] indent_type:@"2" store_card_list:nil success:^(QSAlixPayTakeoutReturnData *response) {
            
            ///当准确返回时才进行实际支付
            if (response.type) {
                
                [self gotoAlixPayWithOrderForm:response.payModelList[0] ? response.payModelList[0] : response.orderModel];
                
            } else {
                
                [self showTip:self.view tipStr:response.errorInfo andCallBack:^{
                    
                    ///隐藏HUD
                    [QSYCustomHUD hiddenOperationHUD];
                    
                    ///进入订单列表页面
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                
            }
            
        } fail:^(NSError *error) {
            
            [self showTip:self.view tipStr:@"支付失败，请稍后再试" andCallBack:^{
                
                ///进入订单列表页面
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
        }];
        
    }
    
    ///储值卡支付
    if (3 == payType) {
        
        ///弹出储值卡选择页面
        [[QSAPIClientBase sharedClient] userStoreCardList:self.takeoutDetailReturnData.data.merchant_id key:@"" page_num:@"1" orderType:@"5" success:^(QSStoreCardListReturnData *response) {
            
            self.storeCardListReturnData = response;
            
            ///判断是否有可使用的储值卡
            if (0 >= [response.data count]) {
                
                [self showTip:self.view tipStr:@"暂无可用的储值卡。" andCallBack:^{}];
                return;
            }
            
            ///弹出储值卡选择列表
            [ASDepthModalViewController presentView:self.myStoreCardView backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){}];
            [self.myStoreCardView reloadData];
            
        } fail:^(NSError *error) {
            
            ///获取失败
            [self showTip:self.view tipStr:@"暂无可用储值卡。"];
            
        }];
        
    }

}
         
/**
 *  @author             yangshengmeng, 15-12-31 09:12:04
 *
 *  @brief              在线支付的时候，跳转到支付宝页面前的数据准备
 *
 *  @param orderForm    订单信息
 *
 *  @since              2.0
 */
- (void)gotoAlixPayWithOrderForm:(QSAlixPayModel *)orderForm
{
    
    ///保存回调：当支付宝回跳到当前应用时，让payHUD移除
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentControllerCallBack = ^(NSString *payCode,NSString *payInfo){
        
        NSLog(@"==========================%@,%@",payInfo,payCode);
        
        ///判断支付结果
        [self checkPayResultWithCode:payCode andPayResultInfo:payInfo andOrderForm:orderForm];
        
    };
    
    ///设置回调
    __weak QSAlixPayModel *weakOderForm = orderForm;
    orderForm.alixpayCallBack = ^(NSString *payCode,NSString *payInfo) {
        
        
        NSLog(@"==========================%@,%@",payInfo,payCode);
        
        ///判断支付结果
        [self checkPayResultWithCode:payCode andPayResultInfo:payInfo andOrderForm:weakOderForm];
        
    };
    
    ///跳转到支付宝支付页面
    NSLog(@"==================================%@",orderForm);
    [[QSAlixPayManager sharedQSAlixPayManager] startAlixPay:orderForm];
    
}

#pragma mark - 返回储值卡选择列表
- (UITableView *)myStoreCardView
{
    if (!_myStoreCardView) {
        
        _myStoreCardView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth-100, DeviceHeight-150)];
        _myStoreCardView.delegate = self;
        _myStoreCardView.dataSource = self;
        [_myStoreCardView roundCornerRadius:8];
        
    }
    
    return _myStoreCardView;
}

/**
 *  @author         yangshengmeng, 14-12-14 16:12:44
 *
 *  @brief          判断支付返回的结果
 *
 *  @param payCode  支付宝返回的支付结果
 *
 *  @since          2.0
 */
#pragma mark - 检测支付宝返回的支付结果代码
- (void)checkPayResultWithCode:(NSString *)payCode andPayResultInfo:(NSString *)payInfo andOrderForm:(QSAlixPayModel *)orderForm
{
    
    ///隐藏HUD
    [QSYCustomHUD hiddenOperationHUD];
    
    ///将支付回调的代码，转换为整数代码
    int resultCode = [payCode intValue];
    
    /**
     *                  9000---订单支付成功
     *                  8000---正在处理中
     *                  4000---订单支付失败
     *                  6001---用户中途取消
     *                  6002---网络连接出错
     */
    
    ///支付成功回调：进入支付成功页面
    if (resultCode == 9000) {
        
        if (nil == orderForm) {
            
            [self showTip:self.view tipStr:@"交易成功。" andCallBack:^{
                
                ///进入订单列表页面
                [self.navigationController popViewControllerAnimated:YES];
                
                ///让列表刷新数据
                if (self.payAgentCallBack) {
                    
                    self.payAgentCallBack(YES);
                    
                }
                
            }];
            
            return;
            
        }
        
        ///确认支付
        NSDictionary *commitDict = @{@"trade_no" : orderForm.orderNum,
                                     @"out_trade_no" : orderForm.billNum,
                                     @"status" : @"1"};
        
        [[QSAPIClientBase sharedClient] commitPay:commitDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
            
            [self showTip:self.view tipStr:@"交易成功" andCallBack:^{
                
                ///进入订单列表页面
                [self.navigationController popViewControllerAnimated:YES];
                
                ///让列表刷新数据
                if (self.payAgentCallBack) {
                    
                    self.payAgentCallBack(YES);
                    
                }
                
            }];
            
        }];
        
        return;
        
    }
    
    ///支付回调：正在处理中
    if (resultCode == 8000) {
        
        [self showTip:self.view tipStr:@"正在处理" andCallBack:^{
            
            ///进入订单列表页面
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        return;
        
    }
    
    ///没有进行支付，直接点返回，或者发生错误后，点击返回
    if (resultCode == 6001) {
        
        [self showTip:self.view tipStr:@"支付失败" andCallBack:^{
            
            ///进入订单列表页面
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        return;
        
    }
    
    ///6002---网络不可用
    if (resultCode == 6002) {
        
        [self showTip:self.view tipStr:@"交易失败" andCallBack:^{
            
            ///进入订单列表页面
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        return;
        
    }
    
    ///4000---返回时报支付失败
    if (resultCode == 4000) {
        
        [self showTip:self.view tipStr:@"支付失败" andCallBack:^{
            
            ///进入订单列表页面
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        return;
    }
    
}

#pragma mark - 延迟预约订单的时间
- (void)bookDelay
{

    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] bookDelayWithMerchantId:self.bookDetailReturnData.data.merchange_id orderId:self.bookDetailReturnData.data.book_id success:^(QSAPIModelDict *response) {
        
        [self hideLoadingHud];
        
        ///判断是否延时成功
        if (response.type) {
            
            [self showTip:self.view tipStr:@"您的预约已成功延迟！" andCallBack:^(){
            
                [self.navigationController popViewControllerAnimated:YES];
            
            }];
            
            ///回调
            if(self.payAgentCallBack){
            
                self.payAgentCallBack(YES);
            
            }
            
        } else {
        
            [self showTip:self.view tipStr:response.msg andCallBack:^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        
        }
        
    } fail:^(NSError *error){
        
        [self hideLoadingHud];
        [self showTip:self.view tipStr:@"网络不给力，请稍后再试！"];
        
    }];
}

#pragma mark - 返回列表有多少个区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

#pragma mark - 返回列表有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    ///餐单列表
    if (tableView == self.foodTableView) {
        
        return self.foodlist.count;
        
    }
    
    ///储值卡列表
    if (tableView == self.myStoreCardView) {
        
        return self.storeCardListReturnData.data.count;
        
    }
    
    return 0;
    
}

#pragma mark - 返回列表的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.foodTableView) {
        
        return 68.0f;
        
    } else {
    
        return 44.0f;
    
    }
    
}

#pragma mark - 返回订单货物信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///储值卡列表
    if (tableView == self.myStoreCardView) {
        
        static NSString *identifier = @"storeCardCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            
        }
        QSStoreCardDetailData *info = self.storeCardListReturnData.data[indexPath.row];
        cell.textLabel.text = info.storeCardMsg[@"goods_name"];
        cell.detailTextLabel.text = info.limit_val;
        return cell;
        
    } else {
        
        ///餐单列表
        static NSString *identifier = @"foodInfoCell";
        QSRecommendFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSRecommendFoodListCell" owner:self options:nil];
            if ([nibs count] > 0) {
                
                cell = nibs[0];
                
            }
            
        }
        
        cell.cellType = kRecommendFoodType_TakeoutShow;
        cell.item = self.foodlist[indexPath.row];
        return cell;
        
    }
    
}

#pragma mark - 选择储值卡后，重新支付
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.myStoreCardView) {
        
        QSStoreCardDetailData *info = self.storeCardListReturnData.data[indexPath.row];
        
        ///支付宝支付时的模型
        QSYOrderNormalFormModel *orderModel = [[QSYOrderNormalFormModel alloc] init];
        
        if ([info.limit_val floatValue] < [self.takeoutDetailReturnData.data.price_count floatValue]) {
            
            ///储值卡不足额，需要在线支付部分金额
            orderModel.orderID = self.takeoutDetailReturnData.data.takeout_id;
            orderModel.formPayType = TAKEOUT_PREPAIDCARDPAY_PAYAGENT_COPT;
            orderModel.marchantID = self.takeoutDetailReturnData.data.merchant_id;
            orderModel.totalPrice = [NSString stringWithFormat:@"%.2f",[info.limit_val floatValue] - [self.takeoutDetailReturnData.data.price_count floatValue]];
            orderModel.buyDate = [NSDate currentDateIntegerString];
            orderModel.userID = [UserManager sharedManager].userData.user_id;
            orderModel.payType = self.takeoutDetailReturnData.data.pay_type;
            orderModel.orderFormType = @"2";
            orderModel.userPhone = self.mobileTextField.text;
            orderModel.orderFormTitle = [NSString stringWithFormat:@"%@ 外卖订单",self.takeoutDetailReturnData.data.merchant_name];
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (QSFoodDetailData *info in self.foodlist) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:info.goods_id forKey:@"goods_id"];
                [dict setValue:info.goods_name forKey:@"goods_name"];
                [dict setValue:info.num forKey:@"goods_num"];
                [dict setValue:info.goods_pice forKey:@"goods_price"];
                [dict setValue:info.goods_real_pice forKey:@"goods_sale_money"];
                [temp addObject:dict];
                
            }
            
            orderModel.goodsList = temp;
            
            QSTakeoutDetailDataCouponInfoDataModel *couponModel = self.takeoutDetailReturnData.data.couponInfo;
            ///保存优惠券信息
            if (couponModel) {
                
                NSDictionary *couponDict = @{@"store_card_id" : couponModel.couponID,
                                             @"store_card_name" : couponModel.couponName,
                                             @"store_card_value" : couponModel.couponPrice};
                orderModel.couponList = [@[couponDict] mutableCopy];
                
            }
            
            ///保存储值卡信息
            NSDictionary *prepaidDict = @{@"store_id" : info.card_id,
                                          @"use_val" : info.limit_val,
                                          @"limit_val" : @"0.00",
                                          @"name" : [info.storeCardMsg valueForKey:@"goods_name"]};
            orderModel.prepaidCardList = [@[prepaidDict] mutableCopy];
            
            [ASDepthModalViewController dismiss];
            
            QSCommitOrderViewController *commitOrder = [[QSCommitOrderViewController alloc] initWithOrderModel:orderModel];
            
            ///保存回调
            commitOrder.payResultCallBack = ^(NSString *errorInfo,NSString *errorCode){
                
                [self checkPayResultWithCode:errorCode andPayResultInfo:errorInfo andOrderForm:nil];
                
            };
            
            [self.navigationController pushViewController:commitOrder animated:YES];
            
        } else {
            
            /**
             *  user_id int 用户id
             *  indent_id int 订单id
             *  online_money float 在线支付的
             *  pay_type int 支付类型
             *  indent_type int 订单类型
             *  store_card_list array
             *      结构 array(
             *          store_id  int 用户领取到的储值卡id，
             *          use_val  float 使用的价格
             *          limit_val  float 使用后剩余的价格
             *          name string 储值卡的名字
             *      )
             *  store_card_money float 储值卡要给的总价
             */
            
            ///封装参数
            NSDictionary *prepaidCardDict = @{@"store_id" : info.card_id,
                                              @"use_val" : self.takeoutDetailReturnData.data.price_count,
                                              @"limit_val" : [NSString stringWithFormat:@"%.2f",([info.limit_val floatValue] - [self.takeoutDetailReturnData.data.price_count floatValue])],
                                              @"name" : [info.storeCardMsg valueForKey:@"goods_name"]};
            
            NSDictionary *paramsDict = @{@"indent_id" : self.takeoutDetailReturnData.data.takeout_id,
                                         @"online_money" : @"0",
                                         @"pay_type" : self.takeoutDetailReturnData.data.pay_type,
                                         @"indent_type" : @"2",
                                         @"store_card_list" : @[prepaidCardDict],
                                         @"store_card_money" : self.takeoutDetailReturnData.data.price_count,
                                         @"limit_val" : info.limit_val,
                                         @"merchant_id" : self.takeoutDetailReturnData.data.merchant_id,
                                         @"merchant_name" : self.takeoutDetailReturnData.data.merchant_name,
                                         @"food_count" : [NSString stringWithFormat:@"%d",(int)self.foodlist.count]};
            
            ///隐藏选择窗口
            [ASDepthModalViewController dismiss];
            
            ///直接使用储值卡支付，进入支付确认页面
            QSPrepaidCarPayViewController *prepaidCommitVC = [[QSPrepaidCarPayViewController alloc] initWithPrepaidCardPayParams:paramsDict];
            [self.navigationController pushViewController:prepaidCommitVC animated:YES];
            
        }
        
    }
    
}

@end
