//
//  QSPayFailViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPayFailViewController.h"
#import "QSBlockActionButton.h"
#import "QSMyTradeListViewController.h"

@interface QSPayFailViewController ()

@end

@implementation QSPayFailViewController

//**********************************
//             初始化/UI搭建
//**********************************
#pragma mark - 初始化/UI搭建
//重写导航栏
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"提示"];
}

- (void)createMainShowView
{
    [super createMainShowView];
    
    CGFloat centerXPoint = DeviceWidth/2.0f;
    CGFloat centerYPoint = DeviceHeight/2.0f;
    
    //提示信息
    UILabel *titleTips = [[UILabel alloc] initWithFrame:CGRectMake(centerXPoint-75.0f+25.0f, centerYPoint-90.0f, 150.0f, 40.0f)];
    titleTips.text = @"购买失败";
    titleTips.font = [UIFont boldSystemFontOfSize:30.0f];
    titleTips.textColor = kBaseGrayColor;
    [self.view addSubview:titleTips];
    
    //错误图标
    UIImageView *wrongImage = [[UIImageView alloc] initWithFrame:CGRectMake(titleTips.frame.origin.x-25.0f, centerYPoint-80.0f, 20.0f, 20.0f)];
    wrongImage.image = [UIImage imageNamed:@"prepaidcard_pay_fail_logo"];
    [self.view addSubview:wrongImage];
    
    //原因说明
    UILabel *detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, wrongImage.frame.origin.y+30.0f, DeviceWidth-40.0f, 20.0f)];
    detailInfo.text = @"可能因为网络原因无法购买成功！";
    detailInfo.font = [UIFont systemFontOfSize:12.0f];
    detailInfo.textColor = kBaseLightGrayColor;
    detailInfo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detailInfo];
    
    //重新购买按钮
    UIButton *rebuyButton = [UIButton createBlockActionButton:CGRectMake(detailInfo.frame.origin.x + 10.0f, detailInfo.frame.origin.y+60.0f, detailInfo.frame.size.width-20.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[[self.navigationController.viewControllers count] - 3] animated:YES];
    }];
    [rebuyButton setTitle:@"重新购买" forState:UIControlStateNormal];
    [rebuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rebuyButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    rebuyButton.layer.cornerRadius = 22.0f;
    rebuyButton.backgroundColor = kBaseGreenColor;
    [self.view addSubview:rebuyButton];
}

///返回事件重写，返回时直接跳转到我的交易页面
- (void)turnBackAction
{
    
    ///返回时无动画返回
    [super turnBackAction];
    
    ///返回时直接进入我的交易页面
    if (self.turnBackBlock) {
        
        self.turnBackBlock(nil,0,nil,nil);
        
    }
    
}

@end
