//
//  QSLunchBoxCouponDetailViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/3.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSLunchBoxCouponDetailViewController.h"
#import "QSImageView.h"
#import "QSBlockActionButton.h"
#import "QSResetImageFrameButton.h"
#import "QSLeftTitleBlockButton.h"
#import "QRCodeGenerator.h"
#import "QSExchangableFoodList.h"
#import "QSMyLunchBoxDetailUseNotice.h"
#import "QSMyLunchBoxRefundViewController.h"
#import "MJRefresh.h"
#import "QSAPIClientBase+CouponDetail.h"
#import "NSString+Name.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "QSMerchantChatListViewController.h"
#import "QSAPIModel+Merchant.h"
#import "QSNormalRecommendViewController.h"
#import "QSCouponDetailSendPwdViewController.h"

//测试UI背景颜色宏
#define SHOWTEST_BGCOLOR

//验证视图类型
typedef enum
{
    RQCODE_VERCODE = 0,
    PHONE_VERCODE
}VERIFICATION_TYPE;

#import <objc/runtime.h>

//关联
static char AllInfoScrollViewKey;//!<所有信息的底view
static char MarIconKey;
static char MarNameKey;
static char SubTitleKey;
static char ExpiredDateKey;
static char CouponLimitDateKey;
static char RegetCouponKey;
static char ApplyMarNameKey;
static char ApplyMarDistanceKey;
static char ApplyMarAddressKey;

static char DynamicSerielNumber;//!<动太序列号
static char DynamicDerielPassword;//!<动态密码

static char UserNoticeViewKey;//!<用户知须

static char RefundButtonKey;//!<退款按钮

@interface QSLunchBoxCouponDetailViewController (){
    
    NSString *_couponID;                    //优惠卷ID
    MYLUNCHBOX_COUPON_TYPE _couponType;     //优惠卷类型
    MYLUNCHBOX_COUPON_STATUS _couponStatus; //优惠类型
    NSString *_couponSubID;                 //!<优惠券子类型
    CGFloat _headerStartYPoint;             //主要信息开始的纵坐标
    
    NSString *_dynamicSerielNumber;         //!<动态序列号
    NSString *_dynamicSerielPWD;            //!<动态密码
    
    NSString *_merchantID;                  //!<商户ID
    NSString *_merchantName;                //!<商户名
    
}

@property (nonatomic,retain) QSYCouponDetailDataModel *couponDetailModel;//!<优惠券详情数据模型

@end

@implementation QSLunchBoxCouponDetailViewController

/**
 *  @author              yangshengmeng, 14-12-17 22:12:14
 *
 *  @brief               在目标视图加载显示支付失败的询问页
 *
 *  @param marName       商户名称
 *  @param marID         商户ID
 *  @param couponID      优惠券ID
 *  @param couponType    优惠券类型
 *  @param status        优惠券当前状态
 *
 *  @return              返回优惠券详情页面
 *
 *  @since               2.0
 */
- (instancetype)initWithMarchantName:(NSString *)marName andMarchantID:(NSString *)marID andCouponID:(NSString *)couponID andCouponSubID:(NSString *)couponSubID andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType andCouponStatus:(MYLUNCHBOX_COUPON_STATUS)status
{
    if (self = [super init]) {
        
        //保存优惠卷参数
        _couponID = [NSString stringWithString:couponID];
        _couponType = couponType;
        _couponStatus = status;
        _couponSubID = [couponSubID copy];
        
        ///初始化序列号和密码
        _dynamicSerielNumber = @"";
        _dynamicSerielPWD = @"123456";
        
        ///保存商户信息
        _merchantID = [marID copy];
        _merchantName = [marName copy];
        
        
    }
    
    return self;
}

//*******************************
//             UI搭建
//*******************************
#pragma mark - UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"优惠卷详情"];
}

- (void)createMainShowView
{
    //添加channel栏
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1.0f, 64.0f, DeviceWidth+1, 60.0f)];
    imageView.image = [UIImage imageNamed:@"prepaidcard_detail_channel_image"];
    [self.view addSubview:imageView];
    
    //店铺logo
    UIImageView *marIconAbove = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceWidth/2.0f-52.5, 64.0f, 105.0f, 105.0f)];
    marIconAbove.backgroundColor = [UIColor whiteColor];
    [marIconAbove roundView];
    [self.view addSubview:marIconAbove];
    
    UIImageView *marIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 95.0f, 95.0f)];
#ifdef SHOWTEST_BGCOLOR
    marIcon.backgroundColor = [UIColor orangeColor];
#endif
    [marIcon roundView];
    [marIconAbove addSubview:marIcon];
    objc_setAssociatedObject(self, &MarIconKey, marIcon, OBJC_ASSOCIATION_ASSIGN);
    
    //保存主要内容开始的坐标
    _headerStartYPoint = marIconAbove.frame.size.height + marIconAbove.frame.origin.y+10.0f;
    
    //进入不同类型的UI创建
    [self createRootView];
    
}

//判断是否已过期：过期与其他状态是不同的UI
- (void)createRootView
{
    switch (_couponStatus) {
            
        case EXPIRED_MCS:
            
            [self createExpiredUI];
            
            break;
            
        default:
            
            [self createNotExpiredUI];
            
            break;
    }
}

//********************************
//             创建已过期的UI
//********************************
#pragma mark - 创建已过期的UI
- (void)createExpiredUI
{
    //重设背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    switch (_couponType) {
        case PREPAIDCARD_MCT:
            [self createExpiredUI:@"重新抢购"];
            break;
            
        default:
            [self createExpiredUI:@"重新领取"];
            break;
    }
}

//真正创建已过期UI
- (void)createExpiredUI:(NSString *)resetButton
{
    //说明信息放在一个scrollview上，方便自适应
    UIScrollView *infoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, DeviceHeight-64.0f)];
    infoView.showsHorizontalScrollIndicator = NO;
    infoView.showsVerticalScrollIndicator = NO;
    infoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoView];
    [self.view sendSubviewToBack:infoView];
    objc_setAssociatedObject(self, &AllInfoScrollViewKey, infoView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加头部刷新
    [infoView addHeaderWithTarget:self action:@selector(couponDetailDataRequest)];
    [infoView headerBeginRefreshing];
    
    //主标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, _headerStartYPoint, DEFAULT_MAX_WIDTH, 20.0f)];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kBaseLightGrayColor;
    titleLabel.text = @"广州酒家菜品竞换卷";
    [self.view addSubview:titleLabel];
    objc_setAssociatedObject(self, &MarNameKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //副标题
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-180.0f)/2.0f, titleLabel.frame.origin.y+25.0f, 180.0f, 15.0f)];
    subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textColor = kBaseLightGrayColor;
    subTitleLabel.text = @"(香煎泰式鸡翅)";
    [self.view addSubview:subTitleLabel];
    objc_setAssociatedObject(self, &SubTitleKey, subTitleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //显示过期
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-240.0f)/2.0f, subTitleLabel.frame.origin.y+40.0f, 240.0f, 60.0f)];
    statusLabel.font = [UIFont systemFontOfSize:75.0f];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = kBaseGrayColor;
    statusLabel.text = @"已过期";
    [self.view addSubview:statusLabel];
    objc_setAssociatedObject(self, &ExpiredDateKey, statusLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //日期
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-220.0f)/2.0f, statusLabel.frame.origin.y+statusLabel.frame.size.height+10.0f, 220.0f, 15.0f)];
    dateLabel.font = [UIFont systemFontOfSize:12.0f];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = kBaseLightGrayColor;
    dateLabel.text = @"2014年10月23日";
    dateLabel.layer.cornerRadius = 4.0f;
    dateLabel.layer.borderColor = [kBaseLightGrayColor CGColor];
    dateLabel.layer.borderWidth = 0.5f;
    [self.view addSubview:dateLabel];
    objc_setAssociatedObject(self, &CouponLimitDateKey, dateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //重新获取按钮
    UIButton *regetCoupon = [UIButton createBlockActionButton:CGRectMake(10.0f, dateLabel.frame.origin.y+dateLabel.frame.size.height+25.0f, DeviceWidth-20.0f, 36.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
    }];
    [regetCoupon setTitle:resetButton forState:UIControlStateNormal];
    [regetCoupon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regetCoupon setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    regetCoupon.backgroundColor = kBaseOrangeColor;
    regetCoupon.layer.cornerRadius = 18.0f;
    [self.view addSubview:regetCoupon];
    objc_setAssociatedObject(self, &RegetCouponKey, regetCoupon, OBJC_ASSOCIATION_ASSIGN);
}

//********************************
//             创建已使期的UI
//********************************
#pragma mark - 创建已使期的UI
- (void)createNotExpiredUI
{
    //说明信息放在一个scrollview上，方便自适应
    UIScrollView *infoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, DeviceHeight-64.0f)];
    infoView.showsHorizontalScrollIndicator = NO;
    infoView.showsVerticalScrollIndicator = NO;
    infoView.backgroundColor = [UIColor clearColor];
    infoView.hidden = YES;
    [self.view addSubview:infoView];
    [self.view sendSubviewToBack:infoView];
    objc_setAssociatedObject(self, &AllInfoScrollViewKey, infoView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加头部刷新
    [infoView addHeaderWithTarget:self action:@selector(couponDetailDataRequest)];
    [infoView headerBeginRefreshing];
    
    CGFloat height = 0.0f;
    switch (_couponStatus) {
        case USING_MCS:
        {
            height = 328.0f;
            UIView *headerView = [self createHeaderBGImageView:infoView andHeight:height];
            [self createUsingCouponHeaderUI:headerView];
            [self createApplyMarchant:infoView andYPoint:headerView.frame.origin.y+headerView.frame.size.height+10.0f];
        }
            break;
            
        default:
            
            //确定头信息高度
            height = 285.0f;
            
            //跳转到创建普通状态的详情UI初始化
            [self createNormalDetailInfoUI:infoView andHeaderHeight:height];
            
            break;
    }
}

//不同类型的优惠卷头信息高度不同
- (UIView *)createHeaderBGImageView:(UIScrollView *)scrollView andHeight:(CGFloat)height
{
    //信息头：根据不同的类型，加载不同的头视图
    QSImageView *headerView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, scrollView.frame.size.width, height)];
    headerView.image = [UIImage imageNamed:@"prepaidcard_detail_header_bg"];
    [scrollView addSubview:headerView];
    
    return headerView;
}

//添加已使用头UI
- (void)createUsingCouponHeaderUI:(UIView *)view
{
    switch (_couponType) {
        case PREPAIDCARD_MCT:
            
            [self createUsingCouponHeaderUI:view andButtonTitle:@"重新抢购"];
            
            break;
            
        default:
            
            [self createUsingCouponHeaderUI:view andButtonTitle:@"重新领取"];
            
            break;
    }
}

//真正搭建已使用UI
- (void)createUsingCouponHeaderUI:(UIView *)view andButtonTitle:(NSString *)title
{
    //主标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, _headerStartYPoint-94.0f, DEFAULT_MAX_WIDTH, 20.0f)];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kBaseLightGrayColor;
    titleLabel.text = @"广州酒家菜品竞换卷";
    [view addSubview:titleLabel];
    objc_setAssociatedObject(self, &MarNameKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //副标题
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-180.0f)/2.0f, titleLabel.frame.origin.y+25.0f, 180.0f, 15.0f)];
    subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textColor = kBaseLightGrayColor;
    subTitleLabel.text = @"(香煎泰式鸡翅)";
    [view addSubview:subTitleLabel];
    objc_setAssociatedObject(self, &SubTitleKey, subTitleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //显示过期
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-240.0f)/2.0f, subTitleLabel.frame.origin.y+40.0f, 240.0f, 60.0f)];
    statusLabel.font = [UIFont systemFontOfSize:75.0f];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = kBaseOrangeColor;
    statusLabel.text = @"已使用";
    [view addSubview:statusLabel];
    objc_setAssociatedObject(self, &ExpiredDateKey, statusLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //日期
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-220.0f)/2.0f, statusLabel.frame.origin.y+statusLabel.frame.size.height+10.0f, 220.0f, 15.0f)];
    dateLabel.font = [UIFont systemFontOfSize:12.0f];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = kBaseOrangeColor;
    dateLabel.text = @"2014年10月23日";
    dateLabel.layer.cornerRadius = 4.0f;
    dateLabel.layer.borderColor = [kBaseOrangeColor CGColor];
    dateLabel.layer.borderWidth = 0.5f;
    [view addSubview:dateLabel];
    objc_setAssociatedObject(self, &CouponLimitDateKey, dateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///重新获取按钮
    UIButton *regetCoupon = [UIButton createBlockActionButton:CGRectMake(10.0f, dateLabel.frame.origin.y+dateLabel.frame.size.height+25.0f, DeviceWidth-20.0f, 36.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入商户优惠券列表
        QSNormalRecommendViewController *merchantCouponListVC = [[QSNormalRecommendViewController alloc] initWithMerchantID:_merchantID];
        [self.navigationController pushViewController:merchantCouponListVC animated:YES];
        
    }];
    [regetCoupon setTitle:title forState:UIControlStateNormal];
    [regetCoupon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regetCoupon setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    regetCoupon.backgroundColor = kBaseOrangeColor;
    regetCoupon.layer.cornerRadius = 18.0f;
    [view addSubview:regetCoupon];
    objc_setAssociatedObject(self, &RegetCouponKey, regetCoupon, OBJC_ASSOCIATION_ASSIGN);
}

//适用商户信息
#pragma mark - 适用商户信息
- (CGFloat)createApplyMarchant:(UIScrollView *)view andYPoint:(CGFloat)ypoint
{
    //可以使用商家信息
    UIView *applyMarRootView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, ypoint, DeviceWidth-20.0f, 120.0f)];
    applyMarRootView.layer.cornerRadius = 8.0f;
    applyMarRootView.backgroundColor = [UIColor whiteColor];
    [view addSubview:applyMarRootView];
    
    //添加适用商家信息
    [self createApplyMarInfoView:applyMarRootView];
    
    //添加分隔线
    UILabel *sepLabelHeader = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, applyMarRootView.frame.size.width, 0.5f)];
    sepLabelHeader.backgroundColor = kBaseLightGrayColor;
    sepLabelHeader.alpha = 0.5;
    [applyMarRootView addSubview:sepLabelHeader];
    
    UILabel *sepLabelFooter = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, applyMarRootView.frame.size.height-40.0f, applyMarRootView.frame.size.width, 0.5f)];
    sepLabelFooter.alpha = 0.5;
    sepLabelFooter.backgroundColor = kBaseLightGrayColor;
    [applyMarRootView addSubview:sepLabelFooter];
    
    UILabel *sepLabelLine = [[UILabel alloc] initWithFrame:CGRectMake(applyMarRootView.frame.size.width/2.0f - 0.25f, applyMarRootView.frame.size.height-30.0f, 0.5f, 20.0f)];
    sepLabelLine.backgroundColor = kBaseLightGrayColor;
    sepLabelLine.alpha = 0.5;
    [applyMarRootView addSubview:sepLabelLine];
    
    //判断是否需要滚动
    if ((ypoint + 120.0f + 10.0f) > view.frame.size.height) {
        view.contentSize = CGSizeMake(view.frame.size.width, ypoint + 120.0f + 10.0f);
    }
    
    return applyMarRootView.frame.size.height;
}

//适用商家信息
- (void)createApplyMarInfoView:(UIView *)view
{
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, view.frame.size.width-20.0f, 20.0f)];
    titleLabel.text = @"适用商户";
    titleLabel.textColor = kBaseGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLabel];
    
    //商户名
    UILabel *marNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height+10.0f, view.frame.size.width-20.0f, 20.0f)];
    marNameLabel.text = @"广州酒家(体育中心店)";
    marNameLabel.textColor = kBaseGrayColor;
    marNameLabel.font = [UIFont systemFontOfSize:14.0f];
    marNameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:marNameLabel];
    objc_setAssociatedObject(self, &ApplyMarNameKey, marNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //距离
    UIImageView *distance = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-70.0f, marNameLabel.frame.origin.y+5.0f, 10.0f, 15.0f)];
    distance.image = [UIImage imageNamed:@"prepaidcard_header_local"];
    [view addSubview:distance];
    
    //距离信息
    UILabel *distanceInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-55.0f, marNameLabel.frame.origin.y+5.0f, 50.0f, 15.0f)];
    distanceInfoLabel.text = @"953km";
    distanceInfoLabel.textColor = kBaseLightGrayColor;
    distanceInfoLabel.font = [UIFont systemFontOfSize:12.0f];
    distanceInfoLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:distanceInfoLabel];
    objc_setAssociatedObject(self, &ApplyMarDistanceKey, distanceInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //商户地址
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, marNameLabel.frame.origin.y+marNameLabel.frame.size.height+5.0f, view.frame.size.width-20.0f, 15.0f)];
    addressLabel.text = @"广州天河区体育东路112号百福广场11楼";
    addressLabel.textColor = kBaseLightGrayColor;
    addressLabel.font = [UIFont systemFontOfSize:12.0f];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:addressLabel];
    objc_setAssociatedObject(self, &ApplyMarAddressKey, addressLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //咨询按钮
    UIButton *consultButton = [UIButton createImageAndTitleButton:CGRectMake(view.frame.size.width/2.0f-130.0f, addressLabel.frame.origin.y+addressLabel.frame.size.height+15.0f, 120.0f, 20.0f) andCallBack:^(UIButton *button) {
        
        ///进入咨询页面
        if (![self checkIsLogin]) {
            return;
        }
        
        QSMerchantDetailData *model = [[QSMerchantDetailData alloc] init];
        model.merchant_id = _merchantID;
        model.merchant_name = _merchantName;
        QSMerchantChatListViewController *viewVC = [[QSMerchantChatListViewController alloc] init];
        viewVC.merchantDetailData = model;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    }];
    [consultButton setTitle:@"咨询商户" forState:UIControlStateNormal];
    [consultButton setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
    [consultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [consultButton setImage:[UIImage imageNamed:@"mylunchbox_consult_normal"] forState:UIControlStateNormal];
    [consultButton setImage:[UIImage imageNamed:@"mylunchbox_consult_highlighted"] forState:UIControlStateHighlighted];
    [view addSubview:consultButton];
    
    //致电商户
    UIButton *callMarButton = [UIButton createImageAndTitleButton:CGRectMake(view.frame.size.width/2.0f+consultButton.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+15.0f, 120.0f, 20.0f) andCallBack:^(UIButton *button) {
        
        [self makeCall:[UserManager sharedManager].userData.iphone];
        
    }];
    [callMarButton setTitle:@"致电商户" forState:UIControlStateNormal];
    [callMarButton setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
    [callMarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [callMarButton setImage:[UIImage imageNamed:@"mylunchbox_callmar_normal"] forState:UIControlStateNormal];
    [callMarButton setImage:[UIImage imageNamed:@"mylunchbox_callmar_highlighted"] forState:UIControlStateHighlighted];
    [view addSubview:callMarButton];
}

//********************************
//             普通详情头信息UI
//********************************
#pragma mark - 普通详情头信息UI
- (void)createCouponDetailHeaderUI:(UIView *)view
{
    //添加公共UI
    //主标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, _headerStartYPoint-94.0f, DEFAULT_MAX_WIDTH, 20.0f)];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kBaseLightGrayColor;
    titleLabel.text = @"广州酒家";
    [view addSubview:titleLabel];
    objc_setAssociatedObject(self, &MarNameKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //副标题
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-180.0f)/2.0f, titleLabel.frame.origin.y+25.0f, 180.0f, 15.0f)];
    subTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textColor = kBaseLightGrayColor;
    subTitleLabel.text = [self getCouponTypeName];
    [view addSubview:subTitleLabel];
    objc_setAssociatedObject(self, &SubTitleKey, subTitleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //不同类型，主显示信息不同
    UIView *mainInfoView = [[UIView alloc] initWithFrame:CGRectMake((DeviceWidth-240.0f)/2.0f, subTitleLabel.frame.origin.y+40.0f, 240.0f, [self returnDetailHeaderMainInfoViewHeight])];
    [view addSubview:mainInfoView];
    [self createDifferetHeaderUI:mainInfoView];
    
    //日期
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-163.0f)/2.0f, mainInfoView.frame.origin.y+mainInfoView.frame.size.height+10.0f, 163.0f, 15.0f)];
    dateLabel.font = [UIFont systemFontOfSize:12.0f];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = kBaseGreenColor;
    dateLabel.text = @"有效期：2014年10月23日";
    dateLabel.layer.cornerRadius = 4.0f;
    dateLabel.layer.borderColor = [kBaseGreenColor CGColor];
    dateLabel.layer.borderWidth = 0.5f;
    [view addSubview:dateLabel];
    objc_setAssociatedObject(self, &CouponLimitDateKey, dateLabel, OBJC_ASSOCIATION_ASSIGN);
}

//不同的类型，创建不同的显示UI
- (void)createDifferetHeaderUI:(UIView *)view
{
    //主显示信息
    CGFloat width = [self returnDetailHeaderTitleMessageWidth];
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width-width)/2.0f, 0.0f, width, view.frame.size.height)];
    statusLabel.font = [UIFont systemFontOfSize:[self returnDetailHeaderTitleMessageFont]];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = kBaseGreenColor;
    statusLabel.text = [self returnDetailHeaderTitleMessage];
    statusLabel.center = CGPointMake(view.frame.size.width/2.0f, view.frame.size.height/2.0f);
    statusLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:statusLabel];
    objc_setAssociatedObject(self, &ExpiredDateKey, statusLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //加载不同类型修饰视图
    [self createDifferetTypeSubviews:view andRelyView:statusLabel];
}

//不同类型创建不同的修饰视图
- (void)createDifferetTypeSubviews:(UIView *)view andRelyView:(UIView *)relyView
{
    NSString *flagString = nil;
    CGRect frame;
    switch (_couponType) {
            //折扣卷
        case FASTENING_VOLUME_MCT:
            flagString = @"折";
            frame = CGRectMake(relyView.frame.origin.x+relyView.frame.size.width, relyView.frame.origin.y+relyView.frame.size.height-15.0f, 15.0f, 15.0f);
            break;
            
            //代金卷
        case VOUCHER_MCT:
            flagString = @"￥";
            frame = CGRectMake(relyView.frame.origin.x-15.0f, relyView.frame.origin.y+relyView.frame.size.height-15.0f, 15.0f, 15.0f);
            break;
            
            //储值卡
        case PREPAIDCARD_MCT:
            flagString = @"余额￥";
            frame = CGRectMake(relyView.frame.origin.x-40.0f, relyView.frame.origin.y+relyView.frame.size.height-15.0f, 40.0f, 15.0f);
            break;
            
        default:
            break;
    }
    
    //修饰label
    UILabel *relyLabel = [[UILabel alloc] initWithFrame:frame];
    relyLabel.font = [UIFont systemFontOfSize:12.0f];
    relyLabel.textColor = kBaseGreenColor;
    relyLabel.text = flagString;
    [view addSubview:relyLabel];
}

//********************************
//             普通状态的详情视图
//********************************
#pragma mark - 普通状态的详情视图
- (void)createNormalDetailInfoUI:(UIScrollView *)scrollView andHeaderHeight:(CGFloat)headerHeight
{
    //头信息
    UIView *headerView = [self createHeaderBGImageView:scrollView andHeight:headerHeight];
    [self createCouponDetailHeaderUI:headerView];
    
    //y坐标记录
    CGFloat ypoint = headerView.frame.origin.y+headerView.frame.size.height+10.0f;
    
    //创建二维码
    ypoint += ([self createZBarScanView:scrollView andYPoint:ypoint] + 10.0f);
    
    if (_couponType == EXCHANGE_VOLUME_MCT) {
        
        //如果是兑换郑，则显示可兑换菜品列表
        QSExchangableFoodList *changableFoodListView = [[QSExchangableFoodList alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 115.0f) andDataSource:@[@{@"foodName" : @"培根烤鸭",@"count" : @"1",@"price" : @"38"},@{@"foodName" : @"香煎鸡柳",@"count" : @"1",@"price" : @"38"},@{@"foodName" : @"虾饺",@"count" : @"2",@"price" : @"20"},@{@"foodName" : @"玉米",@"count" : @"1",@"price" : @"12"}]];
        changableFoodListView.backgroundColor = [UIColor whiteColor];
        changableFoodListView.layer.cornerRadius = 8.0f;
        [scrollView addSubview:changableFoodListView];
        ypoint += 125.0f;
        
    }
    
    //适用商户信息
    ypoint += ([self createApplyMarchant:scrollView andYPoint:ypoint] + 10.0f);
    
    //使用须知
    QSMyLunchBoxDetailUseNotice *useNoticeView = [[QSMyLunchBoxDetailUseNotice alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 400.0f)];
    useNoticeView.layer.cornerRadius = 8.0f;
    useNoticeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:useNoticeView];
    ypoint += (useNoticeView.frame.size.height + 10.0f);
    objc_setAssociatedObject(self, &UserNoticeViewKey, useNoticeView, OBJC_ASSOCIATION_ASSIGN);
    
    if (_couponType == PREPAIDCARD_MCT) {
        
        //储值卡退款按钮
        UIButton *refundButton = [UIButton createBlockActionButton:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
            
            QSMyLunchBoxRefundViewController *refundView = [[QSMyLunchBoxRefundViewController alloc] init];
            refundView.refundSuccessCallBack = ^(int flag){
            
                ///如果成功提交退款，则让列表刷新
                if (self.refundCommitedCallBack) {
                    self.refundCommitedCallBack(flag);
                }
            
            };
            [self.navigationController pushViewController:refundView animated:YES];
            
        }];
        [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
        refundButton.backgroundColor = kBaseGreenColor;
        refundButton.layer.cornerRadius = 22.0f;
        [scrollView addSubview:refundButton];
        objc_setAssociatedObject(self, &RefundButtonKey, refundButton, OBJC_ASSOCIATION_ASSIGN);
        
        ypoint += 54.0f;
        
    }
    
    //重置scrollview的contentSize
    if (ypoint > scrollView.frame.size.height-10.0f) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, ypoint+10.0f);
    }
    
}

//********************************
//             基本数据返回
//********************************
#pragma mark - 基本数据返回
//获取副标题文本
- (NSString *)getCouponTypeName
{
    switch (_couponType) {
            //储值卡
        case PREPAIDCARD_MCT:
            return @"价值￥500";
            break;
            
            //折扣卷
        case FASTENING_VOLUME_MCT:
            return @"";
            break;
            
            //兑换卷
        case EXCHANGE_VOLUME_MCT:
            return @"菜品兑换卷";
            break;
            
            //代金卷
        case VOUCHER_MCT:
            return @"";
            break;
            
        default:
            return @"";
            break;
    }
    
    return @"";
}

//返回不同类型的主信息视图高度
- (CGFloat)returnDetailHeaderMainInfoViewHeight
{
    switch (_couponType) {
        case EXCHANGE_VOLUME_MCT:
            return 30.0f;
            break;
            
        default:
            break;
    }
    
    return 50.0f;
}

//测试信息
- (NSString *)returnDetailHeaderTitleMessage
{
    switch (_couponType) {
            //储值卡
        case PREPAIDCARD_MCT:
            return @"5000";
            break;
            
            //折扣卷
        case FASTENING_VOLUME_MCT:
            return @"7";
            break;
            
            //兑换卷
        case EXCHANGE_VOLUME_MCT:
            return @"香煎泰式鸡翅";
            break;
            
            //代金卷
        case VOUCHER_MCT:
            return @"100";
            break;
            
        default:
            return @"";
            break;
    }
    
    return @"";
}

//返回不同的宽度
- (CGFloat)returnDetailHeaderTitleMessageWidth
{
    switch (_couponType) {
            //储值卡
        case PREPAIDCARD_MCT:
            return 180.0f;
            break;
            
            //折扣卷
        case FASTENING_VOLUME_MCT:
            return 40.0f;
            break;
            
            //兑换卷
        case EXCHANGE_VOLUME_MCT:
            return 240.0f;
            break;
            
            //代金卷
        case VOUCHER_MCT:
            return 120.0f;
            break;
            
        default:
            break;
    }
    
    return 0.0f;
}

//返回不同的宽度
- (CGFloat)returnDetailHeaderTitleMessageFont
{
    switch (_couponType) {
            //折扣卷
        case EXCHANGE_VOLUME_MCT:
            return 30.0f;
            break;
            
        default:
            return 68.0f;
            break;
    }
    
    return 0.0f;
}

#pragma mark - 二维码扫描视图
- (CGFloat)createZBarScanView:(UIScrollView *)scrollView andYPoint:(CGFloat)ypoint
{
    //可以使用商家信息
    UIView *zbarCodeView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, ypoint, DeviceWidth-20.0f, 170.0f)];
    zbarCodeView.layer.cornerRadius = 8.0f;
    zbarCodeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:zbarCodeView];
    
    //二维码和密码页面信息更换UI
    [self createZBarAndPasswordUI:zbarCodeView];
    
    return zbarCodeView.frame.size.height;
}

- (void)createZBarAndPasswordUI:(UIView *)view
{
    //不同验证的底view
    UIView *verView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 40.0f, view.frame.size.width-20.0f, view.frame.size.height-50.0f)];
    [self createVerificationSubviewUI:verView andType:PHONE_VERCODE];
    [view addSubview:verView];
    
    //不同的验证切换
    UIButton *changeButton = [UIButton createLeftTitleButton:CGRectMake(view.frame.size.width-105.0f, 0.0f, 110.0f, 29.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        if (button.selected) {
            button.selected = NO;
            [self createVerificationSubviewUI:verView andType:PHONE_VERCODE];
        } else {
            button.selected = YES;
            [self createVerificationSubviewUI:verView andType:RQCODE_VERCODE];
        }
        
    }];
    [changeButton setTitle:@"二维码验证" forState:UIControlStateNormal];
    [changeButton setTitle:@"返回" forState:UIControlStateSelected];
    [changeButton setImage:[UIImage imageNamed:@"mylunchbox_detail_qrcode"] forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"mylunchbox_detail_turnback_phone"] forState:UIControlStateSelected];
    changeButton.selected = NO;
    [changeButton setTitleColor:kBaseLightGrayColor forState:UIControlStateNormal];
    changeButton.titleLabel.textAlignment = NSTextAlignmentRight;
    changeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:changeButton];
    
    
}

//验证视图不同的UI创建
- (void)createVerificationSubviewUI:(UIView *)view andType:(VERIFICATION_TYPE)verType
{
    //先清空原子视图
    for (UIView *obj in [view subviews]) {
        [obj removeFromSuperview];
    }
    
    //创建不同的验证UI
    if (verType == PHONE_VERCODE) {
        //手机验证
        
        //序列号
        UILabel *serialNumTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
        serialNumTitleLabel.text = @"序列号";
        serialNumTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        serialNumTitleLabel.textColor = kBaseOrangeColor;
        [view addSubview:serialNumTitleLabel];
        
        UILabel *serialNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-240.0f, 0.0f, 240.0f, 30.0f)];
        serialNumLabel.text = _dynamicSerielNumber;
        serialNumLabel.font = [UIFont systemFontOfSize:25.0f];
        serialNumLabel.textColor = kBaseOrangeColor;
        serialNumLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:serialNumLabel];
        objc_setAssociatedObject(self, &DynamicSerielNumber, serialNumLabel, OBJC_ASSOCIATION_ASSIGN);
        
        //密码
        UILabel *passwordTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,serialNumTitleLabel.frame.origin.y+serialNumTitleLabel.frame.size.height+5.0f, 40.0f, 30.0f)];
        passwordTitleLabel.text = @"密码";
        passwordTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        passwordTitleLabel.textColor = kBaseOrangeColor;
        [view addSubview:passwordTitleLabel];
        
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-240.0f, passwordTitleLabel.frame.origin.y, 240.0f, 30.0f)];
        passwordLabel.text = _dynamicSerielPWD;
        passwordLabel.font = [UIFont systemFontOfSize:25.0f];
        passwordLabel.textColor = kBaseOrangeColor;
        passwordLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:passwordLabel];
        objc_setAssociatedObject(self, &DynamicDerielPassword, passwordLabel, OBJC_ASSOCIATION_ASSIGN);
        
        //发送到手机按钮
        UIButton *sendVerCodeToPhoneButton = [UIButton createBlockActionButton:CGRectMake(0.0f, view.frame.size.height-31.0f, view.frame.size.width, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
            
            ///弹出手机窗口
            [QSCouponDetailSendPwdViewController showSendMessageWithPhone:[UserManager sharedManager].userData.iphone andMessage:[NSString stringWithFormat:@"[吃订你]：您序列号为:%@ 的优惠券当前使用密码是：%@",_dynamicSerielNumber,_dynamicSerielPWD]];
            
        }];
        [sendVerCodeToPhoneButton setTitle:@"发送到手机" forState:UIControlStateNormal];
        [sendVerCodeToPhoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendVerCodeToPhoneButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
        sendVerCodeToPhoneButton.backgroundColor = kBaseOrangeColor;
        sendVerCodeToPhoneButton.layer.cornerRadius = 15.0f;
        [view addSubview:sendVerCodeToPhoneButton];
        
        return;
    }
    
    //二维码验证
    UIImageView *rqImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width-90.0f)/2.0f, 0.0f, 90.0f, 90.0f)];
    UIImage *image = [QRCodeGenerator qrImageForString:_dynamicSerielPWD imageSize:120];
    rqImageView.image = image;
    [view addSubview:rqImageView];
    
    //文字说明
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(rqImageView.frame.origin.x, rqImageView.frame.origin.y+rqImageView.frame.size.height+2.0f, rqImageView.frame.size.width, 20.0f)];
    tipsLabel.text = @"二维码验证";
    tipsLabel.font = [UIFont systemFontOfSize:12.0f];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = kBaseLightGrayColor;
    [view addSubview:tipsLabel];
}

/**
 *  @author yangshengmeng, 14-12-17 11:12:00
 *
 *  @brief  请求优惠券详情信息
 *
 *  @since  2.0
 */
#pragma mark - 请求优惠券详情信息
- (void)couponDetailDataRequest
{
    
    ///延迟0.22秒后再刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///封装参数
        NSDictionary *params = @{@"id":_couponID,@"type":[NSString stringWithFormat:@"%d",_couponType],@"detail_id":_couponSubID};
        
        ///请求优惠详情
        [[QSAPIClientBase sharedClient] getCouponDetailWithID:params andCallBack:^(BOOL requestFlag, QSYCouponDetailDataModel *model, NSString *errorInfo, NSString *errorCode) {
            
            ///判断成功与否
            if (!requestFlag) {
                
                ///弹出请求失败说明
                [self showTip:self.view tipStr:@"储值卡详情请求失败"];
                NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,errorInfo);
                
            }
            
            ///请求成功进入刷新UI
            self.couponDetailModel = model;
            [self updateCouponDetailUI:model];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///结束刷新动画
                [self endHeaderRequestAnimination];
                
            });
            
        }];
        
    });
    
}

/**
 *  @author yangshengmeng, 14-12-17 11:12:04
 *
 *  @brief  结束刷新动画
 *
 *  @since  2.0
 */
- (void)endHeaderRequestAnimination
{
    UIScrollView *scrollView = objc_getAssociatedObject(self, &AllInfoScrollViewKey);
    [scrollView headerEndRefreshing];
}

/**
 *  @author         yangshengmeng, 14-12-22 20:12:39
 *
 *  @brief          刷新UI
 *
 *  @param model    数据模型
 *
 *  @since          2.0
 */
#pragma mark - 刷新UI
- (void)updateCouponDetailUI:(QSYCouponDetailDataModel *)cardModel
{

    ///更新商户信息
    [self updateMarchantBaseInfo:cardModel.marchantBaseInfoModel];
    
    ///更新商户名称及券名
    [self updateMerchantName:cardModel.marchantBaseInfoModel.marName andCardName:[NSString getCouponTypeChineseName:[NSString formatCouponTypeWithType:cardModel.couponType andSubType:cardModel.couponSubType]] andValueInfo:cardModel.prepaidCardValuePrice andCouponType:[NSString formatCouponTypeWithType:cardModel.couponType andSubType:cardModel.couponSubType]];
    
    ///更新序列号
    [self updateSerielNumber:cardModel.personCouponInfoModel.serielNumber];
    
    ///更新动态密码
    [self updateSerielPasswork:cardModel.personCouponInfoModel.dynamicPassWord];
    
    ///更新适用商户地址
    [self updateApplyMerchantAddress:cardModel.marchantBaseInfoModel.merAddress];
    
    ///更新使用知需
    [self updateCouponComment:cardModel.des];
    
    ///更新中间大标题
    [self updateMiddelBigTitleInfo:cardModel andType:[NSString formatCouponTypeWithType:cardModel.couponType andSubType:cardModel.couponSubType]];
    
    ///显示底view
    UIView *rootView = objc_getAssociatedObject(self, &AllInfoScrollViewKey);
    if (rootView) {
        rootView.hidden = NO;
    }
    
}

/**
 *  @author         yangshengmeng, 14-12-23 12:12:13
 *
 *  @brief          更新中间大标题信息：可能是金额，也可能是折扣
 *
 *  @param model    数据模型
 *  @param type     优惠券类型
 *
 *  @since      2.0
 */
- (void)updateMiddelBigTitleInfo:(QSYCouponDetailDataModel *)model andType:(MYLUNCHBOX_COUPON_TYPE)couponType
{

    switch (couponType) {
            ///更新储值卡
        case PREPAIDCARD_MCT:
            
            ///显示余额
            [self updateMiddleGigTitle:[NSString stringWithFormat:@"%.2f",[model.personCouponInfoModel.leftValue floatValue]]];
            
            ///更新日期
            [self updateLastLimitedTime:[NSString stringWithFormat:@"有效期：%@",[NSDate formatIntegerIntervalToDateString:model.lastTime]]];
            
            ///更新是否可以退款
            CGFloat sumValue = [model.personCouponInfoModel.valuePrice floatValue];
            CGFloat leftValue = [model.personCouponInfoModel.leftValue floatValue];
            if (sumValue - leftValue > 0.5f) {
                
                ///如果已使用过，则不再可以退款
                [self updateRefundButton:YES];
                
            } else {
            
                ///保存退款参数
                NSDictionary *tempDict = @{@"order_des" : [NSString stringWithFormat:@"%@储值卡(￥%.2f)",model.marchantBaseInfoModel.marName,sumValue],
                                           @"refund_count" : @"1",
                                           @"id" : model.personCouponInfoModel.userCardID};
                ///保存到本地
                [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:@"prepaidCard_refund_info"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
            }
            
            break;
            
            ///菜品兑换券
        case EXCHANGE_VOLUME_MCT:
            
            [self updateMiddleGigTitle:model.couponName];
            
            ///更新日期
            [self updateLastLimitedTime:[NSString stringWithFormat:@"有效期：%@",[NSDate formatIntegerIntervalToDateString:model.lastTime]]];
            
            break;
            
            ///代金券
        case VOUCHER_MCT:
            
            [self updateMiddleGigTitle:model.coucherValue];
            
            ///更新日期
            [self updateLastLimitedTime:[NSString stringWithFormat:@"有效期：%@",[NSDate formatIntegerIntervalToDateString:model.lastTime]]];
            
            break;
            
            ///折扣券
        case FASTENING_VOLUME_MCT:
            
            [self updateMiddleGigTitle:model.foodOfferDiscount];
            
            ///更新日期
            [self updateLastLimitedTime:[NSString stringWithFormat:@"有效期：%@",[NSDate formatIntegerIntervalToDateString:model.lastTime]]];
            
            break;
            
        case FOODOFF_MCT:
            
            ///更新日期
            [self updateLastLimitedTime:[NSString stringWithFormat:@"%@至%@",[NSDate formatIntegerIntervalToDateString:model.lastTime],[NSDate formatIntegerIntervalToDateString:model.startTime]]];
            
            break;
            
        default:
            break;
    }

}

///更新退款按钮
- (void)updateRefundButton:(BOOL)flag
{

    UIButton *button = objc_getAssociatedObject(self, &RefundButtonKey);
    button.hidden = YES;

}

///更新时间日期
- (void)updateLastLimitedTime:(NSString *)time
{

    UILabel *limitedDateLabel = objc_getAssociatedObject(self, &CouponLimitDateKey);
    if (limitedDateLabel && time) {
        limitedDateLabel.text = time;
    }

}

///更新中间大标题信息
- (void)updateMiddleGigTitle:(NSString *)titleInfo
{

    UILabel *bigTitleLabel = objc_getAssociatedObject(self, &ExpiredDateKey);
    if (bigTitleLabel && titleInfo) {
        bigTitleLabel.text = titleInfo;
    }

}

///更新说明信息
- (void)updateCouponComment:(NSString *)comment
{

    QSMyLunchBoxDetailUseNotice *view = objc_getAssociatedObject(self, &UserNoticeViewKey);
    [view updateUserNotice:comment];

}

/**
 *  @author                 yangshengmeng, 14-12-23 09:12:20
 *
 *  @brief                  更新商户名称及卡类名
 *
 *  @param merName          商户名
 *  @param valueInfo        储值卡的价值
 *  @param cardTypeName     卡名
 *
 *  @since                  2.0
 */
- (void)updateMerchantName:(NSString *)merName andCardName:(NSString *)cardTypeName andValueInfo:(NSString *)valueInfo andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType
{

    switch (couponType) {
            ///更新储值卡
        case PREPAIDCARD_MCT:
            
            ///更新标题
            [self updateMerchantName:[NSString stringWithFormat:@"%@%@",merName,cardTypeName]];
            
            ///更新价值
            [self updateMerchantSubTitle:[NSString stringWithFormat:@"(价值￥%@)",valueInfo]];
            
            break;
        
            ///菜品兑换券
        case EXCHANGE_VOLUME_MCT:
            
            ///更新标题
            [self updateMerchantName:merName];
            
            ///更新价值
            [self updateMerchantSubTitle:cardTypeName];
            
            break;
            
            ///代金券和折扣券用的是更新主标题即可
        case VOUCHER_MCT:
            
        case FASTENING_VOLUME_MCT:
            
            [self updateMerchantName:[NSString stringWithFormat:@"%@%@",merName,cardTypeName]];
            
            break;
            
            ///菜品优惠券
        case FOODOFF_MCT:
            
            ///更新标题
            [self updateMerchantName:merName];
            
            ///更新价值
            [self updateMerchantSubTitle:@"(试吃优惠券)"];
            
            break;
            
        default:
            break;
    }
    
    ///更新适应商户的标题
    UILabel *applyMerchantLabel = objc_getAssociatedObject(self, &ApplyMarNameKey);
    applyMerchantLabel.text = merName;

}

///更新适应商户的地址
- (void)updateApplyMerchantAddress:(NSString *)add
{

    UILabel *addressLabel = objc_getAssociatedObject(self, &ApplyMarAddressKey);
    if (addressLabel && add) {
        addressLabel.text = add;
    }

}

/**
 *  @author                 yangshengmeng, 14-12-23 10:12:35
 *
 *  @brief                  更新主标题，一般是商户名称
 *
 *  @param merchantTitle    商户标题信息
 *
 *  @since                  2.0
 */
- (void)updateMerchantName:(NSString *)merchantTitle
{

    UILabel *merchantNameLabel = objc_getAssociatedObject(self, &MarNameKey);
    if (merchantNameLabel && merchantTitle) {
        merchantNameLabel.text = merchantTitle;
    }

}

/**
 *  @author         yangshengmeng, 14-12-23 10:12:08
 *
 *  @brief          更新副标题
 *
 *  @param subTitle 副标题内容
 *
 *  @since          2.0
 */
- (void)updateMerchantSubTitle:(NSString *)subTitle
{

    UILabel *subLabel = objc_getAssociatedObject(self, &SubTitleKey);
    if (subLabel && subTitle) {
        subLabel.text = subTitle;
    }

}

/**
 *  @author         yangshengmeng, 14-12-12 13:12:33
 *
 *  @brief          更新优惠券发行商户的信息
 *
 *  @param model    商户数据模型
 *
 *  @since          2.0
 */
- (void)updateMarchantBaseInfo:(QSYMarchantBaseInfoDataModel *)model
{
    ///更新商户图标
    UIImageView *marchantLogo = objc_getAssociatedObject(self, &MarIconKey);
    [marchantLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"default_file_super_url"],model.marIcon]] placeholderImage:nil];
    
    ///更新商户距离
    [self updateMerchantDistance:model.merchantLongitude andLatitude:model.merchantLatitude];
    
}

///更新商户和当前用户的距离
- (void)updateMerchantDistance:(NSString *)longitude andLatitude:(NSString *)latitude
{

    UILabel *distanceLabel = objc_getAssociatedObject(self, &ApplyMarDistanceKey);
    if (distanceLabel && longitude && latitude) {
        
        CLLocationCoordinate2D point1 = [UserManager sharedManager].userData.location;
        CLLocationCoordinate2D point2 = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        NSString *distance = [[UserManager sharedManager] distanceBetweenTwoPoint:point1 andPoint2:point2];
        
        distanceLabel.text = [NSString stringWithFormat:@"%@",distance];
        
    }
    
}

/**
 *  @author         yangshengmeng, 14-12-23 10:12:53
 *
 *  @brief          更新序列号
 *
 *  @param number   序列号
 *
 *  @since          2.0
 */
- (void)updateSerielNumber:(NSString *)number
{

    UILabel *serielLabel = objc_getAssociatedObject(self, &DynamicSerielNumber);
    if (serielLabel && number) {
        serielLabel.text = number;
        _dynamicSerielNumber = number;
    }

}

/**
 *  @author yangshengmeng, 14-12-23 09:12:50
 *
 *  @brief  更新动态密码
 *
 *  @param  pwd 运态密码
 *
 *  @since  2.0
 */
- (void)updateSerielPasswork:(NSString *)pwd
{

    ///获取密码框
    UILabel *pwdLabel = objc_getAssociatedObject(self, &DynamicDerielPassword);
    if (pwdLabel && pwd) {
        pwdLabel.text = pwd;
        _dynamicSerielPWD = pwd;
    }

}

@end
