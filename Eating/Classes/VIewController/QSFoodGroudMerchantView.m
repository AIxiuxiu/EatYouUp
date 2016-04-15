//
//  QSFoodGroudMerchantView.m
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodGroudMerchantView.h"
#import "QSImageView.h"
#import "QSConfig.h"
#import "QSAPIModel+FoodGroud.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+UI.h"

#import <objc/runtime.h>

///测试背景颜色控制宏
#define __SHOWTEST_BGCOLOR__

///关联
static char MerchantCollectCountKey;//!<商户收藏的次数
static char MerchantLogoKey;//!<商户logo
static char MerchantNameKey;//!<商户名称
static char RemarkStarLevelKey; //!<评分星级view
static char RemarkScoreKey; //!<评分数字Label

@interface QSFoodGroudMerchantView (){

    NSString *_merchantID;//!<商户ID
    NSString *_merchantName;//!<商户名

}

@property (nonatomic,copy) void (^callBack)(NSString *merchantID, NSString *merchantName);//!<点击自身时的回调

@end

@implementation QSFoodGroudMerchantView

#pragma mark - 初始化
///实始化
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(NSString *merchantID, NSString *merchantName))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///创建UI
        [self createMerchantInfoUI];
        
        ///保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        ///添加单击事件
        [self addSingleTapGuesture];
        
    }
    
    return self;

}

///为自身的view添加单击事件
- (void)addSingleTapGuesture
{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(merchantInfoSingleTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];

}

///自身的单击事件
- (void)merchantInfoSingleTapAction:(UITapGestureRecognizer *)tap
{

    if (self.callBack) {
        self.callBack(_merchantID,_merchantName);
    }

}

#pragma mark - UI搭建
///搭建UI
- (void)createMerchantInfoUI
{

    ///商户logo
    UIView *logoAboveView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 70.0f, 70.0f)];
    logoAboveView.layer.cornerRadius = 35.0f;
    logoAboveView.backgroundColor = [UIColor whiteColor];
    [self addSubview:logoAboveView];
    
    QSImageView *merchantLogoView = [[QSImageView alloc] initWithFrame:CGRectMake(2.5f, 2.5f, logoAboveView.frame.size.width-5.0f, logoAboveView.frame.size.width-5.0f)];
    merchantLogoView.layer.cornerRadius = merchantLogoView.frame.size.width/2.0f;
#ifdef __SHOWTEST_BGCOLOR__
    merchantLogoView.backgroundColor = [UIColor orangeColor];
#endif
    [merchantLogoView roundView];
    [logoAboveView addSubview:merchantLogoView];
    objc_setAssociatedObject(self, &MerchantLogoKey, merchantLogoView, OBJC_ASSOCIATION_ASSIGN);
    
    ///文字信息底view
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, self.frame.size.height-20.0f)];
    infoView.layer.cornerRadius = 6.0f;
    infoView.backgroundColor = [UIColor whiteColor];
    [self insertSubview:infoView belowSubview:logoAboveView];
    
    ///添加信息展示的子view
    [self createMerchantInfoUI:infoView];
    
    ///收藏图标
    QSImageView *collectView= [[QSImageView alloc] initWithFrame:CGRectMake(DEFAULT_MAX_WIDTH - 80.0f, 10.0f, 40.0f, 40.0f)];
    collectView.image = [UIImage imageNamed:@"foodgroud_detail_merchant_collect"];
    [self addSubview:collectView];
    
    ///添加一个标签到收藏上
    UILabel *collectCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 20.0f, collectView.frame.size.width-10.0f, 15.0f)];
    collectCountLabel.text = @"2103";
    collectCountLabel.adjustsFontSizeToFitWidth = YES;
    collectCountLabel.textColor = [UIColor whiteColor];
    collectCountLabel.textAlignment = NSTextAlignmentCenter;
    [collectView addSubview:collectCountLabel];
    objc_setAssociatedObject(self, &MerchantCollectCountKey, collectCountLabel, OBJC_ASSOCIATION_ASSIGN);

}

/**
 *  @author     yangshengmeng, 14-12-24 12:12:21
 *
 *  @brief      创建文字信息的view
 *
 *  @param view 文字信息所在的底view
 *
 *  @since      2.0
 */
- (void)createMerchantInfoUI:(UIView *)view
{

    ///商户名称
    UILabel *merchantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 9.0f, view.frame.size.width-100.0f, 20.0f)];
    merchantNameLabel.text = @"洛奇先生餐吧(琶醍店)";
    merchantNameLabel.textColor = kBaseOrangeColor;
    merchantNameLabel.font = [UIFont systemFontOfSize:16.0f];
    [view addSubview:merchantNameLabel];
    objc_setAssociatedObject(self, &MerchantNameKey, merchantNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///总体评分说明
    UILabel *scoreCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(merchantNameLabel.frame.origin.x, merchantNameLabel.frame.origin.y+merchantNameLabel.frame.size.height+8.0f, 70.0f, 15.0f)];
    scoreCommentLabel.text = @"总体评分：";
    scoreCommentLabel.textColor = kBaseLightGrayColor;
    scoreCommentLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:scoreCommentLabel];
    
    ///白星星
    QSImageView *starWhiteView = [[QSImageView alloc] initWithFrame:CGRectMake(scoreCommentLabel.frame.origin.x+scoreCommentLabel.frame.size.width, scoreCommentLabel.frame.origin.y+2.5f, 50.0f, 10.0f)];
    starWhiteView.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_normal"];
    [view addSubview:starWhiteView];
    
    ///黄星星的底view
    UIView *yellowStarRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, starWhiteView.frame.size.width, starWhiteView.frame.size.height)];
    [starWhiteView addSubview:yellowStarRootView];
    objc_setAssociatedObject(self, &RemarkStarLevelKey, yellowStarRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///黄星星:fooddetective_freefoodstore_star_highlighted
    QSImageView *starYellowView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 10.0f)];
    starYellowView.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_highlighted"];
    [yellowStarRootView addSubview:starYellowView];
    
    ///评分文字label
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(starWhiteView.frame.origin.x+starWhiteView.frame.size.width+5.0f, scoreCommentLabel.frame.origin.y, 60.0f, 15.0f)];
    scoreLabel.text = @"4.0分";
    scoreLabel.textColor = kBaseOrangeColor;
    scoreLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:scoreLabel];
    objc_setAssociatedObject(self, &RemarkScoreKey, scoreLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-40.0f, view.frame.size.height/2.0f-15.0f, 30.0f, 30.0f)];
    arrowView.image = [UIImage imageNamed:@"foodgroud_detail_arrow_normal"];
    [view addSubview:arrowView];

}

/**
 *  @author         yangshengmeng, 14-12-24 12:12:38
 *
 *  @brief          根据数据模型更新商户信息
 *
 *  @param model    数据模型
 *
 *  @since          2.0
 */
#pragma mark - 刷新UI
- (void)updateMerchantInfoView:(QSFoodGroudMerchantDataModel *)model
{
    ///保存商户信息
    _merchantID = [model.merchantID copy];
    _merchantName = [model.merchantName copy];

    ///更新商户名
    [self updateMerchantName:model.merchantName];
    
    ///更新商户图片
    [self updateMerchantLogo:model.merchantIcon];
    
    ///更新星级
    [self updateMerchantScore:model.merchantScore];
    
    ///更新商户的点赞次数
    [self updateMerchantCollectCount:model.merchantCollectCount];

}

- (void)updateMerchantScore:(NSString *)score
{

    UIView *starView = objc_getAssociatedObject(self, &RemarkStarLevelKey);
    UILabel *scoreLabel = objc_getAssociatedObject(self, &RemarkScoreKey);
    CGFloat level = [score floatValue] / 10.0f;
    
    if (starView) {
        starView.frame = CGRectMake(starView.frame.origin.x, starView.frame.origin.y, level * 50.0f, starView.frame.size.width);
    }
    
    if (scoreLabel) {
        
        scoreLabel.text = [NSString stringWithFormat:@"%.1f",[score floatValue]];
        
    }

}

///更新商户名
- (void)updateMerchantName:(NSString *)name
{

    UILabel *merchantName = objc_getAssociatedObject(self, &MerchantNameKey);
    if (merchantName && name) {
        merchantName.text = name;
    }

}

///更新商户的logo
- (void)updateMerchantLogo:(NSString *)urlString
{

    UIImageView *merchantLogo = objc_getAssociatedObject(self, &MerchantLogoKey);
    if (merchantLogo && urlString) {
        
        [merchantLogo setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
        
    }

}

/**
 *  @author         yangshengmeng, 14-12-25 11:12:23
 *
 *  @brief          更新商户收藏次数
 *
 *  @param count    次数
 *
 *  @since          2.0
 */
- (void)updateMerchantCollectCount:(NSString *)count
{

    UILabel *label = objc_getAssociatedObject(self, &MerchantCollectCountKey);
    if (label && count) {
        
        label.text = count;
        
    }

}

@end
