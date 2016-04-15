//
//  QSTakeoutFillInfoViewController.m
//  Eating
//
//  Created by MJie on 14-11-17.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSTakeoutFillInfoViewController.h"
#import "QSAPIModel+Food.h"
#import "QSAPIModel+Merchant.h"
#import "QSRecommendFoodListCell.h"
#import "QSTakeoutCouponListViewController.h"
#import "QSTakeoutOrderListViewController.h"
#import "NSString+Name.h"
#import "QSAPIClientBase+Takeout.h"
#import "QSAPIModel+Takeout.h"
#import <ASDepthModalViewController.h>
#import "QSDatePickerViewController.h"
#import "QSYOrderNormalFormModel.h"
#import "QSAPIModel+User.h"
#import "QSAlixPayManager.h"
#import "QSAPIModel+AlixPay.h"
#import "QSAPIModel+Coupon.h"
#import "QSAPIClientBase+StoreCard.h"
#import "AppDelegate.h"
#import "QSYCustomHUD.h"
#import "QSCommitOrderViewController.h"
#import "QSAPIModel+StoreCard.h"
#import "QSPrepaidCarPayViewController.h"
#import "QSAPIClientBase+Takeout.h"

@interface QSTakeoutFillInfoViewController ()<UIScrollViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *firstResponser;
@property (nonatomic, strong) QSDatePickerViewController *datePickerVC;
@property (nonatomic, copy) NSString *pay_type; //!<支付方式
@property (nonatomic,copy) NSString *orderID;   //!<订单号
@property (nonatomic,copy) NSString *realPayPrice;//!<实际支付金额
@property (nonatomic, strong) QSCouponDetailData *couponData;

@property (nonatomic, strong) UITableView *storeCardTableView;
@property (nonatomic, strong) QSStoreCardListReturnData *storeCardListReturnData;

@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, strong) NSMutableArray *foodlist;
@end

@implementation QSTakeoutFillInfoViewController

- (UITableView *)storeCardTableView
{
    if (!_storeCardTableView) {
        
        _storeCardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth-100, DeviceHeight-150)];
        _storeCardTableView.delegate = self;
        _storeCardTableView.dataSource = self;
        [_storeCardTableView roundCornerRadius:8];
        
    }
    
    return _storeCardTableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(timerAction:) userInfo:nil repeats:NO];
    
    ///联系人的默认信息
    self.contactTextField.text = [UserManager sharedManager].userData.username;
    
    ///联系人的默认性别
    if ([[UserManager sharedManager].userData.sex isEqualToString:@"1"]) {
        [self.sexButton setTitle:@"先生" forState:UIControlStateNormal];
    }
    else{
        [self.sexButton setTitle:@"女士" forState:UIControlStateNormal];
    }
    
    ///默认送餐地址
    self.addressTextField.text = [UserManager sharedManager].userData.default_address;
    
    ///默认联系电话
    self.mobileTextField.text = [UserManager sharedManager].userData.iphone;
    
    ///默认显示选择优惠券
    [self.couponButton setTitle:@"请选择优惠券" forState:UIControlStateNormal];
    
    self.totalPrice = [[[UserManager sharedManager] carOriginTotalMoney] copy];
    
    [self onPayWayButtonAction:self.paywayButton1];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animaFted
{
    [super viewWillAppear:animaFted];
    
    CGRect frame = self.formScrollView.frame;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 88;
    self.formScrollView.frame = frame;
    
    frame = self.addressView.frame;
    frame.size.width = DeviceWidth - 20;
    self.addressView.frame = frame;
    
    frame = self.contactView.frame;
    frame.size.width = DeviceWidth - 20;
    self.contactView.frame = frame;
    
    frame = self.mobileView.frame;
    frame.size.width = DeviceWidth - 20;
    self.mobileView.frame = frame;
    
    frame = self.couponView.frame;
    frame.size.width = DeviceWidth - 20;
    self.couponView.frame = frame;
    
    frame = self.payWayView.frame;
    frame.size.width = DeviceWidth - 20;
    self.payWayView.frame = frame;
    
    frame = self.memoView.frame;
    frame.size.width = DeviceWidth - 20;
    self.memoView.frame = frame;
    
    self.merchantLogoImageView.center = CGPointMake(DeviceMidX, 55);
    
}

- (void)timerAction:(NSTimer *)timer
{
    CGSize size = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.foodlistTableView.frame)+30);
    self.formScrollView.contentSize = size;
}

- (void)setupUI
{
    self.titleLabel.text = self.merchantIndexReturnData.data.merchant_name;
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 75, 100, 25)];
    button2.backgroundColor = kBaseGreenColor;
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
    [button2 setTitle:@"外卖订单" forState:UIControlStateNormal];
    button2.contentEdgeInsets = UIEdgeInsetsMake(-4, 0, 0, 0);
    [self.merchantLogoImageView addSubview:button2];
    
    [self.merchantLogoImageView setImageWithURL:[NSURL URLWithString:[_merchantIndexReturnData.data.merchant_logo imageUrl]] placeholderImage:IMAGENAME(@"merchant_defaultlog")];
    [self.merchantLogoImageView roundView];
    [self.merchantLogoImageView.layer setBorderWidth:3];
    [self.merchantLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.merchantLogoImageView.clipsToBounds = YES;
    self.view.backgroundColor = kBaseBackgroundColor;
    [self.confirmButton roundCornerRadius:18];
    [self.addressView roundCornerRadius:5];
    [self.contactView roundCornerRadius:5];
    [self.mobileView roundCornerRadius:5];
    [self.couponView roundCornerRadius:5];
    [self.payWayView roundCornerRadius:5];
    [self.memoView roundCornerRadius:5];
    [self.sexButton customButton:kCustomButtonType_ItemSelect];
    [self.sexButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [self.couponButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    self.addressTextField.returnKeyType = UIReturnKeyNext;
    self.contactTextField.returnKeyType = UIReturnKeyNext;
    self.mobileTextField.returnKeyType = UIReturnKeyDone;
    
    [self setupPayView];
    [self setupTableView];
}

- (void)setupPayView
{
    
}

- (void)setupTableView
{
    self.foodlistTableView.tableHeaderView = [UIView listHeaderView:@"外卖餐单"];
    
    UIView *temp = [UIView listFooterView:[[UserManager sharedManager] carFoodNum] and:[[UserManager sharedManager] carOriginTotalMoney]];
    temp.tag = 999;
    [self.foodFooterView addSubview:temp];
    self.foodlistTableView.tableFooterView = self.foodFooterView;

    CGRect frame = self.foodlistTableView.frame;
    frame.origin.y = CGRectGetMaxY(self.memoView.frame)+10;
    frame.size.width = DeviceWidth;
    frame.size.height = 68*self.foodlistReturnData.data.count+150;
    self.foodlistTableView.frame = frame;

}

- (IBAction)onSexButtonAction:(id)sender
{
    __weak QSTakeoutFillInfoViewController *weakSelf = self;
    [_firstResponser resignFirstResponder];
    _datePickerVC = [[QSDatePickerViewController alloc] init];
    _datePickerVC.pickerType = kPickerType_Item;
    NSArray *temp = @[@"先生",@"女士"];
    _datePickerVC.dataSource = [temp mutableCopy];
    [ASDepthModalViewController presentView:_datePickerVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
    _datePickerVC.onCancelButtonHandler = ^{
        [ASDepthModalViewController dismiss];
    };
    _datePickerVC.onItemConfirmButtonHandler = ^(NSInteger row, NSString *item){
        [weakSelf.sexButton setTitle:item forState:UIControlStateNormal];
        [ASDepthModalViewController dismiss];
    };
}

#pragma mark - 点击选择优惠券
- (IBAction)onCouponButtonAction:(id)sender
{

    __weak QSTakeoutFillInfoViewController *weakSelf = self;
    QSTakeoutCouponListViewController *viewVC = [[QSTakeoutCouponListViewController alloc] init];
    viewVC.merchant_id = self.merchantIndexReturnData.data.merchant_id;
    [self.navigationController pushViewController:viewVC animated:YES];
    viewVC.onCouponHandler = ^(BOOL isSelected, QSCouponDetailData *response){
        
        if (!isSelected) {
            
            [weakSelf.couponButton setTitle:@"不使用优惠券" forState:UIControlStateNormal];
            
        } else {
        
            [weakSelf.couponButton setTitle:response.goods_name forState:UIControlStateNormal];
        
        }
        
        weakSelf.couponData = response;
        [[self.foodFooterView viewWithTag:999] removeFromSuperview];
        UIView *temp = [UIView listFooterView:[[UserManager sharedManager] carFoodNum] and:[self calculateDiscountMoney]];
        temp.tag = 999;
        [self.foodFooterView addSubview:temp];
        
    };
}

- (IBAction)onPayWayButtonAction:(id)sender
{
    UIButton *button = sender;
    
    self.paywayButton1.selected = NO;
    self.paywayButton2.selected = NO;
    self.paywayButton3.selected = NO;
    button.selected = YES;
    [self.paywayButton1 customButton:kCustomButtonType_PayOnline];
    [self.paywayButton2 customButton:kCustomButtonType_PayReceived];
    [self.paywayButton3 customButton:kCustomButtonType_PayCard];
    
    self.pay_type = [NSString stringWithFormat:@"%d",(int)button.tag];
}

/**
 *  @author yangshengmeng, 15-12-31 09:12:20
 *
 *  @brief  计算订单实际需要支付的金额
 *
 *  @return 返回订单金额
 *
 *  @since  2.0
 */
#pragma mark - 计算订单实际需要支付的金额
- (NSString *)calculateDiscountMoney
{
    
    ///判断是否存在优惠券
    if (!self.couponData) {
        
        return self.totalPrice;
        
    }
    
    ///代金券
    if ([self.couponData.goods_v_type isEqualToString:@"1"]) {
        
        float ori = [self.totalPrice floatValue];
        return [NSString stringWithFormat:@"%.2f",ori-[self.couponData.coup_price floatValue] > 0.0f ? ori-[self.couponData.coup_price floatValue] : 0.0f];
        
        ///折扣券
    } else if ([self.couponData.goods_v_type isEqualToString:@"2"]){
        
        float ori = [self.totalPrice floatValue];
        return [NSString stringWithFormat:@"%.2f",ori*[self.couponData.coup_price integerValue]/100];
        
        ///菜品兑换券
    } else if ([self.couponData.goods_v_type isEqualToString:@"3"]){
        
        NSArray *goodids = [[UserManager sharedManager].carlist allKeys];
        float ori = [self.totalPrice floatValue];
        for (NSString *str in self.couponData.coup_goods_list) {
            
            if ([goodids containsObject:str]) {
                
                QSFoodDetailData *info = [UserManager sharedManager].carlist[str];
                return [NSString stringWithFormat:@"%.2f",ori-[info.goods_pice floatValue] > 0.0f ? ori-[info.goods_pice floatValue] : 0.0f];
                
            }
            
        }
    }
    
    return self.totalPrice;
    
}

- (NSArray *)getCouponListData
{
    
    if (!self.couponData) {
        
        return nil;
        
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:self.couponData.goods_at_num];
    
    return tempArray;

}

#pragma mark - 点击支付按钮：进入不同的支付判断
- (IBAction)onConfirmButtonAction:(id)sender
{
    
    if ([self.contactTextField.text isEqualToString:@""]) {
        [self showTip:self.view tipStr:@"请填写联系人"];
        return;
    }
    if ([self.mobileTextField.text isEqualToString:@""]) {
        [self showTip:self.view tipStr:@"请填写联系电话"];
        return;
    }
    if ([self.addressTextField.text isEqualToString:@""]) {
        [self showTip:self.view tipStr:@"请填写送餐地址"];
        return;
    }
    
    __weak QSTakeoutFillInfoViewController *weakSelf = self;
    [self showLoadingHud];
    
    ///确认订单时的支付额:减去优惠券
    __block NSString *totalMoney = [self calculateDiscountMoney];
    
    ///开始生成订单
    [[QSAPIClientBase sharedClient] addTakeout:self.merchantIndexReturnData.data.merchant_id bookDate:[NSDate currentDateWithFormattYYYMMDD] bookTime:[NSDate currentDateWithFormattHHMMSecondsLater:3600] bookName:self.contactTextField.text bookPhone:self.mobileTextField.text bookDesc:self.memoTextField.text totalNum:[[UserManager sharedManager] carFoodNum] totalMoney:totalMoney bookMenArr:self.foodlistReturnData.data couponList:[self getCouponListData] address:self.addressTextField.text sex:[self.sexButton.titleLabel.text isEqualToString:@"先生"] ? @"1" : @"0" payType:self.pay_type success:^(QSAPIModelDictddd *response) {
        
        ///隐藏HUD
        [weakSelf hideLoadingHud];
        
        ///判断是否生成订单成功
        if (!response.type) {
            
            [self showTip:self.view tipStr:@"网络繁忙，请稍后再试"];
            return;
        }
        
        self.foodlist = [[NSMutableArray alloc] initWithArray:[[UserManager sharedManager].carlist allValues]];
        
        [[UserManager sharedManager].carlist removeAllObjects];
        
        ///如果优惠券的金钱已足已支付时，直接进入订单列表
        if (0.1 > [totalMoney floatValue]) {
            
            [self showTip:self.view tipStr:@"交易成功" andCallBack:^{
                
                ///进入订单列表页面
                QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
                viewVC.merchant_id = self.merchant_id;
                viewVC.orderListType = kOrderListType_Takeout;
                [viewVC setValue:@"4" forKey:@"turnBackIndex"];
                [self.navigationController pushViewController:viewVC animated:YES];
                
            }];
            
            return;
        }
        
        ///在线支付
        if ([self.pay_type isEqualToString:@"1"]) {
            
            self.realPayPrice = totalMoney;
            [self succeedInHandoverOrder:[response.msg objectForKey:@"msg"]];
            
        ///储值卡支付
        } else if ([self.pay_type isEqualToString:@"3"]){
            
            [self storeCardPay:self.totalPrice and:self.foodlist andIndentID:[response.msg objectForKey:@"msg"] andRealPayPrice:totalMoney];
            
        ///餐到付款
        } else if ([self.pay_type isEqualToString:@"2"]){
            
            QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
            viewVC.merchant_id = weakSelf.merchant_id;
            viewVC.orderListType = kOrderListType_Takeout;
            [weakSelf.navigationController pushViewController:viewVC animated:YES];
            
        }
        
        ///请求失败
    } fail:^(NSError *error) {
        
        ///提示
        [self showTip:self.view tipStr:@"网络繁忙，请稍后再试"];
        
        ///隐藏HUD
        [weakSelf hideLoadingHud];
            
    }];
    
}

#pragma mark - 选择储值卡支付：选择储值卡
- (void)storeCardPay:(NSString *)totalPrice and:(NSArray *)foodlist andIndentID:(NSString *)indentID andRealPayPrice:(NSString *)realPayPrice
{
    
    ///保存订单号
    self.orderID = indentID;
    self.realPayPrice = realPayPrice;
    
    __weak QSTakeoutFillInfoViewController *weakSelf = self;
    ///获取储值卡列表
    [[QSAPIClientBase sharedClient] userStoreCardList:self.merchant_id key:@"" page_num:@"1" orderType:@"5" success:^(QSStoreCardListReturnData *response) {
        
        ///判断是否存在储值卡
        if (response.data.count <= 0) {
            
            [self showTip:@"在线支付" andCancelTitle:@"暂不支付" andTipsMessage:@"" andCallBack:^(UIAlertActionStyle actionStyle) {
                
                ///判断是否在线支付
                if (actionStyle == UIAlertActionStyleCancel) {
                    
                    ///
                    
                } else {
                
                    [self succeedInHandoverOrder:indentID];
                
                }
                
            }];
            return;
        }
        
        weakSelf.storeCardListReturnData = response;
        
        ///弹出储值卡选择列表
        [ASDepthModalViewController presentView:weakSelf.storeCardTableView backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){}];
        [weakSelf.storeCardTableView reloadData];
        
    } fail:^(NSError *error) {
        
        ///获取失败
        [self showTip:self.view tipStr:@"暂无可用的储值卡，请选择在线支付。"];
        
    }];

}

#pragma mark - 在线支付
- (void)succeedInHandoverOrder:(NSString *)indent_id
{
    
    if ([self.pay_type isEqualToString:@"1"]) {
        
        ///还需要在线支付时，跳转到支付宝
        [[QSAPIClientBase sharedClient] makePayOrder:indent_id online_money:self.realPayPrice pay_type:@"1" indent_type:@"2" store_card_list:nil success:^(QSAlixPayTakeoutReturnData *response) {
            
            ///当准确返回时才进行实际支付
            if (response.type) {
                
                [self gotoAlixPayWithOrderForm:response.payModelList[0]];
                
            } else {
                
                [self showTip:self.view tipStr:response.errorInfo andCallBack:^{
                    
                    ///进入订单列表页面
                    QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
                    viewVC.merchant_id = self.merchant_id;
                    viewVC.orderListType = kOrderListType_Takeout;
                    [viewVC setValue:@"4" forKey:@"turnBackIndex"];
                    [self.navigationController pushViewController:viewVC animated:YES];
                    
                }];
            
            }
            
        } fail:^(NSError *error) {
            
            [self showTip:self.view tipStr:@"当前网络不可用，请稍后再试" andCallBack:^{
                
                ///进入订单列表页面
                QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
                viewVC.merchant_id = self.merchant_id;
                viewVC.orderListType = kOrderListType_Takeout;
                [viewVC setValue:@"4" forKey:@"turnBackIndex"];
                [self.navigationController pushViewController:viewVC animated:YES];
                
            }];
            
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
        
        ///判断支付结果
        [self checkPayResultWithCode:payCode andPayResultInfo:payInfo andOrderForm:orderForm];
        
    };
    
    ///设置回调
    __weak QSAlixPayModel *weakOrderForm = orderForm;
    orderForm.alixpayCallBack = ^(NSString *payCode,NSString *payInfo) {
        
        ///判断支付结果
        [self checkPayResultWithCode:payCode andPayResultInfo:payInfo andOrderForm:weakOrderForm];
        
    };
    
    ///跳转到支付宝支付页面
    [[QSAlixPayManager sharedQSAlixPayManager] startAlixPay:orderForm];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///移除HUD
        [QSYCustomHUD hiddenOperationHUD];
        
    });
    
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
        
        [self showTip:self.view tipStr:@"交易成功" andCallBack:^{
            
            if (nil == orderForm) {
                
                ///进入订单列表页面
                QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
                viewVC.merchant_id = self.merchant_id;
                viewVC.orderListType = kOrderListType_Takeout;
                [viewVC setValue:@"4" forKey:@"turnBackIndex"];
                [self.navigationController pushViewController:viewVC animated:YES];
                return;
                
            }
            
            ///确认支付
            NSDictionary *commitDict = @{@"trade_no" : orderForm.orderNum,
                                         @"out_trade_no" : orderForm.billNum,
                                         @"status" : @"1"};
            
            [[QSAPIClientBase sharedClient] commitPay:commitDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
                
                ///进入订单列表页面
                QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
                viewVC.merchant_id = self.merchant_id;
                viewVC.orderListType = kOrderListType_Takeout;
                [viewVC setValue:@"4" forKey:@"turnBackIndex"];
                [self.navigationController pushViewController:viewVC animated:YES];
                
            }];
            
        }];
        
        return;
        
    }
    
    ///支付回调：正在处理中
    if (resultCode == 8000) {
        
        [self showTip:self.view tipStr:@"正在处理" andCallBack:^{
            
            ///进入订单列表页面
            QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
            viewVC.merchant_id = self.merchant_id;
            viewVC.orderListType = kOrderListType_Takeout;
            [viewVC setValue:@"4" forKey:@"turnBackIndex"];
            [self.navigationController pushViewController:viewVC animated:YES];
            
        }];
        
        return;
        
    }
    
    ///没有进行支付，直接点返回，或者发生错误后，点击返回
    if (resultCode == 6001) {
        
        [self showTip:self.view tipStr:@"支付失败" andCallBack:^{
            
            ///进入订单列表页面
            QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
            viewVC.merchant_id = self.merchant_id;
            viewVC.orderListType = kOrderListType_Takeout;
            [viewVC setValue:@"4" forKey:@"turnBackIndex"];
            [self.navigationController pushViewController:viewVC animated:YES];
            
        }];
        
        return;
        
    }
    
    ///6002---网络不可用
    if (resultCode == 6002) {
        
        [self showTip:self.view tipStr:@"交易失败" andCallBack:^{
            
            ///进入订单列表页面
            QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
            viewVC.merchant_id = self.merchant_id;
            viewVC.orderListType = kOrderListType_Takeout;
            [viewVC setValue:@"4" forKey:@"turnBackIndex"];
            [self.navigationController pushViewController:viewVC animated:YES];
            
        }];

        return;
        
    }
    
    ///4000---返回时报支付失败
    if (resultCode == 4000) {
        
        [self showTip:self.view tipStr:@"支付失败" andCallBack:^{
            
            ///进入订单列表页面
            QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
            viewVC.merchant_id = self.merchant_id;
            viewVC.orderListType = kOrderListType_Takeout;
            [viewVC setValue:@"4" forKey:@"turnBackIndex"];
            [self.navigationController pushViewController:viewVC animated:YES];
            
        }];
        
        return;
    }
    
}

#pragma mark - 返回列表有多少个区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.foodlistTableView) {
        
        return self.foodlistReturnData.data.count;
        
    } else {
        
        return self.storeCardListReturnData.data.count;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.foodlistTableView) {
        
        return 68;
        
    } else {
        
        return 44;
        
    }
}

#pragma mark - 返回每个菜品的图片及价格cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.foodlistTableView) {
        
        static NSString *identifier = @"Cell";
        QSRecommendFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSRecommendFoodListCell" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            
        }
        cell.cellType = kRecommendFoodType_TakeoutShow;
        cell.item = self.foodlistReturnData.data[indexPath.row];
        return cell;
        
    } else {
        
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            
        }
        QSStoreCardDetailData *info = self.storeCardListReturnData.data[indexPath.row];
        cell.textLabel.text = info.storeCardMsg[@"goods_name"];
        cell.detailTextLabel.text = info.limit_val;
        return cell;
        
    }

}

#pragma mark - 点击选择储值卡时：判断储值卡是否足额，足额则直接储值卡支付
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.storeCardTableView) {
        
        QSStoreCardDetailData *info = self.storeCardListReturnData.data[indexPath.row];
        
        //支付宝支付
        QSYOrderNormalFormModel *orderModel = [[QSYOrderNormalFormModel alloc] init];
        
        if ([info.limit_val floatValue] < [self.realPayPrice floatValue]) {
            
            ///储值卡不足额，需要在线支付部分金额
            orderModel.orderID = self.orderID;
            orderModel.formPayType = TAKEOUT_PREPAIDCARDPAY_PAYAGENT_COPT;
            orderModel.marchantID = self.merchant_id;
            orderModel.totalPrice = [NSString stringWithFormat:@"%.2f",[self.realPayPrice floatValue] - [info.limit_val floatValue]];
            orderModel.buyDate = [NSDate currentDateIntegerString];
            orderModel.userID = [UserManager sharedManager].userData.user_id;
            orderModel.payType = self.pay_type;
            orderModel.orderFormType = @"2";
            orderModel.userPhone = self.mobileTextField.text;
            orderModel.orderFormTitle = [NSString stringWithFormat:@"%@ 外卖订单",self.merchantIndexReturnData.data.merchant_name];
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (QSFoodDetailData *info in self.foodlist) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:info.goods_id forKey:@"goods_id"];
                [dict setValue:info.goods_name forKey:@"goods_name"];
                [dict setValue:[NSString stringWithFormat:@"%d",(int)self.foodlistReturnData.data.count] forKey:@"goods_num"];
                [dict setValue:info.goods_pice forKey:@"goods_price"];
                [dict setValue:info.goods_real_pice forKey:@"goods_sale_money"];
                [temp addObject:dict];
                
            }
            
            orderModel.goodsList = temp;
            
            ///保存优惠券信息
            if (self.couponData) {
                
                NSDictionary *couponDict = @{@"store_card_id" : self.couponData.coupon_id,
                                             @"store_card_name" : self.couponData.goods_name,
                                             @"store_card_value" : self.couponData.coup_price};
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
            
            commitOrder.payResultCallBack = ^(NSString *errorCode,NSString *errorInfo){
                
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
                                              @"use_val" : self.realPayPrice,
                                              @"limit_val" : [NSString stringWithFormat:@"%.2f",([info.limit_val floatValue] - [self.realPayPrice floatValue])],
                                              @"name" : [info.storeCardMsg valueForKey:@"goods_name"]};
                        
            NSDictionary *paramsDict = @{@"indent_id" : self.orderID,
                                         @"online_money" : @"0",
                                         @"pay_type" : self.pay_type,
                                         @"indent_type" : @"2",
                                         @"store_card_list" : @[prepaidCardDict],
                                         @"store_card_money" : self.realPayPrice,
                                         @"limit_val" : info.limit_val,
                                         @"merchant_id" : self.merchantIndexReturnData.data.merchant_id,
                                         @"merchant_name" : self.merchantIndexReturnData.data.merchant_name,
                                         @"food_count" : [NSString stringWithFormat:@"%d",(int)self.foodlist.count]};
            
            ///隐藏选择窗口
            [ASDepthModalViewController dismiss];
                        
            ///直接使用储值卡支付，进入支付确认页面
            QSPrepaidCarPayViewController *prepaidCommitVC = [[QSPrepaidCarPayViewController alloc] initWithPrepaidCardPayParams:paramsDict];
            [self.navigationController pushViewController:prepaidCommitVC animated:YES];
            
        }
    
    }
    
}

#pragma mark - 进入框代理
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _firstResponser = textField;
    if (textField == self.addressTextField || textField == self.contactTextField || textField == self.mobileTextField) {
    }
    else if (textField == self.memoView){

    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.addressTextField) {
        
        [self.contactTextField becomeFirstResponder];
        
    } else if (textField == self.contactTextField){
        
        [self.mobileTextField becomeFirstResponder];
        
    } else if (textField == self.mobileTextField){
        
        [self.mobileTextField resignFirstResponder];
        
    }
    
    return YES;
    
}

#pragma mark - 滚动时重置键盘第一响应
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_firstResponser resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [_firstResponser resignFirstResponder];

}

@end
