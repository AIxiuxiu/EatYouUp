//
//  QSYCouponDetailViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSYCouponDetailViewController.h"
#import "QSBlockActionButton.h"
#import "QSImageView.h"
#import "QSPrepaidCardDetailTabbarView.h"
#import "QSMerchantIndexViewController.h"
#import "QSFavourableDetailViewController.h"
#import "QSUseNoticeViewController.h"
#import "QSBlockActionButton.h"
#import "MJRefresh.h"
#import "QSAPIClientBase+CouponDetail.h"
#import "NSString+Name.h"
#import "NSDate+QSDateFormatt.h"
#import "QSAPIClientBase+GetCoupon.h"
#import "QSMapNavViewController.h"
#import "QSAPIModel+Merchant.h"
#import "SocaialManager.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"
#import "QSAPIClientBase+User.h"
#import "QSYCustomHUD.h"

#import <objc/runtime.h>

//#if DEBUG
//    #define __SHOWTEST_BGCOLOR__
//#endif

//关联
static char AllInfoScrollViewKey;   //!<所有信息的底view

static char MarIconKey;             //!<商户图标
static char CollectTipsKey;         //!<点赞图标

static char HeaderMiddleTitleKey;   //!<中间信息key
static char HeaderCouponTypeKey;    //!<优惠券类型名字
static char HeaderCommentKey;       //!<优惠说明信息
static char HeaderActivityTimeKey;  //!<活动时间

static char HeaderAppointmenIcontKey;//!<免预约图标
static char HeaderAppontmentKey;    //!<免预约文字
static char HeaderReceiveCountKey;  //!<已领取的总数

@interface QSYCouponDetailViewController (){
    
    NSString *_marName;                 //!<详情标题：不同的优惠卷，标题不一致
    NSString *_marID;                   //!<商户ID
    MYLUNCHBOX_COUPON_TYPE _couponType; //!<优惠卷类型
    NSString *_couponID;                //!<优惠券ID
    
    CGFloat _headerStartYPoint;         //!<主展示信息头视图内的子视图开始坐标
    
    int _insteretingFlag;               //!<当前用户是否已收藏对应商户的标记
    
}

@property (nonatomic,retain) QSYCouponDetailDataModel *couponDetailModel;//!<优惠详情数据模型

@end

@implementation QSYCouponDetailViewController

/**
 *  @author             yangshengmeng, 14-12-09 23:12:19
 *
 *  @brief              初始化优惠卷详情页面，需要传入优惠卷类型才能创建有效详情页
 *
 *  @param marName      优惠卷提供的商户
 *  @param couponType   优惠卷类型
 *
 *  @return             返回对应优惠卷类型
 *
 *  @since              2.0
 */
#pragma mark - 初始化优惠卷详情页面
- (instancetype)initWithMarName:(NSString *)marName andMarchantID:(NSString *)marchantID andCouponID:(NSString *)couponID andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType
{
    if (self = [super init]) {
        
        //保存商家名
        _marName = [marName copy];
        
        ///保存商家ID
        _marID = [marchantID copy];
        
        ///保存优惠券ID
        _couponID = [couponID copy];
        
        ///保存优惠卷类型
        _couponType = couponType;
        
        ///初始化收藏标记
        _insteretingFlag = -1;
        
    }
    
    return self;
}

///创建导航栏UI
#pragma mark - 创建导航栏UI
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:_marName];
    
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

///创建主展示信息UI
#pragma mark - 创建主展示信息UI
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
#ifdef __SHOWTEST_BGCOLOR__
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
        
        [self prepaidDetailShareAction:actionType];
        
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
    [self.view addSubview:infoView];
    [self.view sendSubviewToBack:infoView];
    infoView.hidden = YES;
    [infoView addHeaderWithTarget:self action:@selector(couponDetailDataRequest)];
    [infoView headerBeginRefreshing];
    objc_setAssociatedObject(self, &AllInfoScrollViewKey, infoView, OBJC_ASSOCIATION_ASSIGN);
    
    ///头信息
    QSImageView *headerView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, infoView.frame.size.width, 376.0f)];
    headerView.image = [UIImage imageNamed:@"prepaidcard_detail_header_bg"];
    [infoView addSubview:headerView];
    
    ///创建头信息视图
    [self createMainInfoViewHeaderViewUI:headerView andYPoint:30.0f];
    
    ///底部tabBar
    CGFloat verliticalYPoint = headerView.frame.origin.y+headerView.frame.size.height+10.0f;
    CGFloat bottomYPoint = infoView.frame.size.height-83.0f;
    QSPrepaidCardDetailTabbarView *tabbarView = [[QSPrepaidCardDetailTabbarView alloc] initWithFrame:CGRectMake(0.0f, bottomYPoint > verliticalYPoint ? bottomYPoint : verliticalYPoint, infoView.frame.size.width, 63.0f) andCallBack:^(PREPAIDCARD_DETAIL_TABBAR_CALLBACKTYPE actionType) {
        
        [self bottomTabbarCallBackAction:actionType];
        
    }];
    [infoView addSubview:tabbarView];
    
    //设置是否可以滚动
    if ((tabbarView.frame.origin.y+tabbarView.frame.size.height+15.0f) > infoView.frame.size.height) {
        infoView.contentSize = CGSizeMake(infoView.frame.size.width, tabbarView.frame.origin.y+tabbarView.frame.size.height+15.0f);
    }
    
}

/**
 *  @author         yangshengmeng, 14-12-12 09:12:23
 *
 *  @brief          创建优惠券基本信息显示UI
 *
 *  @param view     信息显示控件所在的父视图
 *  @param ypoint   在父视图中的开始位置
 *
 *  @since          2.0
 */
#pragma mark - 添加头信息显示UI
- (void)createMainInfoViewHeaderViewUI:(UIView *)view andYPoint:(CGFloat)ypoint
{
    UILabel *middleTextLabel = [[UILabel alloc] init];
    middleTextLabel.textColor = kBaseOrangeColor;
    middleTextLabel.font = [UIFont boldSystemFontOfSize:67.0f];
    middleTextLabel.adjustsFontSizeToFitWidth = YES;
    middleTextLabel.text = @"50.00";
    
    /* 要实现自动布局，必须把该属性设置为NO */
    middleTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    /* 添加约束条件前一定要先将控件添加到view */
    [view addSubview:middleTextLabel];
    objc_setAssociatedObject(self, &HeaderMiddleTitleKey, middleTextLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///人民币符号或者折的添加
    [self createPriceTitleWithType:middleTextLabel andSuperView:view];
    
    ///券类型
    UILabel *couponName = [[UILabel alloc] init];
    couponName.text = @"代金券";
    couponName.textColor = [UIColor whiteColor];
    couponName.backgroundColor = kBaseOrangeColor;
    couponName.font = [UIFont systemFontOfSize:18.0f];
    couponName.textAlignment = NSTextAlignmentCenter;
    couponName.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:couponName];
    objc_setAssociatedObject(self, &HeaderCouponTypeKey, couponName, OBJC_ASSOCIATION_ASSIGN);
    
    ///说明信息label
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.text = @"XXXX券20元，无需预约节假日通用全场能用，免费停车！";
    commentLabel.font = [UIFont systemFontOfSize:14.0f];
    commentLabel.textColor = kBaseGrayColor;
    commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    commentLabel.numberOfLines = 2;
    [view addSubview:commentLabel];
    objc_setAssociatedObject(self, &HeaderCommentKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///其他信息的底view
    UIView *otherInfoView = [[UIView alloc] init];
    otherInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:otherInfoView];
    
    ///添加附加条件信息
    [self createHeaderOtherInfoUI:otherInfoView];
    
    ///VFL字符串
    CGFloat maxWidth = DeviceWidth-60.0f;
    NSString *couponNameHVFL = @"H:[couponName(>=120,<=160)]";
    NSString *commentHVFL = @"H:[commentLabel(>=240@720,<=maxWidth)]";
    NSString *middleTipsHVFL = @"H:[middleTextLabel(<=maxWidth)]";
    NSString *otherInfoRootViewHVFL = @"H:[otherInfoView(==commentLabel)]";
    ///垂直方向布局VFL
    NSString *verMiddelInfoVFL = @"V:|-90-[middleTextLabel]-5-[couponName(==30)]-10-[commentLabel]-15-[otherInfoView(>=25)]";
    
    /**
     *  水平方向约束
     */
    ///添加券名label
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:middleTipsHVFL options:0 metrics:@{@"maxWidth":[NSString stringWithFormat:@"%.2f",maxWidth]} views:NSDictionaryOfVariableBindings(middleTextLabel)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:middleTextLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    ///优惠券类型名字label
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:couponNameHVFL options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(couponName)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:couponName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    ///添加说明信息label
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:commentHVFL options:NSLayoutFormatAlignAllCenterX metrics:@{@"maxWidth":[NSString stringWithFormat:@"%.2f",maxWidth]} views:NSDictionaryOfVariableBindings(commentLabel)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:commentLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    ///添加其他信息的底View
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:otherInfoRootViewHVFL options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(otherInfoView,commentLabel)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:otherInfoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    /*
     *  垂直方向的约束
     */
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verMiddelInfoVFL options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(middleTextLabel,couponName,commentLabel,otherInfoView)]];
    
    ///优惠券名字的label圆角
    [couponName roundCornerRadius:15.0f];
    couponName.layer.masksToBounds = YES;
    
}

/**
 *  @author             yangshengmeng, 14-12-16 10:12:06
 *
 *  @brief              根据类型创建价格头信息UI
 *
 *  @param priceLabel   中间信息的视图关键字
 *
 *  @since              2.0
 */
- (void)createPriceTitleWithType:(UILabel *)priceLabel andSuperView:(UIView *)view
{
    
    switch (_couponType) {
            
            ///代金卷
        case VOUCHER_MCT:
        {
        
            ///前面的rmb符号
            UILabel *rmbFlagLabel = [[UILabel alloc] init];
            rmbFlagLabel.text = @"￥";
            rmbFlagLabel.textColor = kBaseOrangeColor;
            [view addSubview:rmbFlagLabel];
            ///取消自动配置
            rmbFlagLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            ///约束vfl
            NSString *middleViewVFL = @"H:[rmbFlagLabel][priceLabel]";
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:middleViewVFL options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(priceLabel,rmbFlagLabel)]];
            
        }
            break;
            
            ///限时免费
        case TIMELIMITEDOFF_MCT:
            
            
            ///折扣卷
        case FASTENING_VOLUME_MCT:
            
            
            ///会员优惠
        case MEMBERDISCOUNT_MCT:
        {
            
            ///前面的rmb符号
            UILabel *rmbFlagLabel = [[UILabel alloc] init];
            rmbFlagLabel.text = @"折";
            rmbFlagLabel.textColor = kBaseOrangeColor;
            [view addSubview:rmbFlagLabel];
            ///取消自动配置
            rmbFlagLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            ///约束vfl
            NSString *middleViewVFL = @"H:[priceLabel][rmbFlagLabel]";
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:middleViewVFL options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(priceLabel,rmbFlagLabel)]];
            
        }
            
            break;
            
        default:
        {
            
            ///约束vfl
            NSString *middleViewVFL = @"H:[priceLabel]";
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:middleViewVFL options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(priceLabel)]];
            
        }
            break;
    }
}

/**
 *  @author         yangshengmeng, 14-12-16 12:12:15
 *
 *  @brief          添加头信息中的：优惠券使用基本条件，或者活动日期信息UI
 *
 *  @param topLabel 说明信息的Label，方便进行适应
 *  @param view     所在的父视图
 *
 *  @since          2.0
 */
- (void)createHeaderOtherInfoUI:(UIView *)view
{
    
    /**
     *
     *  根据不同的优惠类型，添加不同的条件信息，或日期
     *
     */
    
    switch (_couponType) {
            
            ///限时和会员优惠，显示活动日期
        case TIMELIMITEDOFF_MCT:
            
        case MEMBERDISCOUNT_MCT:
        {
            
            UILabel *activityDateLabel = [[UILabel alloc] init];
            activityDateLabel.text = @"2014-11-20至2016-12-31";
            activityDateLabel.textColor = kBaseLightGrayColor;
            activityDateLabel.font = [UIFont systemFontOfSize:12.0f];
            activityDateLabel.textAlignment = NSTextAlignmentCenter;
            activityDateLabel.layer.borderColor = [kBaseLightGrayColor CGColor];
            activityDateLabel.layer.borderWidth = 0.5f;
            [activityDateLabel roundCornerRadius:6.0f];
            activityDateLabel.layer.masksToBounds = YES;
            activityDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:activityDateLabel];
            objc_setAssociatedObject(self, &HeaderActivityTimeKey, activityDateLabel, OBJC_ASSOCIATION_ASSIGN);
            
            ///水平
            NSString *hVFLActivityDate = @"H:|[activityDateLabel(==view)]";
            NSString *vVFLActivityDate = @"V:|[activityDateLabel(==view)]";
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hVFLActivityDate options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(activityDateLabel,view)]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vVFLActivityDate options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(activityDateLabel,view)]];
            
        }
            break;
            
            ///代金券
        case VOUCHER_MCT:
            
            ///兑换券
        case EXCHANGE_VOLUME_MCT:
            
        case FASTENING_VOLUME_MCT:
        {
            
            ///免预约
            UIImageView *apointmentIcon = [[UIImageView alloc] init];
            apointmentIcon.image = [UIImage imageNamed:@"prepaid_detail_otherinfo_unhaved"];
            apointmentIcon.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:apointmentIcon];
            objc_setAssociatedObject(self, &HeaderAppointmenIcontKey, apointmentIcon, OBJC_ASSOCIATION_ASSIGN);
            
            UILabel *appointmentLabel = [[UILabel alloc] init];
            appointmentLabel.text = @"免预约";
            appointmentLabel.font = [UIFont systemFontOfSize:14.0f];
            appointmentLabel.textColor = kBaseLightGrayColor;
            appointmentLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:appointmentLabel];
            objc_setAssociatedObject(self, &HeaderAppontmentKey, appointmentLabel, OBJC_ASSOCIATION_ASSIGN);
            
            ///分隔线
            UILabel *sepLabel = [[UILabel alloc] init];
            sepLabel.backgroundColor = kBaseLightGrayColor;
            sepLabel.alpha = 0.5f;
            sepLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:sepLabel];
            
            ///已领取数量
            UIImageView *receiCountIcon = [[UIImageView alloc] init];
            receiCountIcon.image = [UIImage imageNamed:@"prepaid_detail_otherinfo_sold"];
            receiCountIcon.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:receiCountIcon];
            
            UILabel *receiCountLabel = [[UILabel alloc] init];
            receiCountLabel.text = @"已领取763";
            receiCountLabel.font = [UIFont systemFontOfSize:14.0f];
            receiCountLabel.textColor = kBaseGreenColor;
            receiCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:receiCountLabel];
            objc_setAssociatedObject(self, &HeaderReceiveCountKey, receiCountLabel, OBJC_ASSOCIATION_ASSIGN);
            
            ///水平约束字符串
            NSString *__hVFLString = @"H:[apointmentIcon(iconHeight)]-5-[appointmentLabel]-30-[sepLabel(0.5)]-30-[receiCountIcon(iconHeight)]-5-[receiCountLabel]";
            
            ///图标高度的约束
            NSString *__vVFL_icon_appString = @"V:|[apointmentIcon(iconHeight)]";
            NSString *__vVFL_icon_receiString = @"V:|[receiCountIcon(iconHeight)]";
            
            ///垂直约束字符串
            NSString *__vVFLString = @"V:|[sepLabel(==view)]";
            
            ///让分隔线居中
            [view addConstraint:[NSLayoutConstraint constraintWithItem:sepLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
            
            ///参数字典
            NSDictionary *__metricsDict = @{@"iconHeight":@"20"};
            
            ///添加水平约束
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:__hVFLString options:NSLayoutFormatAlignAllCenterY metrics:__metricsDict views:NSDictionaryOfVariableBindings(apointmentIcon,appointmentLabel,sepLabel,receiCountIcon,receiCountLabel)]];
            
            ///添加图标的垂直结束
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:__vVFL_icon_appString options:0 metrics:__metricsDict views:NSDictionaryOfVariableBindings(apointmentIcon)]];
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:__vVFL_icon_receiString options:0 metrics:__metricsDict views:NSDictionaryOfVariableBindings(receiCountIcon)]];
            
            ///添加垂直约束
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:__vVFLString options:0 metrics:__metricsDict views:NSDictionaryOfVariableBindings(sepLabel,view)]];
            
            ///添加领取按钮
            UIView *headerView = [view superview];
            UIButton *receiveButton = [UIButton createBlockActionButton:nil andCallBack:^(UIButton *button) {
                
                ///领取优惠券
                [self getCoupon];
                
            }];
            receiveButton.backgroundColor = kBaseGreenColor;
            receiveButton.layer.cornerRadius = 18.0f;
            [receiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [receiveButton setTitle:@"立即领取" forState:UIControlStateNormal];
            receiveButton.translatesAutoresizingMaskIntoConstraints = NO;
            headerView.userInteractionEnabled = YES;
            [headerView addSubview:receiveButton];
            
            ///按钮水平约束
            NSString *__hVFL_receiveButton = @"H:|-10-[receiveButton]-10-|";
            NSString *__vVFL_receiveButton = @"V:[receiveButton(36)]-35-|";
            
            ///添加约束
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:__hVFL_receiveButton options:0 metrics:nil views:NSDictionaryOfVariableBindings(receiveButton)]];
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:__vVFL_receiveButton options:0 metrics:nil views:NSDictionaryOfVariableBindings(receiveButton)]];
            
        }
            break;
            
        default:
            break;
    }
    
}

/**
 *  @author yangshengmeng, 14-12-09 23:12:19
 *
 *  @brief  点击收藏
 *
 *  @param actionType 点击的类型
 *
 *  @since 2.0
 */
#pragma mark -  点赞
- (void)prepaidDetailShareAction:(SINGLETAP_IMAGEVIEW_ACTIONTYPE)actionType
{
    
    ///判断是否已登录
    BOOL isLogin = [self checkIsLogin:nil and:nil callBack:^(LOGINVIEW_STATUS status) {
        
        ///登录成功后刷新数据
        if (status == LOGINVIEW_STATUS_SUCCESS) {
            
            UIScrollView *scrollView = objc_getAssociatedObject(self, &AllInfoScrollViewKey);
            [scrollView headerBeginRefreshing];
            
        }
        
    }];
    
    ///收藏
    if (isLogin) {
        
        ///显示HUD
        [QSYCustomHUD showOperationHUD:self.view];
        
        ///判断是否已点赞
        if (_insteretingFlag == 1) {
            
            ///2：菜品 3：优惠卷 4：促销
            [[QSAPIClientBase sharedClient] userDelGood:_couponID type:[self getCouponGoodType] success:^(QSAPIModelDict *response) {
                
                ///取消点赞成功
                [self showTip:self.view tipStr:@"已成功取消点赞！"];
                
                ///刷新数据
                UIScrollView *scrollView = objc_getAssociatedObject(self, &AllInfoScrollViewKey);
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
            
            [[QSAPIClientBase sharedClient] userAddGood:_couponID type:[self getCouponGoodType] success:^(QSAPIModelDict *response) {
                
                ///成功
                [self showTip:self.view tipStr:@"点赞成功！"];
                
                ///刷新数据
                UIScrollView *scrollView = objc_getAssociatedObject(self, &AllInfoScrollViewKey);
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

///返回当前优惠券的点赞类型
- (kUserGoodType)getCouponGoodType
{

    switch (_couponType) {
            
        case PREPAIDCARD_MCT:
            
            return kUserGoodType_PrepaidCard;
            
            break;
            
        case FASTENING_VOLUME_MCT:
            
        case EXCHANGE_VOLUME_MCT:
            
        case VOUCHER_MCT:
            
            return kUserGoodType_Coupon;
            
            break;
            
        case TIMELIMITEDOFF_MCT:
            
            return kUserGoodType_Discount;
            
            break;
            
        case FOODOFF_MCT:
            
            return kUserGoodType_Food;
            
            break;
            
        case MEMBERDISCOUNT_MCT:
            
            return kUserGoodType_Discount;
            
            break;
            
        default:
            
            break;
    }
    
    return kUserGoodType_Food;

}

/**
 *  @author             yangshengmeng, 14-12-10 00:12:42
 *
 *  @brief              点击：使用介绍/知悉/评价/定位回调
 *
 *  @param actionType   回调的类型：表示当前按下哪个按钮
 *
 *  @since              2.0
 */
#pragma mark - 点击：使用介绍/知悉/评价/定位回调
- (void)bottomTabbarCallBackAction:(PREPAIDCARD_DETAIL_TABBAR_CALLBACKTYPE)actionType
{
    switch (actionType) {
            //商家介绍
        case FIRST_BUTTON_PDTC:
        {
            
            QSMerchantIndexViewController *marDetail = [[QSMerchantIndexViewController alloc] init];
            marDetail.merchant_id = _marID;
            [self.navigationController pushViewController:marDetail animated:YES];
            
        }
            break;
            
        case SECONDE_BUTTON_PDTC:
        {
            ///详情
            QSFavourableDetailViewController *src = [[QSFavourableDetailViewController alloc] initWithDetailComment:self.couponDetailModel.des];
            [self.navigationController pushViewController:src animated:YES];
            
        }
            break;
            
        case THIRD_BUTTON_PDTC:
        {
            ///使用须知
            QSUseNoticeViewController *src = [[QSUseNoticeViewController alloc] initWithDataModel:self.couponDetailModel];
            [self.navigationController pushViewController:src animated:YES];
        }
            break;
            
        case FOUR_BUTTON_PDTC:
        {
            
            ///定位
            QSMapNavViewController *viewVC = [[QSMapNavViewController alloc] init];
            QSMerchantListReturnData *info = [[QSMerchantListReturnData alloc] init];
            QSMerchantDetailData *merchantModel = [[QSMerchantDetailData alloc] init];
            
            ///获取商户信息
            NSDictionary *merchantBaseInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantTempInfo"];
            
            ///设置商户相关的信息
            merchantModel.latitude = [merchantBaseInfoDict objectForKey:@"merchantLat"];
            merchantModel.longitude = [merchantBaseInfoDict objectForKey:@"merchantLong"];
            merchantModel.merchant_name = [merchantBaseInfoDict objectForKey:@"merchantName"];
            merchantModel.merchant_id = _marID;
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
        NSDictionary *params = @{@"id":_couponID,@"type":[NSString stringWithFormat:@"%d",_couponType]};
        
        ///请求优惠详情
        [[QSAPIClientBase sharedClient] getCouponDetailWithID:params andCallBack:^(BOOL requestFlag, QSYCouponDetailDataModel *model, NSString *errorInfo, NSString *errorCode) {
            
            ///判断成功与否
            if (!requestFlag) {
                
                ///弹出请求失败说明
                [self showTip:self.view tipStr:@"优惠详情请求失败"];
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
 *  @author yangshengmeng, 14-12-17 11:12:20
 *
 *  @brief  更新优惠详情
 *
 *  @since  2.0
 */
#pragma mark - 更新优惠详情
- (void)updateCouponDetailUI:(QSYCouponDetailDataModel *)cardModel
{
    
    ///更新商户信息
    [self updateMarchantBaseInfo:cardModel.marchantBaseInfoModel];
    
    ///更新点赞图标
    [self updateInterestingFlag:cardModel.currentUserInterestedStatus];
    
    ///更新中间信息
    [self updateMiddleTipsLabel:[self getTipsStringWithModel:cardModel]];
    
    ///更新简明说明
    [self updateSimpleComment:cardModel.des];
    
    ///更新已售数量
    [self updateSoldNumberCount:cardModel.sumNumOfCoupon andLeft:cardModel.leftNumOfCoupon];
    
    ///更新活动日期
    [self updateLimitedDate:[self formatActivityDate:cardModel.startTime andEndTime:cardModel.lastTime]];
    
    ///更新是否免预约
    [self updateOtherInfo:cardModel.cardInfoList];
    
    ///显示底view
    UIView *rootView = objc_getAssociatedObject(self, &AllInfoScrollViewKey);
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
        
    }
}

/**
 *  @author yangshengmeng, 14-12-11 13:12:55
 *
 *  @brief  更新活动日期
 *
 *  @param  dateString 日期
 *
 *  @since  2.0
 */
- (void)updateLimitedDate:(NSString *)dateString
{
    if (dateString) {
        UILabel *dateLabel = objc_getAssociatedObject(self, &HeaderActivityTimeKey);
        dateLabel.text = dateString;
    }
}

/**
 *  @author             yangshengmeng, 14-12-17 20:12:45
 *
 *  @brief              格式化活动日期
 *
 *  @param startTime    开始时间
 *  @param endTime      结束时间
 *
 *  @return             返回活动日期
 *
 *  @since              2.0
 */
- (NSString *)formatActivityDate:(NSString *)startTime andEndTime:(NSString *)endTime
{
    
    return [NSString stringWithFormat:@"%@至%@",[NSDate formatIntegerIntervalToDateString:startTime],[NSDate formatIntegerIntervalToDateString:endTime]];
    
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

    UILabel *appointMentLabel = objc_getAssociatedObject(self, &HeaderAppontmentKey);
    
    if (!appointMentLabel) {
        return;
    }
    
    appointMentLabel.textColor = kBaseGreenColor;
    
    ///更新图标
    UIImageView *imageView = objc_getAssociatedObject(self, &HeaderAppointmenIcontKey);
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

    UILabel *soldLabel = objc_getAssociatedObject(self, &HeaderReceiveCountKey);
    NSString *tipsString = (_couponType == VOUCHER_MCT) ? @"已领取" : @"已售";
    soldLabel.text = [NSString stringWithFormat:@"%@%d",tipsString,[sumNum intValue]-[leftNum intValue]];

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

    UILabel *desLabel = objc_getAssociatedObject(self, &HeaderCommentKey);
    desLabel.text = comment == nil ? @"暂无……" : comment;

}

/**
 *  @author         yangshengmeng, 14-12-12 14:12:54
 *
 *  @brief          中间信息：折扣、金额、菜口优惠标题
 *
 *  @param price    现价
 *
 *  @since          2.0
 */
- (void)updateMiddleTipsLabel:(NSString *)tips
{
    
    ///获取现价label
    UILabel *salePriceLabel = objc_getAssociatedObject(self, &HeaderMiddleTitleKey);
    
    ///更新现价
    salePriceLabel.text = tips;
    
}

/**
 *  @author         yangshengmeng, 14-12-17 14:12:21
 *
 *  @brief          更新优惠券类型名字
 *
 *  @param typeName 类型名字
 *
 *  @since          2.0
 */
- (void)updateCouponTypeLabelText:(NSString *)typeName
{
    UILabel *typeLabel = objc_getAssociatedObject(self, &HeaderCouponTypeKey);
    typeLabel.text = typeName;
}

/**
 *  @author         yangshengmeng, 14-12-17 11:12:06
 *
 *  @brief          根据优惠类型返回中间信息
 *
 *  @param model    优惠券类型
 *
 *  @since          2.0
 */
- (NSString *)getTipsStringWithModel:(QSYCouponDetailDataModel *)model
{
    
    switch (_couponType) {
            
            ///菜品兑换券
        case EXCHANGE_VOLUME_MCT:
            
            [self updateCouponTypeLabelText:@"兑换券"];
            return model.couponName;
            
            break;
            
            ///代金券
        case VOUCHER_MCT:
            
            [self updateCouponTypeLabelText:@"代金券"];
            return [NSString stringWithFormat:@"%.2f", [model.coucherValue floatValue]];
            
            break;
            
            ///折扣券
        case FASTENING_VOLUME_MCT:
            
            [self updateCouponTypeLabelText:@"折扣券"];
            return [model.foodOfferDiscount formatDiscountWithPercent:model.foodOfferDiscount];
            
            break;
            
            ///限时优惠
        case TIMELIMITEDOFF_MCT:
            
            [self updateCouponTypeLabelText:@"限时优惠"];
            return [model.limitedTimeDiscount formatDiscountWithPercent:model.limitedTimeDiscount];
            
            break;
            
            ///会员优惠
        case MEMBERDISCOUNT_MCT:
            
            [self updateCouponTypeLabelText:@"会员优惠"];
            return [model.vipDiscount formatDiscountWithPercent:model.vipDiscount];
            
            break;
            
        default:
            return nil;
            break;
    }
    
    return nil;
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

/**
 *  @author yangshengmeng, 14-12-17 21:12:52
 *
 *  @brief  开始领取优惠券过程，首先判断是否登录，强制要求登录
 *
 *  @since  2.0
 */
#pragma mark - 领取优惠券过程
- (void)getCoupon
{
    
    ///判断是否已登录
    [self checkIsLogin:nil and:nil callBack:^(LOGINVIEW_STATUS loginStatus) {
        
        ///登录成功后进入领取请求
        if (loginStatus) {
            
            ///开始领取
            [[QSAPIClientBase sharedClient] getCouponWithID:self.couponDetailModel.couponID andCallBack:^(BOOL getResult, NSString *errorInfo, NSString *errorCode) {
                
                ///领取成功
                [self showAlertMessageWithTime:1.0f andMessage:(getResult ? @"领取成功！\n可以在[我的餐盒里查看]" : errorInfo) andCallBack:^(CGFloat showTime) {
                    
                    ///提示结束后：如若领取成功，则返回列表，领取失败停在当前页
                    if (getResult) {
                        
                        ///返回优惠券列表
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } else {
                    
                        
                        
                    }
                    
                }];
                
            }];
            
        }
        
    }];
    
}

@end
