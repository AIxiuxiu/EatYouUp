//
//  QSPrepaidHeaderView.m
//  Eating
//
//  Created by ysmeng on 14/11/28.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidHeaderView.h"
#import "UIView+UI.h"
#import "QSImageView.h"
#import "QSConfig.h"
#import "QSAPIModel+CouponList.h"
#import "QSAPI.h"
#import "UIImageView+AFNetworking.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"
#import <CoreLocation/CLLocation.h>

#import <objc/runtime.h>

//显示UI背景颜色宏
#define SHOW_TEST_BGCOLOR

//关联
static char MarIconKey;
static char MarNameKey;
static char UserMarDistanceKey;
static char ScoreStarViewKey;
static char ScoreLabelKey;
@implementation QSPrepaidHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        //创建UI
        [self createPrepaidheaderUI];
    }
    
    return self;
}

- (void)createPrepaidheaderUI
{
    //信息view
    QSImageView *infoView = [[QSImageView alloc] initWithFrame:CGRectMake(10.0, 20.0f, self.frame.size.width-20.0f, self.frame.size.height-20.0f)];
    infoView.image = [UIImage imageNamed:@"prepaidcard_list_header"];
    [self createInfoShowView:infoView];
    [self addSubview:infoView];
    
    //icon
    QSImageView *iconAbove = [[QSImageView alloc] initWithFrame:CGRectMake(20.0f, 5.0f, 57.0f, 57.0f)];
    [self addSubview:iconAbove];
    [iconAbove roundView];
#ifdef SHOW_TEST_BGCOLOR
    iconAbove.backgroundColor = [UIColor whiteColor];
#endif
    
    QSImageView *icon = [[QSImageView alloc] initWithFrame:CGRectMake(2.5f, 2.5f, 52.0f, 52.0f)];
    [iconAbove addSubview:icon];
    [icon roundView];
#ifdef SHOW_TEST_BGCOLOR
    icon.backgroundColor = [UIColor orangeColor];
#endif
    objc_setAssociatedObject(self, &MarIconKey, icon, OBJC_ASSOCIATION_ASSIGN);
}

//创建信息显示
- (void)createInfoShowView:(UIView *)view
{
    //店名
    UILabel *marName = [[UILabel alloc] initWithFrame:CGRectMake(77.0f, 5.0f, 120.0f, 20.0f)];
    marName.text = @"广州酒家集团";
    marName.font = [UIFont boldSystemFontOfSize:20.0f];
    marName.textColor = kBaseGrayColor;
    [view addSubview:marName];
    objc_setAssociatedObject(self, &MarNameKey, marName, OBJC_ASSOCIATION_ASSIGN);
#if 1
    //距离logo
    UIImageView *localLogo = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-10.0f-45.0f-3.0f-7.0f, 10.0f, 7.0f, 10.0f)];
    localLogo.image = [UIImage imageNamed:@"prepaidcard_header_local"];
    [view addSubview:localLogo];
    
    //距离
    UILabel *local = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-10.0f-45.0f, 5.0f, 45.0f, 20.0f)];
    local.font = [UIFont systemFontOfSize:12.0f];
    local.textAlignment = NSTextAlignmentRight;
    local.textColor = kBaseLightGrayColor;
    local.text = @"3203m";
    [view addSubview:local];
    objc_setAssociatedObject(self, &UserMarDistanceKey, local, OBJC_ASSOCIATION_ASSIGN);

    //星级
    UIImageView *whiteStar = [[UIImageView alloc] initWithFrame:CGRectMake(77.0f, 30.0f, 15.0f*5, 15.0f)];
    whiteStar.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_normal"];
    [view addSubview:whiteStar];
    
    UIView *leveRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, whiteStar.frame.size.width-30.0f, whiteStar.frame.size.height)];
    leveRootView.clipsToBounds = YES;
    [whiteStar addSubview:leveRootView];
    objc_setAssociatedObject(self, &ScoreStarViewKey, leveRootView, OBJC_ASSOCIATION_ASSIGN);
    
    //fooddetective_freefoodstore_star_highlighted
    UIImageView *leveStar = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, whiteStar.frame.size.width, whiteStar.frame.size.height)];
    leveStar.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_highlighted"];
    [leveRootView addSubview:leveStar];
    
    //评分
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(whiteStar.frame.origin.x+whiteStar.frame.size.width+10.0f, whiteStar.frame.origin.y, 60.0f, 15.0f)];
    scoreLabel.text = @"9.5分";
    scoreLabel.textColor = kBaseLightGrayColor;
    scoreLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:scoreLabel];
    objc_setAssociatedObject(self, &ScoreLabelKey, scoreLabel, OBJC_ASSOCIATION_ASSIGN);
#endif
}

//**************************************
//             刷新储值卡店面信息
//**************************************
#pragma mark - 刷新储值卡店面信息
- (void)updatePrepaidCardHeaderUI:(QSMarchantBaseInfoDataModel *)headerModel
{
    
    ///更新商户名
    [self updateMarchantName:[self getMarchantNameWithNickName:headerModel.marName andMarNickName:headerModel.marNickName]];
    
    ///更新评分
    [self updateMarchantRemarkScore:headerModel.marRemarkScore];
    
    ///更新商户图标
    [self updateMarchantLogo:headerModel.marIcon];
    
    ///更新当前用户和商户的距离
    [self updateDistance:headerModel.marLatitude andLongitude:headerModel.marLongitude];
    
}

///更新商户距离
- (void)updateDistance:(NSString *)latitude andLongitude:(NSString *)longitude
{

    CLLocationCoordinate2D point1 = [UserManager sharedManager].userData.location;
    CLLocationCoordinate2D point2 = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    NSString *distance = [[UserManager sharedManager] distanceBetweenTwoPoint:point1 andPoint2:point2];
    
    UILabel *disLabel = objc_getAssociatedObject(self, &UserMarDistanceKey);
    disLabel.text = [NSString stringWithFormat:@"%@",distance];

}

///更新商户名称
- (void)updateMarchantName:(NSString *)marName
{
    if (marName) {
        ///获取商户名label
        UILabel *nameLabel = objc_getAssociatedObject(self, &MarNameKey);
        nameLabel.text = marName;
    }
}

/**
 *  更新商户评分：需要同时更新星级
 */
- (void)updateMarchantRemarkScore:(NSString *)score
{
    if (score) {
        
        ///更新评分数字
        UILabel *remarkLabel = objc_getAssociatedObject(self, &ScoreLabelKey);
        remarkLabel.text = [NSString stringWithFormat:@"%.2f分",[score floatValue]];
        
        //更新星级
        UIView *starView = objc_getAssociatedObject(self, &ScoreStarViewKey);
        starView.frame = CGRectMake(starView.frame.origin.x, starView.frame.origin.y, starView.superview.frame.size.width * ([score floatValue] / 10.0f), starView.frame.size.height);
        
    }
}

/**
 *  更新商户logo
 *  @param  logoURL 图片的地址
 */
- (void)updateMarchantLogo:(NSString *)logoURL
{
    if (logoURL) {
        
        ///补全URL
        NSString *imgString = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"default_file_super_url"],logoURL];
        
        ///获取商户图标
        UIImageView *marchantLogo = objc_getAssociatedObject(self, &MarIconKey);
        [marchantLogo setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:nil];
        
    }
}

/**
 *  根据商户的匿称和正式名字，返回列表显示的商户名
 *  规则：如若存在匿称，返回匿称；其他则返回全名
 */
- (NSString *)getMarchantNameWithNickName:(NSString *)marName andMarNickName:(NSString *)nickName
{
    
    if ([nickName length] > 4) {
        return nickName;
    }
    
    return marName;
}

@end
