//
//  QSPrepaidCardDetailViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidCardDetailViewController.h"
#import "QSOrderFormViewController.h"
#import "UIView+UI.h"
#import "QSBlockActionButton.h"
#import "QSImageView.h"
#import "MJRefresh.h"
#import "QSPrepaidCardDetailTabbarView.h"
#import "QSMerchantIndexViewController.h"
#import "QSUseNoticeViewController.h"
#import "QSFavourableDetailViewController.h"
#import "QSAPIClientBase+CouponDetail.h"
#import "UIImageView+AFNetworking.h"
#import "QSAPI.h"
#import "NSString+Name.h"
#import "SocaialManager.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"
#import "QSAPIClientBase+User.h"
#import "QSYCustomHUD.h"
#import "QSAPIClientBase+User.h"
#import "QSMapNavViewController.h"
#import "QSAPIModel+Merchant.h"

#import <objc/runtime.h>

///记录支持条件图标的tag
#define TAG_PREPAIDCARD_DETAIL_SUPPORT_LOGO_ROOT 350

//是否显示测试背景颜色
//#define SHOWTEST_BGCOLOR

//关联
static char MarIconKey;
static char CollectTipsKey;

static char DetailInfoRootView;

static char SalePriceKey;
static char SalePriceRMBFlagKey;
static char OriginalPrieceKey;
static char PrepaidCardDescriptionKey;
static char SupportInfoKey;
static char OverTimeSupportInfoKey;
static char ApointSupportInfoKey;
static char SoldCountInfoKey;

@interface QSPrepaidCardDetailViewController (){
    
    NSString *_marchantName;    //!<商户名
    NSString *_marchantID;      //!<商户ID
    NSString *_prepaidCardID;   //!<储值卡ID
    
    int _insteretingFlag;//!<当前用户是否已收藏些商户
    
}

@property (nonatomic,retain) QSYCouponDetailDataModel *prepaidCardDataModel;//!<详情数据模型

@end

@implementation QSPrepaidCardDetailViewController

/**
 *  @author             yangshengmeng, 14-12-12 10:12:44
 *
 *  @brief              根据商户名称和集会卡ID创建详情页面
 *
 *  @param marchantName 商户名
 *  @param cardID       集会卡ID
 *
 *  @return             返回详情页面
 *
 *  @since              2.0
 */
#pragma mark - 根据商户名称和集会卡ID创建详情页面
- (instancetype)initWithMarchantName:(NSString *)marchantName andMarID:(NSString *)marID andPrepaidCardID:(NSString *)cardID
{
    if (self = [super init]) {
        
        ///保存商户名
        _marchantName = [marchantName copy];
        
        ///保存商户ID
        _marchantID = [marID copy];
        
        ///保存储值卡ID
        _prepaidCardID = [cardID copy];
        
        ///初始化当前用户是否已收藏标记
        _insteretingFlag = -1;
        
    }
    
    return self;
}

//*******************************************
//             UI搭建
//*******************************************
#pragma mark - UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
    
    ///设置标题
    [self setNavigationBarMiddleTitle:_marchantName];
    
    ///分享按钮
    UIButton *button = [UIButton createBlockActionButton:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///分享
        UIImageView *marchantLogo = objc_getAssociatedObject(self, &MarIconKey);
        UIImage *tempImage = marchantLogo.image;
        [[SocaialManager sharedManager] showNewUIShareOnVC:self
                                                   Content:@"省心省力省钱省时间，“吃订你”轻轻一点立即省"
                                                  UserName:[UserManager sharedManager].userData.username
                                                  WorkName:nil
                                                    Images:tempImage
                                                 ImagesUrl:nil];
        
    }];
    [button setImage:[UIImage imageNamed:@"prepaidcard_detail_share_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"prepaidcard_detail_share_highlighted"] forState:UIControlStateHighlighted];
    [self setNavigationBarRightView:button];
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
    
    //点赞
    UIView *praiseAbove = [[UIView alloc] initWithFrame:CGRectMake(marIconAbove.center.x+52.5-34.0f, marIconAbove.center.y+52.5-34.0f, 34.0f, 34.0f)];
    [praiseAbove roundView];
    praiseAbove.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:praiseAbove];
    
    QSImageView *praiseView = [[QSImageView alloc] initWithFrame:CGRectMake(2.0f, 2.0f, 30.0f, 30.0f) andCallBack:^(SINGLETAP_IMAGEVIEW_ACTIONTYPE actionType) {
        
        [self addInsteretedMerchant:actionType];
        
    }];
    [praiseView roundView];
    praiseView.image = [UIImage imageNamed:@"prepaidcard_detail_collect_normal"];
    [praiseAbove addSubview:praiseView];
    objc_setAssociatedObject(self, &CollectTipsKey, praiseView, OBJC_ASSOCIATION_ASSIGN);
    
    //说明信息放在一个scrollview上，方便自适应
    UIScrollView *infoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, DeviceHeight-64.0f)];
    infoView.showsHorizontalScrollIndicator = NO;
    infoView.showsVerticalScrollIndicator = NO;
    infoView.backgroundColor = [UIColor clearColor];
    infoView.hidden = YES;
    [self.view addSubview:infoView];
    [self.view sendSubviewToBack:infoView];
    objc_setAssociatedObject(self, &DetailInfoRootView, infoView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加头部刷新事件
    [infoView addHeaderWithTarget:self action:@selector(requestMarchantCardDetailInfo)];
    [infoView headerBeginRefreshing];
    
    //信息头：
    QSImageView *headerView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, infoView.frame.size.width, 376.0f)];
    headerView.image = [UIImage imageNamed:@"prepaidcard_detail_header_bg"];
    [infoView addSubview:headerView];
    [self createPrepaidCardInfo:headerView andYPoint:marIconAbove.frame.origin.y+marIconAbove.frame.size.height-infoView.frame.origin.y-headerView.frame.origin.y+15.0f];
    
    //底部tabbar按钮
    CGFloat verliticalYPoint = headerView.frame.origin.y+headerView.frame.size.height+10.0f;
    CGFloat bottomYPoint = infoView.frame.size.height-73.0f;
    QSPrepaidCardDetailTabbarView *tabbarView = [[QSPrepaidCardDetailTabbarView alloc] initWithFrame:CGRectMake(0.0f, bottomYPoint > verliticalYPoint ? bottomYPoint : verliticalYPoint, infoView.frame.size.width, 63.0f) andCallBack:^(PREPAIDCARD_DETAIL_TABBAR_CALLBACKTYPE actionType) {
        
        [self prepaidDetailInstructionAction:actionType];
        
    }];
    [infoView addSubview:tabbarView];
    
    //设置是否可以滚动
    if ((tabbarView.frame.origin.y+tabbarView.frame.size.height+15.0f) > infoView.frame.size.height) {
        infoView.contentSize = CGSizeMake(infoView.frame.size.width, tabbarView.frame.origin.y+tabbarView.frame.size.height+15.0f);
    }
}

//储值卡信息
- (void)createPrepaidCardInfo:(UIView *)view andYPoint:(CGFloat)ypoint
{
#if 1
    //现价
    UILabel *salePrice = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width-150.0f)/2.0f+15.0f, ypoint, 150.0f, 50.0f)];
    salePrice.font = [UIFont boldSystemFontOfSize:67.0f];
    salePrice.textColor = kBaseOrangeColor;
    salePrice.textAlignment = NSTextAlignmentCenter;
    salePrice.text = @"4793";
    [view addSubview:salePrice];
    objc_setAssociatedObject(self, &SalePriceKey, salePrice, OBJC_ASSOCIATION_ASSIGN);
    
    //价钱前的rmb符号
    UILabel *rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(salePrice.frame.origin.x-15.0f, ypoint+50.0f-10.0f, 15.0f, 10.0f)];
    rmbLabel.text = kRMBSymbol;
    rmbLabel.textColor = kBaseOrangeColor;
    rmbLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:rmbLabel];
    objc_setAssociatedObject(self, &SalePriceRMBFlagKey, rmbLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //原价
    UILabel *originalPrice = [[UILabel alloc] initWithFrame:CGRectMake(rmbLabel.frame.origin.x, salePrice.frame.origin.y+salePrice.frame.size.height+5.0f, salePrice.frame.size.width+rmbLabel.frame.size.width, 25.0f)];
    [originalPrice roundCornerRadius:25.0f/2.0f];
    originalPrice.layer.masksToBounds = YES;
    originalPrice.text = @"价值￥5300";
    originalPrice.backgroundColor = kBaseGreenColor;
    originalPrice.textAlignment = NSTextAlignmentCenter;
    originalPrice.textColor = [UIColor whiteColor];
    [view addSubview:originalPrice];
    objc_setAssociatedObject(self, &OriginalPrieceKey, originalPrice, OBJC_ASSOCIATION_ASSIGN);
    
    //详情
    UILabel *detailInfo = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-270.0f)/2.0f, originalPrice.frame.origin.y+originalPrice.frame.size.height+10.0f, 270.0f, 40.0f)];
    detailInfo.text = @"价值500元储值卡，现仅售360元，无需预约节假日通用全场通用！";
    detailInfo.textColor = kBaseGrayColor;
    detailInfo.font = [UIFont systemFontOfSize:14.0f];
    detailInfo.numberOfLines = 2;
    [view addSubview:detailInfo];
    objc_setAssociatedObject(self, &PrepaidCardDescriptionKey, detailInfo, OBJC_ASSOCIATION_ASSIGN);
    
    //其他信息
    UIView *otherInfo = [[UIView alloc] initWithFrame:CGRectMake((DeviceWidth-270.0f)/2.0f, detailInfo.frame.origin.y+45.0f, 270.0f, 55.0f)];
    [self createOtherInfoSubviews:otherInfo];
    [view addSubview:otherInfo];
    
    //进入详情页
    UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height-66.0f, view.frame.size.width-20.0f, 36.0f)];
    [buyButton setTitle:@"立刻抢购" forState:UIControlStateNormal];
    [buyButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.backgroundColor = kBaseGreenColor;
    buyButton.layer.cornerRadius = buyButton.frame.size.height/2.0f;
    [buyButton addTarget:self action:@selector(gotoOrderFormVC) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buyButton];
#endif
}

//创建其他信息项
- (void)createOtherInfoSubviews:(UIView *)view
{
    //创建图标:prepaid_detail_otherinfo_unhaved
    NSArray *otherIconArray = @[@"prepaid_detail_otherinfo_unhaved",@"prepaid_detail_otherinfo_unhaved",@"prepaid_detail_otherinfo_unhaved",@"prepaid_detail_otherinfo_sold"];
    CGFloat xpoint = view.frame.size.width/2.0f;
    CGFloat ypoint = view.frame.size.height/2.0f;
    CGFloat width = view.frame.size.width/2.0f - 60.0f;
    
    for (int i = 0; i < 4; i++) {
        
        UIImageView *tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
        if (i % 2 == 0) {
            
            if (i > 1) {
                tempImage.frame = CGRectMake(xpoint-60.0f-width, ypoint+7.5f, 20.0f, 20.0f);
            } else {
                tempImage.frame = CGRectMake(xpoint-60.0f-width, 2.5f, 20.0f, 20.0f);
            }
            
        } else {
            
            if (i > 1) {
                tempImage.frame = CGRectMake(xpoint+35.0f, ypoint+7.5f, 20.0f, 20.0f);
            } else {
                tempImage.frame = CGRectMake(xpoint+35.0f, 2.5f, 20.0f, 20.0f);
            }
            
        }
        
        //设置图片
        tempImage.image = [UIImage imageNamed:otherIconArray[i]];
        
        ///记录tag
        tempImage.tag = TAG_PREPAIDCARD_DETAIL_SUPPORT_LOGO_ROOT + i;
        
        [view addSubview:tempImage];
    }
    
    //不同信息的UILabel
    UILabel *supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint-35.0f-width, 0.0f, width, 25.0f)];
    supportLabel.font = [UIFont systemFontOfSize:14.0f];
    supportLabel.textColor = kBaseLightGrayColor;
    supportLabel.text = @"支持随时退";
    supportLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:supportLabel];
    objc_setAssociatedObject(self, &SupportInfoKey, supportLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *overDueLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint-35.0f-width, ypoint+5.0f, width, 25.0f)];
    overDueLabel.font = [UIFont systemFontOfSize:14.0f];
    overDueLabel.textColor = kBaseLightGrayColor;
    overDueLabel.text = @"过期自动退";
    overDueLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:overDueLabel];
    objc_setAssociatedObject(self, &OverTimeSupportInfoKey, overDueLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2.0f-0.25f, 0.0f, 0.5f, view.frame.size.height)];
    sepLabel.backgroundColor = kBaseLightGrayColor;
    sepLabel.alpha = 0.5f;
    [view addSubview:sepLabel];
    
    UILabel *appointLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint+60.0f, 0.0f, width, 25.0f)];
    appointLabel.font = [UIFont systemFontOfSize:14.0f];
    appointLabel.textColor = kBaseLightGrayColor;
    appointLabel.text = @"免预约";
    appointLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:appointLabel];
    objc_setAssociatedObject(self, &ApointSupportInfoKey, appointLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *soldLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint+60.0f, ypoint+5.0f, width, 25.0f)];
    soldLabel.font = [UIFont systemFontOfSize:14.0f];
    soldLabel.textColor = kBaseGreenColor;
    soldLabel.text = @"已售87934";
    soldLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:soldLabel];
    objc_setAssociatedObject(self, &SoldCountInfoKey, soldLabel, OBJC_ASSOCIATION_ASSIGN);
}

///点击收藏按钮
#pragma mark - 点赞事件
- (void)addInsteretedMerchant:(SINGLETAP_IMAGEVIEW_ACTIONTYPE)actionType
{

    ///判断是否已登录
    BOOL isLogin = [self checkIsLogin:nil and:nil callBack:^(LOGINVIEW_STATUS status) {
        
        ///登录成功后刷新数据
        if (status == LOGINVIEW_STATUS_SUCCESS) {
            
            UIScrollView *scrollView = objc_getAssociatedObject(self, &DetailInfoRootView);
            [scrollView headerBeginRefreshing];
            
        }
        
    }];
    
    ///收藏
    if (isLogin) {
        
        ///显示HUD
        [QSYCustomHUD showOperationHUD:self.view];
        
        ///判断是否已点赞
        if (_insteretingFlag == 1) {
            
            ///点赞
            [[QSAPIClientBase sharedClient] userDelGood:_prepaidCardID type:kUserGoodType_PrepaidCard success:^(QSAPIModelDict *response) {
                
                ///取消点赞成功
                [self showTip:self.view tipStr:@"已成功取消点赞！"];
                
                ///刷新数据
                UIScrollView *scrollView = objc_getAssociatedObject(self, &DetailInfoRootView);
                [scrollView headerBeginRefreshing];
                
                ///移除HUD
                [QSYCustomHUD hiddenOperationHUD];
                
            } fail:^(NSError *error) {
                
                ///取消点赞失败
                [self showTip:self.view tipStr:@"取消点赞失败，请稍后再试！"];
                
                ///移除HUD
                [QSYCustomHUD hiddenOperationHUD];
                
            }];
            
            return;
        }
        
        if (_insteretingFlag == 0) {
            
            [[QSAPIClientBase sharedClient] userAddGood:_prepaidCardID type:kUserGoodType_PrepaidCard success:^(QSAPIModelDict *response) {
                
                ///成功
                [self showTip:self.view tipStr:@"点赞成功！"];
                
                ///刷新数据
                UIScrollView *scrollView = objc_getAssociatedObject(self, &DetailInfoRootView);
                [scrollView headerBeginRefreshing];
                
                ///移聊HUD
                [QSYCustomHUD hiddenOperationHUD];
                
            } fail:^(NSError *error) {
                
                ///失败
                [self showTip:self.view tipStr:@"点赞失败！"];
                
                ///移除HUD
                [QSYCustomHUD hiddenOperationHUD];
                
            }];
            
            return;
        }
        
    }

}

//*******************************************
//             进入提交订单页面
//*******************************************
#pragma mark - 进入提交订单页面
- (void)gotoOrderFormVC
{
    
    QSOrderFormViewController *src = [[QSOrderFormViewController alloc] initWithOrderFormModel:self.prepaidCardDataModel];
    [self.navigationController pushViewController:src animated:YES];
    
}

//*******************************************
//             使用介绍/知悉/评价回调
//*******************************************
#pragma mark - 使用介绍/知悉/评价回调
- (void)prepaidDetailInstructionAction:(PREPAIDCARD_DETAIL_TABBAR_CALLBACKTYPE)actionType
{
    switch (actionType) {
            //商家介绍
        case FIRST_BUTTON_PDTC:
        {
            
            QSMerchantIndexViewController *marDetail = [[QSMerchantIndexViewController alloc] init];
            marDetail.merchant_id = _marchantID;
            [self.navigationController pushViewController:marDetail animated:YES];
            
        }
            break;
            
        case SECONDE_BUTTON_PDTC:
        {
            
            ///优惠详情
            QSFavourableDetailViewController *src = [[QSFavourableDetailViewController alloc] init];
            [self.navigationController pushViewController:src animated:YES];
            
        }
            break;
            
        case THIRD_BUTTON_PDTC:
        {
            
            ///使用须知
            QSUseNoticeViewController *src = [[QSUseNoticeViewController alloc] initWithDataModel:self.prepaidCardDataModel];
            [self.navigationController pushViewController:src animated:YES];
            
        }
            break;
            
        case FOUR_BUTTON_PDTC:
        {
            
            ///查看地图
            QSMapNavViewController *viewVC = [[QSMapNavViewController alloc] init];
            QSMerchantListReturnData *info = [[QSMerchantListReturnData alloc] init];
            QSMerchantDetailData *merchantModel = [[QSMerchantDetailData alloc] init];
            
            ///获取商户信息
            NSDictionary *merchantBaseInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantTempInfo"];
            
            ///设置商户相关的信息
            merchantModel.latitude = [merchantBaseInfoDict objectForKey:@"merchantLat"];
            merchantModel.longitude = [merchantBaseInfoDict objectForKey:@"merchantLong"];
            merchantModel.merchant_name = [merchantBaseInfoDict objectForKey:@"merchantName"];
            merchantModel.merchant_id = _marchantID;
            merchantModel.address = [merchantBaseInfoDict objectForKey:@"merchantAddress"];
            
            NSMutableArray *data = [[NSMutableArray alloc] init];
            [data addObject:merchantModel];
            info.msg = data;
            viewVC.merchantListReturnData = info;
            [self.navigationController pushViewController:viewVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

/**
 *  @author yangshengmeng, 14-12-12 11:12:46
 *
 *  @brief  请求商户储值卡信息
 *
 *  @since  2.0
 */
#pragma mark - 请求商户储值卡信息
- (void)requestMarchantCardDetailInfo
{
    ///延迟0.22秒后再刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///封装参数
        NSDictionary *params = @{@"id":_prepaidCardID,@"type":[NSString stringWithFormat:@"%d",PREPAIDCARD_MCT]};
        
        ///请求优惠详情
        [[QSAPIClientBase sharedClient] getCouponDetailWithID:params andCallBack:^(BOOL requestFlag, QSYCouponDetailDataModel *model, NSString *errorInfo, NSString *errorCode) {
            
            ///判断成功与否
            if (!requestFlag) {
                
                ///弹出请求失败说明
                [self showTip:self.view tipStr:@"储值卡详情请求失败"];
                NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,errorInfo);
                
            }
            
            ///请求成功进入刷新UI
            self.prepaidCardDataModel = model;
            [self updatePrepaidCardDetailUI:model];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///结束刷新动画
                [self endHeaderRequestAnimination];
                
            });
            
        }];
        
    });
}

/**
 *  @author yangshengmeng, 14-12-12 12:12:24
 *
 *  @brief  结束头部刷新动画
 *
 *  @since  2.0
 */
- (void)endHeaderRequestAnimination
{
    
    UIScrollView *scrollView = objc_getAssociatedObject(self, &DetailInfoRootView);
    [scrollView headerEndRefreshing];
    
}

/**
 *  @author             yangshengmeng, 14-12-12 12:12:44
 *
 *  @brief              刷新储值卡详情信息
 *
 *  @param cardModel    储值卡详情数据模型
 *
 *  @since              2.0
 */
#pragma mark - 刷新储值卡详情信息
- (void)updatePrepaidCardDetailUI:(QSYCouponDetailDataModel *)cardModel
{
    
    ///更新商户信息
    [self updateMarchantBaseInfo:cardModel.marchantBaseInfoModel];
    
    ///更新点赞图标
    [self updateInterestingFlag:cardModel.currentUserInterestedStatus];
    
    ///更新现价
    [self updateCurrentSalePrice:cardModel.prepaidCardBuyPrice];
    
    ///更新储值卡原价
    [self updateOriginalPrice:cardModel.prepaidCardValuePrice];
    
    ///更新简单说明信息
    [self updateSimpleComment:cardModel.couponName];
    
    ///更新已售
    [self updateSoldNumberCount:cardModel.sumNumOfCoupon andLeft:cardModel.leftNumOfCoupon];
    
    ///更新附近条件
    [self updateOtherInfo:cardModel.cardInfoList];
    
    ///显示底view
    UIView *rootView = objc_getAssociatedObject(self, &DetailInfoRootView);
    if (rootView) {
        rootView.hidden = NO;
    }
    
}

/**
 *  @author         yangshengmeng, 14-12-12 14:12:30
 *
 *  @brief          更新退款、预约、过期说明
 *
 *  @param array    状态数据
 *
 *  @since          2.0
 */
- (void)updateOtherInfo:(NSArray *)array
{
    
    for (NSString *obj in array) {
        
        ///获取状态码
        int index = [obj intValue];
        
        ///判断是否免预约
        if (index == 1) {
            [self choiceUnneedBook];
        }
        
        ///判断是否随时可退款
        if (index == 2) {
            [self choiceWheneverRefund];
        }
        
        ///判断是否支持过期自动退款
        if (index == 3) {
            [self choiceEpiredRefund];
        }
        
    }
}

/**
 *  @author yangshengmeng, 14-12-12 15:12:31
 *
 *  @brief  将过期自动退款高亮，表示当前储值卡支持过期自动退款
 *
 *  @since  2.0
 */
- (void)choiceEpiredRefund
{
    UILabel *appointMentLabel = objc_getAssociatedObject(self, &OverTimeSupportInfoKey);
    appointMentLabel.textColor = kBaseGreenColor;
    
    ///更新图标
    UIImageView *imageView = (UIImageView *)[appointMentLabel.superview viewWithTag:TAG_PREPAIDCARD_DETAIL_SUPPORT_LOGO_ROOT+2];
    imageView.image = [UIImage imageNamed:@"prepaid_detail_otherinfo_haved"];
}

/**
 *  @author yangshengmeng, 14-12-12 15:12:31
 *
 *  @brief  将随时可退款高亮，表示当前储值卡支持随时退款
 *
 *  @since  2.0
 */
- (void)choiceWheneverRefund
{
    UILabel *appointMentLabel = objc_getAssociatedObject(self, &SupportInfoKey);
    appointMentLabel.textColor = kBaseGreenColor;
    
    ///更新图标
    UIImageView *imageView = (UIImageView *)[appointMentLabel.superview viewWithTag:TAG_PREPAIDCARD_DETAIL_SUPPORT_LOGO_ROOT+0];
    imageView.image = [UIImage imageNamed:@"prepaid_detail_otherinfo_haved"];
}

/**
 *  @author yangshengmeng, 14-12-12 15:12:30
 *
 *  @brief  免预约高亮，表示当前储值卡的使用免预约
 *
 *  @since  2.0
 */
- (void)choiceUnneedBook
{
    UILabel *appointMentLabel = objc_getAssociatedObject(self, &ApointSupportInfoKey);
    appointMentLabel.textColor = kBaseGreenColor;
    
    ///更新图标
    UIImageView *imageView = (UIImageView *)[appointMentLabel.superview viewWithTag:TAG_PREPAIDCARD_DETAIL_SUPPORT_LOGO_ROOT+1];
    imageView.image = [UIImage imageNamed:@"prepaid_detail_otherinfo_time"];
}

/**
 *  @author         yangshengmeng, 14-12-12 14:12:10
 *
 *  @brief          更新已售出多少张储值卡数量
 *
 *  @param sumNum   储值卡总数
 *  @param leftNum  还剩下储值卡数量
 *
 *  @since          2.0
 */
- (void)updateSoldNumberCount:(NSString *)sumNum andLeft:(NSString *)leftNum
{
    UILabel *soldLabel = objc_getAssociatedObject(self, &SoldCountInfoKey);
    soldLabel.text = [NSString stringWithFormat:@"已售%d",[sumNum intValue]-[leftNum intValue]];
}

/**
 *  @author         yangshengmeng, 14-12-12 14:12:03
 *
 *  @brief          更新简明说明信息
 *
 *  @param comment  说明信息
 *
 *  @since          2.0
 */
- (void)updateSimpleComment:(NSString *)comment
{
    UILabel *desLabel = objc_getAssociatedObject(self, &PrepaidCardDescriptionKey);
    desLabel.text = comment == nil ? @"暂无……" : comment;
}

/**
 *  @author         yangshengmeng, 14-12-12 14:12:54
 *
 *  @brief          更新储值卡现售价
 *
 *  @param price    现价
 *
 *  @since          2.0
 */
- (void)updateCurrentSalePrice:(NSString *)price
{
    ///格式化字符串
    NSString *newPrice = [NSString stringWithFormat:@"%.2f",[price floatValue]];
    
    ///计算显示当前价钱的长度
    CGFloat width = [newPrice calculateStringHeightByFixedHeight:50.0f andFontSize:67.0f];
    
    ///获取现价label
    UILabel *salePriceLabel = objc_getAssociatedObject(self, &SalePriceKey);
    
    ///重置现价的frame
    CGPoint saleLabelCenter = salePriceLabel.center;
    salePriceLabel.frame = CGRectMake(0.0f, 0.0f, width, 50.0f);
    salePriceLabel.center = saleLabelCenter;
    
    ///更新现价
    salePriceLabel.text = newPrice;
    
    ///重新放置rmb字符的位置
    UILabel *rmbFlag = objc_getAssociatedObject(self, &SalePriceRMBFlagKey);
    rmbFlag.frame = CGRectMake(salePriceLabel.frame.origin.x-15.0f, salePriceLabel.frame.origin.y+salePriceLabel.frame.size.height-15.0f, 15.0f, 10.0f);
}

/**
 *  @author         yangshengmeng, 14-12-12 14:12:24
 *
 *  @brief          更新储值卡价值
 *
 *  @param price    原价
 *
 *  @since          2.0
 */
- (void)updateOriginalPrice:(NSString *)price
{
    UILabel *salePriceLabel = objc_getAssociatedObject(self, &OriginalPrieceKey);
    salePriceLabel.text = [NSString stringWithFormat:@"价值￥%.2f",[price floatValue]];
}

/**
 *  @author     yangshengmeng, 14-12-12 14:12:28
 *
 *  @brief      更新点赞图标，高亮表示当前用户已经点赞，否则未点赞
 *
 *  @param flag 点赞状态：YES-已点赞
 *
 *  @since      2.0
 */
- (void)updateInterestingFlag:(BOOL)flag
{
    if (flag) {
        
        UIImageView *collectView = objc_getAssociatedObject(self, &CollectTipsKey);
        _insteretingFlag = 1;
        collectView.image = [UIImage imageNamed:@"prepaidcard_detail_collect_highlighted"];
        
    } else {
    
        UIImageView *collectView = objc_getAssociatedObject(self, &CollectTipsKey);
        _insteretingFlag = 0;
        collectView.image = [UIImage imageNamed:@"prepaidcard_detail_collect_normal"];
    
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
}

@end
