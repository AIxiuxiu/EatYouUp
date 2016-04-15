//
//  QSPrepaidCarPayViewController.m
//  Eating
//
//  Created by ysmeng on 15/1/6.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import "QSPrepaidCarPayViewController.h"
#import "QSAPIClientBase+Takeout.h"
#import "NSString+Name.h"
#import "QSBlockActionButton.h"
#import "QSTakeoutOrderListViewController.h"

@interface QSPrepaidCarPayViewController ()

@property (nonatomic,retain) NSMutableDictionary *prepaidCarPayParams;//!<储值卡支付时的参数字典

@end

@implementation QSPrepaidCarPayViewController

/**
 *  @author     yangshengmeng, 15-01-06 17:01:45
 *
 *  @brief      根据储值卡支付的参数，初始化确认支付页面
 *
 *  @param dict 参数字典
 *
 *  @return     返回储值卡支付确认页面
 *
 *  @since      2.0
 */
#pragma mark - 按给定的储值卡支付参数字典初始化
- (instancetype)initWithPrepaidCardPayParams:(NSDictionary *)dict
{

    if (self = [super init]) {
        
        self.prepaidCarPayParams = [dict mutableCopy];
        
    }
    
    return self;

}

#pragma mark - 搭建UI
///导航栏：添加导航栏标题
- (void)createNavigationBar
{

    [super createNavigationBar];
    
    [self setNavigationBarMiddleTitle:@"订单支付"];

}

///主展示信息：添加支付说明信息
- (void)createMainShowView
{
    
    [super createMainShowView];
    
    ///商户说明
    UITextField *merchantInfoField = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, 90.0f, DEFAULT_MAX_WIDTH, 44.0f)];
    merchantInfoField.borderStyle = UITextBorderStyleRoundedRect;
    merchantInfoField.userInteractionEnabled = NO;
    merchantInfoField.font = [UIFont systemFontOfSize:14.0f];
    merchantInfoField.textColor = kBaseGrayColor;
    merchantInfoField.text= [self.prepaidCarPayParams valueForKey:@"merchant_name"];
    [self.view addSubview:merchantInfoField];
    
    ///外卖一共有几份
    NSString *foodCount = [NSString stringWithFormat:@"%@份外卖",[self.prepaidCarPayParams valueForKey:@"food_count"]];
    CGFloat width = [foodCount calculateStringHeightByFixedHeight:44.0f andFontSize:14.0f] + 8.0f;
    UILabel *deliveryCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 44.0f)];
    deliveryCountLabel.text = foodCount;
    deliveryCountLabel.textColor = kBaseGrayColor;
    deliveryCountLabel.textAlignment = NSTextAlignmentCenter;
    deliveryCountLabel.font = [UIFont systemFontOfSize:14.0f];
    merchantInfoField.rightViewMode = UITextFieldViewModeAlways;
    merchantInfoField.rightView = deliveryCountLabel;
    
    ///总价
    UITextField *totalPriceField = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, merchantInfoField.frame.origin.y+merchantInfoField.frame.size.height+8.0f, DEFAULT_MAX_WIDTH, 44.0f)];
    totalPriceField.borderStyle = UITextBorderStyleRoundedRect;
    totalPriceField.userInteractionEnabled = NO;
    totalPriceField.font = [UIFont systemFontOfSize:14.0f];
    totalPriceField.textColor = kBaseGrayColor;
    totalPriceField.text= @"总价：";
    [self.view addSubview:totalPriceField];
    
    ///总价
    NSString *totalPrice = [NSString stringWithFormat:@"￥%@",[self.prepaidCarPayParams valueForKey:@"store_card_money"]];
    CGFloat widthTotal = [totalPrice calculateStringHeightByFixedHeight:44.0f andFontSize:14.0f] + 8.0f;
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, widthTotal, 44.0f)];
    totalPriceLabel.text = totalPrice;
    totalPriceLabel.textColor = kBaseOrangeColor;
    totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    totalPriceLabel.font = [UIFont systemFontOfSize:14.0f];
    totalPriceField.rightViewMode = UITextFieldViewModeAlways;
    totalPriceField.rightView = totalPriceLabel;
    
    ///商户储值卡信息
    UITextField *prepaidCardInfoField = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, totalPriceField.frame.origin.y+totalPriceField.frame.size.height+8.0f, DEFAULT_MAX_WIDTH, 44.0f)];
    prepaidCardInfoField.borderStyle = UITextBorderStyleRoundedRect;
    prepaidCardInfoField.userInteractionEnabled = NO;
    prepaidCardInfoField.font = [UIFont systemFontOfSize:14.0f];
    prepaidCardInfoField.textColor = kBaseGrayColor;
    prepaidCardInfoField.text= [NSString stringWithFormat:@"%@(￥%@)",[((NSArray *)([self.prepaidCarPayParams valueForKey:@"store_card_list"]))[0] valueForKey:@"name"],[self.prepaidCarPayParams valueForKey:@"limit_val"]];
    [self.view addSubview:prepaidCardInfoField];
    
    ///储值卡剩余金额
    NSString *leftPrice = [NSString stringWithFormat:@"剩余￥%@",[((NSArray *)([self.prepaidCarPayParams valueForKey:@"store_card_list"]))[0] valueForKey:@"limit_val"]];
    CGFloat widthLeft = [leftPrice calculateStringHeightByFixedHeight:44.0f andFontSize:14.0f] + 8.0f;
    UILabel *leftPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, widthLeft, 44.0f)];
    leftPriceLabel.text = leftPrice;
    leftPriceLabel.textColor = kBaseGrayColor;
    leftPriceLabel.textAlignment = NSTextAlignmentCenter;
    leftPriceLabel.font = [UIFont systemFontOfSize:14.0f];
    prepaidCardInfoField.rightViewMode = UITextFieldViewModeAlways;
    prepaidCardInfoField.rightView = leftPriceLabel;
    
    ///提交支付按钮
    UIButton *commitButton = [UIButton createBlockActionButton:CGRectMake(MARGIN_LEFT_RIGHT, prepaidCardInfoField.frame.origin.y+prepaidCardInfoField.frame.size.height+8.0f, DEFAULT_MAX_WIDTH, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///暂存商户ID
        NSString *merchantID = [self.prepaidCarPayParams valueForKey:@"merchant_id"];
        
        ///清除非必要参数
        [self.prepaidCarPayParams removeObjectForKey:@"limit_val"];
        [self.prepaidCarPayParams removeObjectForKey:@"merchant_id"];
        [self.prepaidCarPayParams removeObjectForKey:@"merchant_name"];
        [self.prepaidCarPayParams removeObjectForKey:@"food_count"];
        
        /**
         *"indent_id" = 215;
         "indent_type" = 2;
         "online_money" = 0;
         "pay_type" = 3;
         "store_card_list" =     (
         {
         "limit_val" = "942.00";
         name = "\U58f0\U54e5\U50a8\U503c\U5361";
         "store_id" = 9260;
         "use_val" = "58.00";
         }
         );
         "store_card_money" = "58.00";
         }
         */
        
        ///进行支付
        [[QSAPIClientBase sharedClient] prepaidCardPay:self.prepaidCarPayParams andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
            
            ///判断支付结果
            if (flag) {
                
                [self showTip:self.view tipStr:@"交易成功" andCallBack:^(){
                    
                    ///进入订单列表页面
                    QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
                    viewVC.merchant_id = merchantID;
                    viewVC.orderListType = kOrderListType_Takeout;
                    [viewVC setValue:@"5" forKey:@"turnBackIndex"];
                    [self.navigationController pushViewController:viewVC animated:YES];
                
                }];
                
            } else {
            
                [self showTip:self.view tipStr:@"交易失败" andCallBack:^(){
                
                    ///进入订单列表页面
                    QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
                    viewVC.merchant_id = merchantID;
                    viewVC.orderListType = kOrderListType_Takeout;
                    [viewVC setValue:@"5" forKey:@"turnBackIndex"];
                    [self.navigationController pushViewController:viewVC animated:YES];
                
                }];
            
            }
            
        }];
        
    }];
    commitButton.backgroundColor = kBaseGreenColor;
    [commitButton setTitle:@"提交支付" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:kBaseGreenColor forState:UIControlStateHighlighted];
    commitButton.layer.cornerRadius = 4.0f;
    [self.view addSubview:commitButton];

}

@end
