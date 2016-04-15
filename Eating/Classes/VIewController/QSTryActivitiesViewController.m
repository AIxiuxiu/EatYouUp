//
//  QSTryActivitiesViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSTryActivitiesViewController.h"
#import "QSAPIClientBase+QSTryActivities.h"
#import "QSBlockActionButton.h"
#import "QSImageView.h"
#import "UIView+UI.h"
#import "QSAPIModel+QSTryActivitiesReturnData.h"
#import "QSJoinActivityViewController.h"
#import "MJRefresh.h"
#import "QSResetImageFrameButton.h"

#import <objc/runtime.h>

//关联
static char HeaderInfoRootViewKey;
static char HeaderImageKey;
static char MarIconKey;
static char MarNameKey;
static char ActivitiesDateKey;
static char LeftDateLogoKey;
static char UserCountLogoKey;
static char ActivitiesLeftDateKey;
static char ActivitiesUserCountKey;
static char ActivitiesDetailKey;
static char RootScrollViewKey;
static char ActivityStatuButtonKey;
static char HeaderSeperatorKey;
@interface QSTryActivitiesViewController ()

@property (nonatomic,copy) NSString *userID;//用户ID
@property (nonatomic,copy) NSString *tryActivitiesID;//试吃活动ID

@end

@implementation QSTryActivitiesViewController

#pragma mark - UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setMiddleTitle:@"试吃活动"];
    
    //设置右按钮
    UIButton *shareButton = [UIButton createBlockActionButton:CGRectMake(0.0f, 0.0f, 16.0f, 16.0f) andStyle:[QSButtonStyleModel createTryActivitiesShareButtonStyle] andCallBack:^(UIButton *button) {
        
    }];
    [self setRightView:shareButton];
}

- (void)createMiddleMainShowView
{
    //取消自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //底view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.height-64.0f)];
    
    //取消滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    //设置透明颜色
    scrollView.backgroundColor = [UIColor clearColor];
    
    //创建子视图
    [self createTryActivitiesShowView:scrollView];
    
    //添加
    [self.view addSubview:scrollView];
    
    //添加头部刷新
    [scrollView addHeaderWithTarget:self action:@selector(requestTryActivitiesData)];
    
    //开始头部刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [scrollView headerBeginRefreshing];
    });
    
    //关联
    objc_setAssociatedObject(self, &RootScrollViewKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
}

//创建展示子视图
- (void)createTryActivitiesShowView:(UIScrollView *)view
{
    //保存整体height
    CGFloat contectHeight = 0.0f;
    
    //头view：997-520+477
    CGFloat width = DeviceWidth;
    CGFloat height = (345.0f / 640.0f) * width;
    QSImageView *headerRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, height+240.0f)];
    //设置背景图片
    headerRootView.image = [UIImage imageNamed:@"fooddetective_tryactivities_header_default_bg"];
    
    //创建头信息子视图
    [self createHeaderSubviews:headerRootView];
    //关联
    objc_setAssociatedObject(self, &HeaderInfoRootViewKey, view, OBJC_ASSOCIATION_ASSIGN);
    
    //加载
    [view addSubview:headerRootView];
    contectHeight = contectHeight + headerRootView.frame.size.height;
    
    //创建详情webView
    UIWebView *detailView = [[UIWebView alloc] initWithFrame:CGRectMake(10.0f, contectHeight+10.0f, view.frame.size.width-20.0f, 35.0f)];
    [view addSubview:detailView];
    objc_setAssociatedObject(self, &ActivitiesDetailKey, detailView, OBJC_ASSOCIATION_ASSIGN);
    detailView.backgroundColor = [UIColor whiteColor];
    
    for (UIView *obj in [detailView subviews]) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)obj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)obj).showsVerticalScrollIndicator = NO;
        }
    }
    
    contectHeight += detailView.frame.size.height;
    
    //重调scrollview的contentSize
    if (contectHeight > view.frame.size.height) {
        view.contentSize = CGSizeMake(view.frame.size.width, contectHeight);
    } else {
        view.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height+5.0f);
    }
}

- (void)createHeaderSubviews:(UIView *)view
{
    //头图片
    CGFloat width = DeviceWidth;
    CGFloat height = (345.0f / 640.0f) * width;
    QSImageView *headerImage = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, height)];
    [view addSubview:headerImage];
    objc_setAssociatedObject(self, &HeaderImageKey, headerImage, OBJC_ASSOCIATION_ASSIGN);
    
    //商店logo
    QSImageView *storeLogoAbove = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width/2.0f-55.0f, height-55.0f, 110.0f, 110.0f)];
    [view addSubview:storeLogoAbove];
    storeLogoAbove.layer.cornerRadius = 55.0f;
    storeLogoAbove.backgroundColor = [UIColor whiteColor];
    
    //MarIconKey
    QSImageView *storeLogon = [[QSImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 100.0f, 100.0f)];
    [storeLogon roundView];
    [storeLogoAbove addSubview:storeLogon];
    objc_setAssociatedObject(self, &MarIconKey, storeLogon, OBJC_ASSOCIATION_ASSIGN);
    
    //store name
    UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, height+60.0f, view.frame.size.width - 40.0f, 20.0f)];
    storeName.font = [UIFont boldSystemFontOfSize:18.0f];
    storeName.textAlignment = NSTextAlignmentCenter;
    storeName.textColor = kBaseOrangeColor;
    [view addSubview:storeName];
//    storeName.adjustsFontSizeToFitWidth = YES;
    objc_setAssociatedObject(self, &MarNameKey, storeName, OBJC_ASSOCIATION_ASSIGN);
    
    //activities time
    UILabel *actTime = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width-223.0f)/2.0f, height+100.0f, 223.0f, 20.0f)];
    actTime.layer.borderColor = [kBaseLightGrayColor CGColor];
    actTime.layer.borderWidth = 1.0f;
    [actTime roundCornerRadius:4.0f];
    actTime.font = [UIFont systemFontOfSize:12.0f];
    actTime.adjustsFontSizeToFitWidth = YES;
    actTime.textAlignment = NSTextAlignmentCenter;
    actTime.textColor = kBaseLightGrayColor;
    [view addSubview:actTime];
    objc_setAssociatedObject(self, &ActivitiesDateKey, actTime, OBJC_ASSOCIATION_ASSIGN);
    
    //left date logon
    QSImageView *leftDateLogo = [[QSImageView alloc] initWithFrame:CGRectMake((view.frame.size.width-223.0f)/2.0f, height+130.0f, 15.0f, 15.0f)];
    leftDateLogo.image = [UIImage imageNamed:@"fooddetective_tryactivities_time"];
    [view addSubview:leftDateLogo];
    objc_setAssociatedObject(self, &LeftDateLogoKey, leftDateLogo, OBJC_ASSOCIATION_ASSIGN);
    
    //left date text:222/2=111-20-6=85
    UILabel *leftDate = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width-223.0f)/2.0f+20.0f, height+130.0f, 85.0f, 15.0f)];
    leftDate.font = [UIFont systemFontOfSize:14.0f];
    leftDate.textAlignment = NSTextAlignmentRight;
    leftDate.textColor = kBaseGreenColor;
    leftDate.adjustsFontSizeToFitWidth = YES;
    [view addSubview:leftDate];
    objc_setAssociatedObject(self, &ActivitiesLeftDateKey, leftDate, OBJC_ASSOCIATION_ASSIGN);
    
    //分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2.0f-0.5f, height+130.0f, 1, 15.0f)];
    sepLabel.backgroundColor = kBaseGrayColor;
    [view addSubview:sepLabel];
    objc_setAssociatedObject(self, &HeaderSeperatorKey, sepLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //user count logon
    QSImageView *userCountLogo = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width/2.0f+6.5f, height+130.0f, 15.0f, 15.0f)];
    userCountLogo.image = [UIImage imageNamed:@"fooddetective_tryactivities_person"];
    [view addSubview:userCountLogo];
    objc_setAssociatedObject(self, &UserCountLogoKey, userCountLogo, OBJC_ASSOCIATION_ASSIGN);
    
    //user count text
    UILabel *userCount = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2.0f+26.5f, height+130.0f, 85.0f, 15.0f)];
    userCount.font = [UIFont systemFontOfSize:14.0f];
    userCount.textAlignment = NSTextAlignmentLeft;
    userCount.textColor = kBaseGreenColor;
    userCount.adjustsFontSizeToFitWidth = YES;
    [view addSubview:userCount];
    objc_setAssociatedObject(self, &ActivitiesUserCountKey, userCount, OBJC_ASSOCIATION_ASSIGN);
    
    //报名活动按钮
    UIButton *signButton = [UIButton createBlockActionButton:CGRectMake(10.0f, height+170.0f, view.frame.size.width-20.0f, 35.0f) andStyle:[QSButtonStyleModel createTryActivitiesSignUpButtonStyle] andCallBack:^(UIButton *button) {
        
        if (button.selected) {
            
            return;
        }
        
#ifdef __CHECK_ISLOGIN__
        //判断是否已登录
        if (![self checkIsLogin]) {
            return;
        }
#endif
        QSJoinActivityViewController *src = [[QSJoinActivityViewController alloc] init];
        [src setValue:_tryActivitiesID forKey:@"activityID"];
        [self.navigationController pushViewController:src animated:YES];
    }];
    objc_setAssociatedObject(self, &ActivityStatuButtonKey, signButton, ActivitiesUserCountKey);
    [view addSubview:signButton];
}

//创建写文章UI
- (void)createWriteArticleUI
{
    //重置UI
    UIImageView *leftDateLogo = objc_getAssociatedObject(self, &LeftDateLogoKey);
    UIImageView *userLogo = objc_getAssociatedObject(self, &UserCountLogoKey);
    UILabel *leftDateLabel = objc_getAssociatedObject(self, &ActivitiesLeftDateKey);
    UILabel *userCount = objc_getAssociatedObject(self, &ActivitiesUserCountKey);
    UIButton *button = objc_getAssociatedObject(self, &ActivityStatuButtonKey);
    UILabel *sepLabel = objc_getAssociatedObject(self, &HeaderSeperatorKey);
    
    //保存y坐标
    CGFloat yLeft = leftDateLogo.frame.origin.y;
    CGFloat yButton = button.frame.origin.y;
    CGFloat widthButton = button.frame.size.width;
    CGFloat heightLeft = leftDateLogo.frame.size.height;
    CGFloat heightButton = button.frame.size.height;
    
    //移除原视图
    [leftDateLogo removeFromSuperview];
    [userLogo removeFromSuperview];
    [leftDateLabel removeFromSuperview];
    [userCount removeFromSuperview];
    [button removeFromSuperview];
    [sepLabel removeFromSuperview];
    
    //取得头view
    UIView *headerRootView = objc_getAssociatedObject(self, &HeaderInfoRootViewKey);
    
    //修改左右图片：tryactivity_sale_highlighted
    UIButton *saleButton = [UIButton createImageAndTitleButton:CGRectMake(DeviceWidth/2.0f - 130.0f, yLeft, 120.0f, heightLeft) andCallBack:^(UIButton *button) {
        
    }];
    [saleButton setTitle:@"查看优惠卷" forState:UIControlStateNormal];
    [saleButton setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
    saleButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [saleButton setImage:[UIImage imageNamed:@"tryactivity_sale_normal"] forState:UIControlStateNormal];
    [saleButton setImage:[UIImage imageNamed:@"tryactivity_sale_highlighted"] forState:UIControlStateHighlighted];
    [headerRootView addSubview:saleButton];
    
    UIButton *phoneButton = [UIButton createImageAndTitleButton:CGRectMake(DeviceWidth/2.0f + 10.0f, yLeft, 120.0f, heightLeft) andCallBack:^(UIButton *button) {
        
    }];
    [phoneButton setTitle:@"发送到手机" forState:UIControlStateNormal];
    [phoneButton setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
    phoneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [phoneButton setImage:[UIImage imageNamed:@"tryactivity_phone_normal"] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"tryactivity_phone_highlighted"] forState:UIControlStateHighlighted];
    [headerRootView addSubview:phoneButton];
    
    //预约商户
    UIButton *orderButton = [UIButton createBlockActionButton:CGRectMake(DeviceWidth/2.0f - widthButton/2.0f, yButton, (widthButton - 10.0f)/2.0f, heightButton) andStyle:[QSButtonStyleModel createTryActivitiesSignUpButtonStyle] andCallBack:^(UIButton *button) {
        
    }];
    [orderButton setTitle:@"预约商户" forState:UIControlStateNormal];
    [headerRootView addSubview:orderButton];
    
    //控店分享
    UIButton *shareButton = [UIButton createBlockActionButton:CGRectMake(DeviceWidth/2.0f + 5.0f, yButton, (widthButton - 10.0f)/2.0f, heightButton) andStyle:[QSButtonStyleModel createTryActivitiesSignUpButtonStyle] andCallBack:^(UIButton *button) {
        
    }];
    [shareButton setTitle:@"探店分享" forState:UIControlStateNormal];
    [headerRootView addSubview:shareButton];
}

//*******************************
//             请求试用活动详情数据
//*******************************
#pragma mark - 请求试用活动详情数据
- (void)requestTryActivitiesData
{
    [[QSAPIClientBase sharedClient] tryActivitiesWithID:self.userID andID:self.tryActivitiesID andSuccessCallBack:^(QSTryActivitiesDataModel *resultModel){
        if (resultModel) {
            [self updateTryActivitiesDetailUI:resultModel];
        }
        //停止刷新动画
        [self endHeaderRefreshAnim];
    } andFailCallBack:^(NSError *error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"试吃活动数据下载失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
        //停止刷新动画
        [self endHeaderRefreshAnim];
    }];
}

//开始头部刷新
- (void)reloadActivityDetailData
{
    UIScrollView *scrollView = objc_getAssociatedObject(self, &RootScrollViewKey);
    [scrollView headerBeginRefreshing];
}

//结束动画
- (void)endHeaderRefreshAnim
{
    UIScrollView *scrollView = objc_getAssociatedObject(self, &RootScrollViewKey);
    [scrollView headerEndRefreshing];
    [scrollView footerEndRefreshing];
}

//*******************************
//             刷新UI
//*******************************
#pragma mark - 刷新UI
- (void)updateTryActivitiesDetailUI:(QSTryActivitiesDataModel *)model
{
    //更新头图片
    [self updateHeaderImage:model.headerImage];
    
    //更新店铺图标
    [self updateStoreLogo:model.marIcon];
    
    //更新店名
    [self updateStoreName:model.marName];
    
    //更新活动时间
    [self updateActivitiesDate:[self formateActivitiesDate:model.startTime andEndDate:model.endTime]];
    
    //更新剩余天数
    [self updateLeftDate:[self caculatorLeftDate:model.endTime]];
    
    //更新名额
    [self updateUserCount:model.joinNum];
    
    //更新详情说明
    [self updateActivitiesDetailInfo:model.activitiesDetail];
    
    //更新活动状态
    [self updateActivityCurrentStatus:model.activityStatu andUserStatus:model.currentUserStatue andISGetStatus:model.isGet];
}

//更新头图片
- (void)updateHeaderImage:(NSString *)urlString
{
    if (urlString) {
        UIImageView *view = objc_getAssociatedObject(self, &HeaderImageKey);
        view.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    }
}

//更新店铺图标
- (void)updateStoreLogo:(NSString *)urlString
{
    if (urlString) {
        UIImageView *view = objc_getAssociatedObject(self, &MarIconKey);
        view.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"default_file_super_url"],urlString]]]];
    }
}

//更新店铺名字
- (void)updateStoreName:(NSString *)name
{
    if (name) {
        UILabel *storeName = objc_getAssociatedObject(self, &MarNameKey);
        storeName.text = name;
    }
}

//更新活动时间
- (void)updateActivitiesDate:(NSString *)actDate
{
    if (actDate) {
        UILabel *actLabel = objc_getAssociatedObject(self, &ActivitiesDateKey);
        actLabel.text = actDate;
    }
}

//活动时间转换
- (NSString *)formateActivitiesDate:(NSString *)startDate andEndDate:(NSString *)endDate
{
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromStartDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[startDate intValue]];
    NSString *startDateString = [formatter stringFromDate:confromStartDate];
    NSDate *confromEndDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[startDate intValue]];
    NSString *endDateString = [formatter stringFromDate:confromEndDate];
    
    return [NSString stringWithFormat:@"%@至%@",startDateString,endDateString];
}

//更新剩余天数
- (void)updateLeftDate:(NSString *)leftDate
{
    if (leftDate) {
        UILabel *leftLabel = objc_getAssociatedObject(self, &ActivitiesLeftDateKey);
        leftLabel.text = leftDate;
    }
}

//计算剩余天数
- (NSString *)caculatorLeftDate:(NSString *)endDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromEndDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[endDate intValue]];
    NSTimeInterval interval = [confromEndDate timeIntervalSinceDate:[NSDate date]];
    
    //如果已过期
    if (interval <= 0.0f) {
        return @"已过期";
    }
    
    //求天数
    NSString *leftDate = [NSString stringWithFormat:@"%d",(int)ceilf(interval/(24.0f*60.0f*60.0f))];
    
    return [NSString stringWithFormat:@"剩余%@天时间",leftDate];
}

//更新活动总人数
- (void)updateUserCount:(NSString *)userCount
{
    if (userCount) {
        UILabel *label = objc_getAssociatedObject(self, &ActivitiesUserCountKey);
        label.text = [NSString stringWithFormat:@"活动名额%@个",userCount];
    }
}

//更新详情说明
- (void)updateActivitiesDetailInfo:(NSString *)detail
{
    if (detail) {
        UIWebView *view = objc_getAssociatedObject(self, &ActivitiesDetailKey);
        
        //计算高度
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
        CGSize labelSize = [detail boundingRectWithSize:CGSizeMake(view.frame.size.width, 999.0) options:NSStringDrawingTruncatesLastVisibleLine |
                            NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, labelSize.height+view.frame.size.height);
        [view loadHTMLString:detail baseURL:nil];
        
        //重置scrollView的contentSize
        UIScrollView *scrollView = objc_getAssociatedObject(self, &RootScrollViewKey);
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.contentSize.height+labelSize.height);
    }
}

//更新当前用户参加活动的状态
- (void)updateActivityCurrentStatus:(NSString *)activityStatus andUserStatus:(NSString *)userStaturs andISGetStatus:(NSString *)isGet
{
    //判断活动状态
    int activityINT = [activityStatus intValue];
    int i = [activityStatus intValue];
    if (activityINT == 1) {
        //关断是否中奖
        int isWinner = [isGet intValue];
        if (isWinner == 1) {
            //已中奖：判断是否已写文章
            if (i == 1) {
                //已完成，已经写了文章
                [self activityIsOverStatusUI];
                return;
            }
            
            //未写文章：创建写文章按钮
            [self createWriteArticleUI];
            return;
        }
        
        //没中奖
        [self activityIsOverStatusUI];
        return;
    }
    
    switch (i) {
        case -1:
        {
            //未参加此活动的状态
        }
            break;
            
        case 0:
        {
            //审核中，未中奖
        }
            
        case 1:
        {
            //已报名活动，审核中，并已中奖
            UIButton *button = objc_getAssociatedObject(self, &ActivityStatuButtonKey);
            [button setTitle:@"审核中" forState:UIControlStateNormal];
            button.backgroundColor = kBaseOrangeColor;
            button.selected = YES;
        }
            break;
            
        default:
            //活动已结束
            break;
    }
}

//已完成状态设置
- (void)activityIsOverStatusUI
{
    //重置UI
    UIImageView *leftDateLogo = objc_getAssociatedObject(self, &LeftDateLogoKey);
    UIImageView *userLogo = objc_getAssociatedObject(self, &UserCountLogoKey);
    UILabel *leftDateLabel = objc_getAssociatedObject(self, &ActivitiesLeftDateKey);
    UILabel *userCount = objc_getAssociatedObject(self, &ActivitiesUserCountKey);
    UILabel *sepLabel = objc_getAssociatedObject(self, &HeaderSeperatorKey);
    
    //移除原视图
    [leftDateLogo removeFromSuperview];
    [userLogo removeFromSuperview];
    [leftDateLabel removeFromSuperview];
    [userCount removeFromSuperview];
    [sepLabel removeFromSuperview];
    
    UIButton *button = objc_getAssociatedObject(self, &ActivityStatuButtonKey);
    [button setTitle:@"已完成" forState:UIControlStateNormal];
    button.backgroundColor = kBaseLightGrayColor;
    button.selected = YES;
}

@end
