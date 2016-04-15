//
//  QSCommitOrderViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSCommitOrderViewController.h"
#import "QSTakeoutCouponListViewController.h"
#import "QSLeftTitleBlockButton.h"
#import "QSPaymentModeView.h"
#import "QSImageView.h"
#import "QSPayFailViewController.h"
#import "QSPayFailHUD.h"
#import "AppDelegate.h"
#import "QSPaySuccessViewController.h"
#import "QSYOrderNormalFormModel.h"
#import "QSYCustomHUD.h"
#import "QSAPIClientBase+AlixPay.h"
#import "QSMyTradeListViewController.h"
#import "QSAPIModel+Coupon.h"
#import "QSMyTradeListViewController.h"
#import "QSAPIClientBase+Takeout.h"

#import <objc/runtime.h>

//输入框tag标记
#define TAG_COMMITORDER_INPUTFIELD_ROOT 300

//关联
//static char ActualAndCouponAssociationKey;
@interface QSCommitOrderViewController ()<UITextFieldDelegate>{
    
    QSPAYMENTMODE_TYPE _currentPaymentMode; //!<当前支付方式
    QSYOrderNormalFormModel *_orderForm;    //!<订单模型
    
    NSString *_totalPrice;//!<总价，本页面进行优惠券选择后的总价
    NSString *_couponID;//!<选择使用的优惠券ID
    
    NSString *_outTradeID;//!<订单ID
    
}

@property (nonatomic,retain) QSYOrderNormalFormModel *orderForm;

@end

@implementation QSCommitOrderViewController


#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 14-12-12 23:12:01
 *
 *  @brief          按给定的基本订单数据创建支付订单页面，并再次细化订单信息
 *
 *  @param model    基本订单信息
 *
 *  @return         返回强化订单信息页面
 *
 *  @since          2.0
 */
- (instancetype)initWithOrderModel:(QSYOrderNormalFormModel *)model
{
    if (self = [super init]) {
        
        ///保存支付方式
        _currentPaymentMode = TAOBAO_QSPT;
        
        ///保存订单模型
        self.orderForm = model;
        
    }
    
    return self;
}

//**********************************
//             UI搭建
//**********************************
#pragma mark - UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"支付订单"];
}

//添加订单信息框
- (void)createMainShowView
{
    [super createMainShowView];
    
    //起始y坐标
    CGFloat ypoint = 36.0f + 64.0f;
    
    NSArray *placeHoldArrar = @[@"店名：",@"总价：",@"不使用优惠卷",@"还需支付：",@"(使用支付宝手机网页支付)"];
    for (int i = 0; i < 5; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypoint, DeviceWidth-20.0f, 44.0f)];
        textField.placeholder = placeHoldArrar[i];
        
        ///字体颜色
        textField.textColor = kBaseGrayColor;
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.userInteractionEnabled = NO;
        
        ///显示订单名
        if (i == 0) {
            
            textField.text = self.orderForm.orderFormTitle;
            
        }
        
        //如果是选择优惠卷，则可以交互
        if (i == 2 || i == 4) {
            textField.userInteractionEnabled = NO;
            textField.delegate = self;
        }
        
        //如果是支付方式，字体小一号，并显示支付方式图标
        if (i == 4) {
            //字体小一号
            textField.font = [UIFont systemFontOfSize:12.0f];
            
            //支付方式
            QSImageView *paymentMode = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 16.0f)];
            paymentMode.image = [UIImage imageNamed:@"prepaidcard_order_paymentmode_taobao"];
            
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = paymentMode;
            
            ///是否支持
            QSImageView *supportStatus = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 26.0f, 13.0f)];
            supportStatus.image = [UIImage imageNamed:@"prepaidcard_order_paymentmode_choice"];
            
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.rightView = supportStatus;
            
        }
        
        ///总价
        if (i == 1) {
            //显示总价
            UILabel *sumPrice = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, textField.frame.size.height)];
            sumPrice.font = [UIFont systemFontOfSize:16.0f];
            sumPrice.textColor = kBaseGrayColor;
            sumPrice.textAlignment = NSTextAlignmentCenter;
            sumPrice.text = [NSString stringWithFormat:@"￥%@", self.orderForm.totalPrice ];
            
            textField.rightViewMode = UITextFieldViewModeAlways;
            [textField setRightView:sumPrice];
        }
        
        ///使用优惠卷
        if (i == 2) {
            
            ///显示优惠券信息
            NSString *couponNameString = [self.orderForm.couponList[0] valueForKey:@"store_card_name"];
            if (couponNameString) {
                
                textField.text = couponNameString;
                
            }
            
            ///是否使用优惠卷
            UIButton *sumPrice = [UIButton createLeftTitleButton:CGRectMake(0.0f, 0.0f, 120.0f, 20.0f) andStyle:nil andCallBack:^(UIButton *button) {
                
                [self gotoCouponChoice:textField];
                
            }];
            sumPrice.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [sumPrice setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
            [sumPrice setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
            sumPrice.titleLabel.textAlignment = NSTextAlignmentCenter;
            [sumPrice setImage:[UIImage imageNamed:@"prepaidcard_order_coupon"] forState:UIControlStateNormal];
            
            textField.rightViewMode = UITextFieldViewModeAlways;
            [textField setRightView:sumPrice];
            
        }
        
        //实际支付额
        if (i == 3) {
            UILabel *actualPay = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, textField.frame.size.height)];
            actualPay.font = [UIFont systemFontOfSize:16.0f];
            actualPay.textColor = kBaseOrangeColor;
            actualPay.textAlignment = NSTextAlignmentCenter;
            actualPay.text = [NSString stringWithFormat:@"￥%@", self.orderForm.totalPrice ];
            
            textField.rightViewMode = UITextFieldViewModeAlways;
            [textField setRightView:actualPay];
        }
        
        //保存tag
        textField.tag = i + TAG_COMMITORDER_INPUTFIELD_ROOT;
        
        //圆角风格
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        [self.view addSubview:textField];
        
        //重置ypoint
        ypoint += (44.0f + 5.0f);
    }
    
    //支付按钮
    UIButton *payButton = [UIButton createBlockActionButton:CGRectMake(10.0f, ypoint, DeviceWidth-20.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        //进入支付流程
        [self preparePayAction];
        
    }];
    [payButton setTitle:@"提交支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    payButton.layer.cornerRadius = 6.0f;
    payButton.backgroundColor = kBaseGreenColor;
    [self.view addSubview:payButton];
}

#pragma mark - 更改支付方式/使用优惠卷
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //如果点击是否使用优惠卷，则进入优惠郑选择页面
    if (textField.tag == 2 + TAG_COMMITORDER_INPUTFIELD_ROOT) {
        [self gotoCouponChoice:textField];
    }
    
    //如果是支付方式点击，则进入支付方式选择窗口
    if (textField.tag == 4 + TAG_COMMITORDER_INPUTFIELD_ROOT) {
        [self gotoPaymentStyleChoice:textField];
    }
    
    return NO;
}

#pragma mark - 进入优惠卷选择页面
- (void)gotoCouponChoice:(UITextField *)textField
{
    //进入优惠卷选择页面
    QSTakeoutCouponListViewController *showCoupon = [[QSTakeoutCouponListViewController alloc] init];
    
    ///保存选择优惠券后的回调
    showCoupon.onCouponHandler = ^(BOOL flag, QSCouponDetailData *model){
        if (flag) {
            
            textField.placeholder = @"已使用优惠券";
            UIButton *button = (UIButton *)textField.rightView;
            [button setTitle:[NSString stringWithFormat:@"抵消￥%@",model.coup_price] forState:UIControlStateNormal];
            
            ///更新总价
            UITextField *sumPrice = (UITextField *)[[textField superview] viewWithTag:textField.tag+1];
            UILabel *sumLabel = (UILabel *)sumPrice.rightView;
            CGFloat originalSumPrice = [[sumLabel.text substringFromIndex:1] floatValue];
            sumLabel.text = [NSString stringWithFormat:@"￥%.2f",(originalSumPrice - [model.coup_price floatValue])];
            
            ///保存真实价格
            _totalPrice = [[sumLabel.text substringFromIndex:1] copy];
            _couponID = [model.coupon_id copy];
            
        } else {
            
            textField.rightViewMode = UITextFieldViewModeNever;
            
            ///重置优惠券信息
            _totalPrice = nil;
            _couponID = nil;
            
        }
    };
    
    [self.navigationController pushViewController:showCoupon animated:YES];
}

#pragma mark - 进入支付方式页面
- (void)gotoPaymentStyleChoice:(UITextField *)textField
{
    //QSPaymentModeView
    [QSPaymentModeView showPaymentTypeChoice:self.view andType:_currentPaymentMode andCallBack:^(NSString *typeName, QSPAYMENTMODE_TYPE payType) {
        
        //如若未选择类型，则直接返回
        if (payType == DEFAULT_QSPT) {
            return;
        }
        
        //有效类型更新
        _currentPaymentMode = payType;
        UIImageView *paymentTypeModeImageView = (UIImageView *)textField.rightView;
        paymentTypeModeImageView.image = [UIImage imageNamed:typeName];
        
    }];
}

/**
 *  @author yangshengmeng, 14-12-14 13:12:10
 *
 *  @brief  支付处理过程：先弹出HUD屏蔽用户交互，然后封装数据模型，第三请求服务端订单信息，返回成功后再跳转到支堆宝
 *
 *  @since  2.0
 */
#pragma mark - 开始支付处理过程
- (void)preparePayAction
{
    
    ///显示HUD，防止用户点击事件发生意外crash
    [QSYCustomHUD showOperationHUD:self.view];
    
    ///封装参数
    QSYOrderNormalFormModel *orderForm = [self packageOrderForm];
    
    if (nil == orderForm) {
        
        ///移除HUD
        [QSYCustomHUD hiddenOperationHUD];
        
        ///显示提示信息
        [self showAlertMessageWithTime:1.0f andMessage:@"网络不给力……请稍后" andCallBack:^(CGFloat showTime) {
            
        }];
        
        return;
    }
    
    ///订单参数
    NSDictionary *paramsDict;
    
    ///判断是否是已有订单支付
    if (orderForm.orderID) {
        
        switch (orderForm.formPayType) {
                
                ///储值卡支付失败后，再次支付时的参数
            case BUY_PREPAIDCARD_PAYAGENT_COPT:
                
                paramsDict = [orderForm getOldOrderFormPostParamsDictionary];
                
                break;
                
                ///外卖：储值卡和在线支付：再支付过程
            case TAKEOUT_ONLINEPAY_PAYAGENT_COPT:                
                
            case TAKEOUT_PREPAIDCARDPAY_PAYAGENT_COPT:
                
                paramsDict = [orderForm getOldOnlinePayAndPrecardPayOrderFormPostParams];
                
                break;
                
            default:
                
                paramsDict = [orderForm getOldOrderFormPostParamsDictionary];
                
                break;
        }
        
    } else {
        
        ///储值卡购买新订单支付参数
        paramsDict = [orderForm getOrderFormPostParamsDictionary];
        self.orderForm.formPayType = DEFAULT_ORDERPAY_COPT;
    
    }
    
    ///请求服务端的数字签名订单
    [[QSAPIClientBase sharedClient] getRSAOrderFormWithModel:paramsDict andCallBack:^(BOOL resultFlag, QSAlixPayModel *result, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否成功
        if (resultFlag) {
            
            ///保存订单号
            _outTradeID = [result.orderModel.out_trade_no copy];
            
            ///修改类型
            if (self.orderForm.formPayType == DEFAULT_ORDERPAY_COPT) {
                
                ///保存订单号
                self.orderForm.orderID = result.orderFormID;
                self.orderForm.formPayType = BUY_PREPAIDCARD_PAYAGENT_COPT;
                
            }
            
            ///进入支付
            [self gotoAlixPayWithOrderForm:result];
            
            return;
            
        }
        
        ///支付失败
        [self showAlertMessageWithTime:1.0f andMessage:@"网络不给力……请稍等" andCallBack:^(CGFloat showTime) {
            
        }];
        
        ///移除HUD
        [QSYCustomHUD hiddenOperationHUD];
        
    }];
    
}

- (void)gotoAlixPayWithOrderForm:(QSAlixPayModel *)orderForm
{
    
    ///保存回调：当支付宝回跳到当前应用时，让payHUD移除
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentControllerCallBack = ^(NSString *payCode,NSString *payInfo){
        
        ///如果是外卖-储值卡支付-储值卡不足以支付时，支付回调到给定的回调block
        if ((TAKEOUT_PREPAIDCARDPAY_PAYAGENT_COPT == self.orderForm.formPayType) && self.payResultCallBack) {
            
            ///确认支付
            NSDictionary *commitDict = @{@"trade_no" : orderForm.orderNum,
                                         @"out_trade_no" : orderForm.billNum,
                                         @"status" : @"1"};
            
            [[QSAPIClientBase sharedClient] commitPay:commitDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
                
                ///移除HUD
                [QSYCustomHUD hiddenOperationHUD];
                
                ///进入订单列表页面
                self.payResultCallBack(payCode,payInfo);
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }];
            
            return;
            
        }
        
        ///移除HUD
        [QSYCustomHUD hiddenOperationHUD];
        
        ///判断支付结果
        [self checkPayResultWithCode:payCode andPayResultInfo:payInfo];
        
    };
    
    ///设置回调
    __weak QSAlixPayModel *weakOrderForm = orderForm;
    orderForm.alixpayCallBack = ^(NSString *payCode,NSString *payInfo) {
        
        ///如果是外卖-储值卡支付-储值卡不足以支付时，支付回调到给定的回调block
        if ((TAKEOUT_PREPAIDCARDPAY_PAYAGENT_COPT == self.orderForm.formPayType) && self.payResultCallBack) {
            
            ///确认支付
            NSDictionary *commitDict = @{@"trade_no" : weakOrderForm.orderNum,
                                         @"out_trade_no" : weakOrderForm.billNum,
                                         @"status" : @"1"};
            
            [[QSAPIClientBase sharedClient] commitPay:commitDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
                
                ///移除HUD
                [QSYCustomHUD hiddenOperationHUD];
                
                ///进入订单列表页面
                self.payResultCallBack(payCode,payInfo);
                [self.navigationController popViewControllerAnimated:NO];
                
            }];
            
            return;
            
        }
        
        ///移除HUD
        [QSYCustomHUD hiddenOperationHUD];
        
        ///判断支付结果
        [self checkPayResultWithCode:payCode andPayResultInfo:payInfo];
        
    };
    
    //跳转到支付宝支付页面
    [[QSAlixPayManager sharedQSAlixPayManager] startAlixPay:orderForm];
    
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
- (void)checkPayResultWithCode:(NSString *)payCode andPayResultInfo:(NSString *)payInfo
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
        
        ///进入支付成功页面
        [self gotoPaySuccessController];
        
        ///回调服务端
        NSDictionary *tempDict = @{@"out_trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"status" : @"1"};
        [[QSAPIClientBase sharedClient] rebackAlixPayResultToServer:tempDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
            
            if (flag) {
                
                NSLog(@"==============================================");
                NSLog(@"支付成功已回调到服务端  %@",payInfo);
                NSLog(@"==============================================");
                return;
            }
            
            NSLog(@"==============================================");
            NSLog(@"支付成功未回调到服务端  %@",payInfo);
            NSLog(@"==============================================");
            
        }];
        
        return;
        
    }
    
    ///支付回调：正在处理中
    if (resultCode == 8000) {
        
        ///进入我的交易页面
        QSMyTradeListViewController *myTradeListVC = [[QSMyTradeListViewController alloc] init];
        [self.navigationController pushViewController:myTradeListVC animated:YES];
        
        ///回调服务端
        NSDictionary *tempDict = @{@"out_trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"status" : @"2"};
        [[QSAPIClientBase sharedClient] rebackAlixPayResultToServer:tempDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
            
            if (flag) {
                
                NSLog(@"==============================================");
                NSLog(@"请求超时，已回调服务端  %@",payInfo);
                NSLog(@"==============================================");
                return;
            }
            
            NSLog(@"==============================================");
            NSLog(@"请求超时，未回调服务端%@",payInfo);
            NSLog(@"==============================================");
            
        }];
        
        return;
        
    }
    
    ///没有进行支付，直接点返回，或者发生错误后，点击返回
    if (resultCode == 6001) {
        
        [self showAlertMessageWithTime:1.5f andMessage:[NSString stringWithFormat:@"%@  信息：%@", payCode,payInfo] andCallBack:^(CGFloat showTime) {
            
            ///进入支付失败页面
            [self gotoPayFailController];
            
        }];
        
        ///回调服务端
        NSDictionary *tempDict = @{@"out_trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"status" : @"4"};
        [[QSAPIClientBase sharedClient] rebackAlixPayResultToServer:tempDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
            
            if (flag) {
                
                NSLog(@"==============================================");
                NSLog(@"支付失败，已回调到服务端  %@",payInfo);
                NSLog(@"==============================================");
                return;
            }
            
            NSLog(@"==============================================");
            NSLog(@"支付失败，未回调到服务端  %@",payInfo);
            NSLog(@"==============================================");
            
        }];
        
        return;
        
    }
    
    ///6002---网络不可用
    if (resultCode == 6002) {
        
        [self showAlertMessageWithTime:1.0f andMessage:@"网络不给力……请稍后" andCallBack:^(CGFloat showTime) {
            
            
            
        }];
        
        ///回调服务端
        NSDictionary *tempDict = @{@"out_trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"status" : @"4"};
        [[QSAPIClientBase sharedClient] rebackAlixPayResultToServer:tempDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
            
            if (flag) {
                
                NSLog(@"==============================================");
                NSLog(@"支付失败，已回调到服务端  %@",payInfo);
                NSLog(@"==============================================");
                return;
            }
            
            NSLog(@"==============================================");
            NSLog(@"支付失败，未回调到服务端  %@",payInfo);
            NSLog(@"==============================================");
            
        }];
        
        return;
        
    }
    
    ///4000---返回时报支付失败
    if (resultCode == 4000) {
        
        [self showAlertMessageWithTime:1.0f andMessage:[NSString stringWithFormat:@"%@  信息：%@", payCode,payInfo] andCallBack:^(CGFloat showTime) {
            
            ///进入支付失败页面
            [self gotoPayFailController];
            
        }];
        
        ///回调服务端
        NSDictionary *tempDict = @{@"out_trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"trade_no" : (_outTradeID ? _outTradeID : self.orderForm.orderID),@"status" : @"4"};
        [[QSAPIClientBase sharedClient] rebackAlixPayResultToServer:tempDict andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
            
            if (flag) {
                
                NSLog(@"==============================================");
                NSLog(@"支付失败，已回调到服务端  %@",payInfo);
                NSLog(@"==============================================");
                return;
            }
            
            NSLog(@"==============================================");
            NSLog(@"支付失败，未回调到服务端  %@",payInfo);
            NSLog(@"==============================================");
            
        }];
        
        return;
    }

}

/**
 *  @author yangshengmeng, 14-12-14 13:12:44
 *
 *  @brief  更新订单信息
 *
 *  @since  2.0
 */
#pragma mark - 更新封装订单信息
- (QSYOrderNormalFormModel *)packageOrderForm
{
    
    ///更新订单：主要是添加优惠券使用情况
    if (_couponID) {
        
        self.orderForm.totalPrice = _totalPrice;
        [self.orderForm.couponList addObject:@{@"coupon_id" : _couponID}];
        
    }
    
    return self.orderForm;
    
}

#pragma mark - 直接返回时，删除订单
- (void)viewWillDisappear:(BOOL)animated
{
    //删除订单
    
    [super viewWillDisappear:animated];
}

#pragma mark - 进入支付失败页面
- (void)gotoPayFailController
{
    QSPayFailViewController *payFail = [[QSPayFailViewController alloc] init];
    payFail.turnBackAninmationFlag = NO;
    
    ///当支付失败后，点击返回时的回调
    payFail.turnBackBlock = ^(NSString *tipsInfo,int intParams,UIViewController *vc,NSDictionary *dictParams){
        
        ///进入我的交易页面，同时重置我的页面返回时的VC下标差
        QSMyTradeListViewController *myTrade = [[QSMyTradeListViewController alloc] init];
        [myTrade setValue:@"5" forKey:@"comeBackVCIndext"];
        [self.navigationController pushViewController:myTrade animated:YES];
        
    };
    
    [self.navigationController pushViewController:payFail animated:NO];
}

#pragma mark - 进入支付成功页面
- (void)gotoPaySuccessController
{
    QSPaySuccessViewController *paySuccess = [[QSPaySuccessViewController alloc] init];
    [self.navigationController pushViewController:paySuccess animated:NO];
}

@end
