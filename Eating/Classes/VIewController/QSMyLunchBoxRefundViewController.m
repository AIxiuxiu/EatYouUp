//
//  QSMyLunchBoxRefundViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyLunchBoxRefundViewController.h"
#import "QSResetRightViewFrameTextField.h"
#import "QSImageView.h"
#import "QSRefundReasonView.h"
#import "QSBlockActionButton.h"
#import "QSAPIClientBase+CouponDetail.h"
#import "QSMyTradeListViewController.h"

@interface QSMyLunchBoxRefundViewController ()

@end

@implementation QSMyLunchBoxRefundViewController

//***********************************
//             UI搭建
//***********************************
#pragma mark - UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"申请退款"];
}

- (void)createMainShowView
{
    [super createMainShowView];
    
    //储值卡退款基本信息底view
    UIScrollView *infoRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, DeviceHeight-64.0f)];
    
    //去除滚动条
    infoRootView.showsHorizontalScrollIndicator = NO;
    infoRootView.showsVerticalScrollIndicator = NO;
    
    //去除背景颜色
    infoRootView.backgroundColor = [UIColor clearColor];
    
    //添加基本信息显示视图
    [self createPrepaidRefundInfoView:infoRootView];
    
    [self.view addSubview:infoRootView];
}

//储值卡基本信息显示视图
- (void)createPrepaidRefundInfoView:(UIScrollView *)scrollView
{
    //记录当前布局高度
    CGFloat ypiont = 30.0f;
    
    ///获取退款信息
    __block NSDictionary *refundDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"prepaidCard_refund_info"];
    
    //卷名
    NSString *orderDes = [refundDataDict valueForKey:@"order_des"];
    UITextField *couponName = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypiont, scrollView.frame.size.width-20.0f, 44.0f)];
    couponName.text = orderDes ? orderDes : @"广州酒家储值卡(￥500.00)";
    couponName.borderStyle = UITextBorderStyleRoundedRect;
    couponName.font = [UIFont systemFontOfSize:14.0f];
    couponName.textColor = kBaseGrayColor;
    couponName.userInteractionEnabled = NO;
    [scrollView addSubview:couponName];
    ypiont += 49.0f;
    
    //返回数量
    NSString *refundCount = [refundDataDict valueForKey:@"refund_count"];
    QSResetRightViewFrameTextField *refundCounponCount = [[QSResetRightViewFrameTextField alloc] initWithFrame:CGRectMake(10.0f, ypiont, scrollView.frame.size.width-20.0f, 44.0f)];
    refundCounponCount.text = @"退回数量";
    refundCounponCount.borderStyle = UITextBorderStyleRoundedRect;
    refundCounponCount.font = [UIFont systemFontOfSize:14.0f];
    refundCounponCount.textColor = kBaseGrayColor;
    refundCounponCount.userInteractionEnabled = NO;
    [scrollView addSubview:refundCounponCount];
    ypiont += 49.0f;
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 44.0f)];
    countLabel.text = refundCount ? [NSString stringWithFormat:@"%@张",refundCount] : @"1张";
    countLabel.font = [UIFont systemFontOfSize:14.0f];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.textColor = kBaseGrayColor;
    refundCounponCount.rightViewMode = UITextFieldViewModeAlways;
    refundCounponCount.rightView = countLabel;
    
    //tips
    QSResetRightViewFrameTextField *tipsField = [[QSResetRightViewFrameTextField alloc] initWithFrame:CGRectMake(10.0f, ypiont, scrollView.frame.size.width-20.0f, 44.0f)];
    tipsField.text = @"无抵用券";
    tipsField.borderStyle = UITextBorderStyleRoundedRect;
    tipsField.font = [UIFont systemFontOfSize:14.0f];
    tipsField.textColor = kBaseGrayColor;
    tipsField.userInteractionEnabled = NO;
    [scrollView addSubview:tipsField];
    ypiont += 49.0f;
    
    UILabel *refundValue = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 44.0f)];
    refundValue.text = @"￥360.00";
    refundValue.font = [UIFont systemFontOfSize:16.0f];
    refundValue.textAlignment = NSTextAlignmentRight;
    refundValue.textColor = kBaseOrangeColor;
    tipsField.rightViewMode = UITextFieldViewModeNever;
    tipsField.rightView = refundValue;
    
    //退款方式
    ypiont += 25.0f;
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, ypiont, scrollView.frame.size.width-20.0f, 0.5f)];
    lineLabel.alpha = 0.5f;
    lineLabel.backgroundColor = kBaseLightGrayColor;
    [scrollView addSubview:lineLabel];
    
    UILabel *refundStyelTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(scrollView.frame.size.width/2.0f-35.0f, ypiont-10.0f, 70.0f, 20.0f)];
    refundStyelTipsLabel.text = @"退款方式";
    refundStyelTipsLabel.backgroundColor = kBaseBackgroundColor;
    refundStyelTipsLabel.textAlignment = NSTextAlignmentCenter;
    refundStyelTipsLabel.textColor = kBaseGrayColor;
    refundStyelTipsLabel.font = [UIFont systemFontOfSize:14.0f];
    [scrollView addSubview:refundStyelTipsLabel];
    ypiont += 15.0f;
    
    //方式选择
    UITextField *refundStyleChoice = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypiont, scrollView.frame.size.width-20.0f, 44.0f)];
    refundStyleChoice.text = @"3-10个工作日完成，暂不收手续费";
    refundStyleChoice.borderStyle = UITextBorderStyleRoundedRect;
    refundStyleChoice.font = [UIFont systemFontOfSize:12.0f];
    refundStyleChoice.textColor = kBaseGrayColor;
    refundStyleChoice.userInteractionEnabled = NO;
    [scrollView addSubview:refundStyleChoice];
    ypiont += (49.0f + 25.0f);
    
    UILabel *refundStyleChoiceTips = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 44.0f)];
    refundStyleChoiceTips.text = @"原路退回";
    refundStyleChoiceTips.textAlignment = NSTextAlignmentRight;
    refundStyleChoiceTips.textColor = kBaseGrayColor;
    refundStyleChoiceTips.font = [UIFont systemFontOfSize:14.0f];
    refundStyleChoice.leftViewMode = UITextFieldViewModeAlways;
    refundStyleChoice.leftView = refundStyleChoiceTips;
    
    QSImageView *supportStatus = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 26.0f, 13.0f)];
    supportStatus.image = [UIImage imageNamed:@"prepaidcard_order_paymentmode_choice"];
    
    refundStyleChoice.rightViewMode = UITextFieldViewModeAlways;
    refundStyleChoice.rightView = supportStatus;
    
    //退款原因
    UILabel *lineReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, ypiont, scrollView.frame.size.width-20.0f, 0.5f)];
    lineReasonLabel.alpha = 0.5f;
    lineReasonLabel.backgroundColor = kBaseLightGrayColor;
    [scrollView addSubview:lineReasonLabel];
    
    UILabel *refundReasonTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(scrollView.frame.size.width/2.0f-35.0f, ypiont-10.0f, 70.0f, 20.0f)];
    refundReasonTipsLabel.text = @"退款原因";
    refundReasonTipsLabel.backgroundColor = kBaseBackgroundColor;
    refundReasonTipsLabel.textAlignment = NSTextAlignmentCenter;
    refundReasonTipsLabel.textColor = kBaseGrayColor;
    refundReasonTipsLabel.font = [UIFont systemFontOfSize:14.0f];
    [scrollView addSubview:refundReasonTipsLabel];
    ypiont += 15.0f;
    
    //退款原因
    QSRefundReasonView *refundreasonView = [[QSRefundReasonView alloc] initWithFrame:CGRectMake(10.0f, ypiont, scrollView.frame.size.width-20.0f, 90.0f) andCallBack:^(NSString *reason, int index) {
        
        NSLog(@"===============================%@,%d",reason,index);
        
    }];
    refundreasonView.layer.cornerRadius = 8.0f;
    refundreasonView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:refundreasonView];
    ypiont += (refundreasonView.frame.size.height + 5.0f);
    
    //确认退款按钮
    UIButton *confirmRefundButton = [UIButton createBlockActionButton:CGRectMake(10.0f, ypiont, scrollView.frame.size.width-20.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///初步判断参数
        if (nil == refundDataDict || (0 >= [refundDataDict count])) {
            
            return;
            
        }
        
        NSDictionary *tempDict = @{@"id" : [refundDataDict valueForKey:@"id"]};
        
        [[QSAPIClientBase sharedClient] prepaidCardRefundWithParams:tempDict andCallBack:^(int flag, NSString *errorInfo, NSString *errorCode) {
            
            ///判断是否退款成功
            if (0 == flag) {
                
                [self showTip:self.view tipStr:@"网络繁忙，请稍后再试。"];
                return;
            }
            
            ///回退成功
            if (1 == flag) {
                
                [self showTip:self.view tipStr:@"已成功提交退款申请，退款在三到五个工作日内到账！" andCallBack:^(){
                    
                    ///让上一级列表刷新数据
                    if (self.refundSuccessCallBack) {
                        self.refundSuccessCallBack(1);
                    }
                
                    ///进入我的交易页面
                    QSMyTradeListViewController *myTradeVC = [[QSMyTradeListViewController alloc] init];
                    [myTradeVC setValue:@"4" forKey:@"comeBackVCIndext"];
                    [self.navigationController pushViewController:myTradeVC animated:YES];
                
                }];
                return;
            }
            
        }];
        
        
    }];
    confirmRefundButton.layer.cornerRadius = 6.0f;
    [confirmRefundButton setTitle:@"确认退款" forState:UIControlStateNormal];
    confirmRefundButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [confirmRefundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmRefundButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    confirmRefundButton.backgroundColor = kBaseGreenColor;
    [scrollView addSubview:confirmRefundButton];
    ypiont += 54.0f;
    
    //判断是否需要重置滚动
    if (ypiont > scrollView.frame.size.height) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, ypiont+10.0f);
    }
    
}

@end
