//
//  QSPaySuccessViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPaySuccessViewController.h"
#import "QSBlockActionButton.h"
#import "QSMyLunchBoxViewController.h"

@interface QSPaySuccessViewController (){
    
    ///购买账号是否新注册标记
    int _buyCountStatus;//!<保存当前购买用户是否新注册用户
    
}

@end

@implementation QSPaySuccessViewController

///初始化时就获取本地用户的状态，是否新注册用户
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        ///当前账号状态
        _buyCountStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:@"buy_user_count_status"] intValue];
        
    }
    
    return self;
}

//重写导航栏
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"提示"];
    
    //添加返回下标
    [self setValue:@"5" forKey:@"comeBackVCIndext"];
    
    //分享
    UIButton *button = [UIButton createBlockActionButton:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
    }];
    [button setImage:[UIImage imageNamed:@"prepaidcard_detail_share_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"prepaidcard_detail_share_highlighted"] forState:UIControlStateHighlighted];
    [self setNavigationBarRightView:button];
}

- (void)createMainShowView
{
    [super createMainShowView];
    
    CGFloat centerXPoint = DeviceWidth/2.0f;
    CGFloat centerYPoint = DeviceHeight/2.0f;
    
    //提示信息
    UILabel *titleTips = [[UILabel alloc] initWithFrame:CGRectMake(centerXPoint-75.0f+25.0f, centerYPoint-90.0f, 150.0f, 40.0f)];
    titleTips.text = @"购买成功";
    titleTips.font = [UIFont boldSystemFontOfSize:30.0f];
    titleTips.textColor = kBaseGrayColor;
    [self.view addSubview:titleTips];
    
    //错误图标
    UIImageView *successImage = [[UIImageView alloc] initWithFrame:CGRectMake(titleTips.frame.origin.x-25.0f, centerYPoint-80.0f, 20.0f, 20.0f)];
    successImage.image = [UIImage imageNamed:@"prepaidcard_pay_success_logo"];
    [self.view addSubview:successImage];
    
    //原因说明
    UILabel *detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, successImage.frame.origin.y+30.0f, DeviceWidth-40.0f, 20.0f)];
    detailInfo.text = @"再多卷、储值卡生成可能会有延时，请稍等！";
    detailInfo.font = [UIFont systemFontOfSize:12.0f];
    detailInfo.textColor = kBaseLightGrayColor;
    detailInfo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detailInfo];
    
    //查看集会卡
    UIButton *checkCardButton = [UIButton createBlockActionButton:CGRectMake(detailInfo.frame.origin.x + 10.0f, detailInfo.frame.origin.y+60.0f, (detailInfo.frame.size.width-20.0f-10.0f)/2.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        //进入我的餐盒
        [self gotoMyLunchBox];
        
    }];
    [checkCardButton setTitle:@"查看储值卡" forState:UIControlStateNormal];
    [checkCardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkCardButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    checkCardButton.layer.cornerRadius = 22.0f;
    checkCardButton.backgroundColor = kBaseGreenColor;
    [self.view addSubview:checkCardButton];
    
    //重新购买按钮
    UIButton *rebuyButton = [UIButton createBlockActionButton:CGRectMake(checkCardButton.frame.origin.x+checkCardButton.frame.size.width+10.0f, detailInfo.frame.origin.y+60.0f, checkCardButton.frame.size.width, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[[self.navigationController.viewControllers count] - 5] animated:YES];
    }];
    [rebuyButton setTitle:@"继续购买" forState:UIControlStateNormal];
    [rebuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rebuyButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    rebuyButton.layer.cornerRadius = 22.0f;
    rebuyButton.backgroundColor = kBaseGreenColor;
    [self.view addSubview:rebuyButton];
}

#pragma mark - 进入我的餐盒页面
- (void)gotoMyLunchBox
{
    
    ///检测是否已登录：没登录就登录
    [self checkIsLogin:nil and:@"" callBack:^(LOGINVIEW_STATUS status) {
        
        if (status) {
            
            ///已登录进入支付成功页面
            QSMyLunchBoxViewController *myLunchBox = [[QSMyLunchBoxViewController alloc] init];
            [myLunchBox setValue:@"6" forKey:@"comeBackVCIndext"];
            [self.navigationController pushViewController:myLunchBox animated:YES];
            
        } else {
        
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
    }];
    
}

///视图已经出现时，判断是否需要提醒用户，购买使用的手机和密码
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_buyCountStatus == 1) {
        
        [self showAlertMessageWithTime:3.0f andMessage:@"购买成功！\n用户名：购买时使用的手机号码\n密码：手机号后6位" andCallBack:^(CGFloat showTime) {
            
            ///更新本地的购买者状态
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"buy_user_count_status"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }];
        
    }
}

@end
