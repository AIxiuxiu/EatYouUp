//
//  QSMerchantBaseTableViewCell.m
//  Eating
//
//  Created by ysmeng on 14/12/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantBaseTableViewCell.h"
#import "QSImageView.h"
#import "UIView+UI.h"
#import "QSConfig.h"
#import "QSAPIModel+Merchant.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Name.h"

#import <objc/runtime.h>

///测试颜色是否显示的宏
#define __SHOW_TEST_BGCOLOR__

///关联
static char MerchatLogoKey;//!<商户logo
static char MerchantNameKey;//!<商户名
static char MerchantLocalKey;//!<商户所在地
static char MerchantFoodTypeKey;//!<商户主营的菜色：如粤菜、湘菜
static char AveragePriceKey;//!<人均消费水平

@implementation QSMerchantBaseTableViewCell

/**
 *  @author                 yangshengmeng, 14-12-20 14:12:36
 *
 *  @brief                  创建商户基本信息的UI
 *
 *  @param style            cell的风格
 *  @param reuseIdentifier  复用的关键字
 *
 *  @return                 返回当前创建的cell
 *
 *  @since                  2.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///透明的背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        ///创建UI
        [self createMerchantBaseUI];
        
    }
    
    return self;

}

/**
 *  @author yangshengmeng, 14-12-20 14:12:26
 *
 *  @brief  搭建UI
 *
 *  @since  2.0
 */
- (void)createMerchantBaseUI
{

    ///商户logo
    UIView *merLogoAbove = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 57.0f, 57.0f)];
    [self.contentView addSubview:merLogoAbove];
    [merLogoAbove roundView];
    
    QSImageView *merLogo = [[QSImageView alloc] initWithFrame:CGRectMake(2.5f, 2.5f, 52.0f, 52.0f)];
    [merLogoAbove addSubview:merLogo];
    [merLogo roundView];
#ifdef __SHOW_TEST_BGCOLOR__
    merLogo.backgroundColor = [UIColor orangeColor];
#endif
    objc_setAssociatedObject(self, &MerchatLogoKey, merLogo, OBJC_ASSOCIATION_ASSIGN);
    
#if 1
    ///其他信息的底view
    UIView *baseInfoRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, DEFAULT_MAX_WIDTH, 50.0f)];
    baseInfoRootView.backgroundColor = [UIColor whiteColor];
    baseInfoRootView.layer.cornerRadius = 6.0f;
    [self createBaseInfoSubviews:baseInfoRootView];
    [self.contentView insertSubview:baseInfoRootView belowSubview:merLogoAbove];
#endif

}

/**
 *  @author     yangshengmeng, 14-12-20 14:12:44
 *
 *  @brief      基本信息展示的view，添加到基本信息的底view上
 *
 *  @param view 基本信息的底view
 *
 *  @since      2.0
 */
- (void)createBaseInfoSubviews:(UIView *)view
{

    ///商户名称
    UILabel *merNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(77.0f, 5.0f, view.frame.size.width-87.0f, 20.0f)];
    merNameLabel.text = @"西提厚牛排(正佳店)";
    merNameLabel.font = [UIFont systemFontOfSize:16.0f];
    merNameLabel.textColor = kBaseGrayColor;
    [view addSubview:merNameLabel];
    objc_setAssociatedObject(self, &MerchantNameKey, merNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///地址
    CGFloat ypoint = merNameLabel.frame.origin.y+merNameLabel.frame.size.height+5.0f;
    UILabel *merLocalLabel = [[UILabel alloc] init];
    merLocalLabel.text = @"天河城";
    merLocalLabel.font = [UIFont systemFontOfSize:14.0f];
    merLocalLabel.textColor = kBaseGrayColor;
    merLocalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:merLocalLabel];
    objc_setAssociatedObject(self, &MerchantLocalKey, merLocalLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *foodTypeLabel = [[UILabel alloc] init];
    foodTypeLabel.text = @"粤菜";
    foodTypeLabel.font = [UIFont systemFontOfSize:14.0f];
    foodTypeLabel.textColor = kBaseGrayColor;
    foodTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:foodTypeLabel];
    objc_setAssociatedObject(self, &MerchantFoodTypeKey, foodTypeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///人均消费
    UILabel *averagePriceLabel = [[UILabel alloc] init];
    averagePriceLabel.text = @"人均￥116";
    averagePriceLabel.font = [UIFont systemFontOfSize:14.0f];
    averagePriceLabel.textColor = kBaseOrangeColor;
    averagePriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:averagePriceLabel];
    objc_setAssociatedObject(self, &AveragePriceKey, averagePriceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加约束
    NSDictionary *sizesDice = @{@"ypoint":[NSString stringWithFormat:@"%f",ypoint]};
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(merLocalLabel,foodTypeLabel,averagePriceLabel);
    NSString *___hVFL_all = @"H:|-77-[merLocalLabel]-5-[foodTypeLabel]-(>=5)-[averagePriceLabel]-10-|";
    NSString *___vVFL_merLocallLabel = @"V:|-ypoint-[merLocalLabel(15)]";
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_all options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDict]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_merLocallLabel options:0 metrics:sizesDice views:viewsDict]];

}

/**
 *  @author         yangshengmeng, 14-12-20 17:12:43
 *
 *  @brief          根据给定的商户信息模型，更新UI
 *
 *  @param model    商户信息模型
 *
 *  @since          2.0
 */
#pragma mark - 刷新UI数据
- (void)updateMerchantBaseTableViewWithModel:(QSMerchantDetailData *)model
{

    ///更新商户名字
    [self updateMerchantName:model.merchant_name];
    
    ///更新商户logo
    [self updateMerchantLogo:model.merchant_logo];
    
    ///更新人均消费
    [self updatePerPrice:model.merchant_per];

}

///更新人均消费
- (void)updatePerPrice:(NSString *)perPrice
{

    UILabel *priceLabel = objc_getAssociatedObject(self, &AveragePriceKey);
    if (priceLabel && perPrice) {
        
        NSString *subString = [priceLabel.text substringToIndex:3];
        priceLabel.text = [NSString stringWithFormat:@"%@%.2f",subString,[perPrice floatValue]];
        
    }

}

///更新商户ID
- (void)updateMerchantName:(NSString *)name
{

    UILabel *merchantName = objc_getAssociatedObject(self, &MerchantNameKey);
    if (merchantName && name) {
        merchantName.text = name;
    }

}

///更新商户logo
- (void)updateMerchantLogo:(NSString *)logoURL
{

    UIImageView *merchantLogo = objc_getAssociatedObject(self, &MerchatLogoKey);
    if (merchantLogo && logoURL) {
        
        [merchantLogo setImageWithURL:[NSURL URLWithString:[logoURL imageUrl]] placeholderImage:nil];
        
    }

}

@end
