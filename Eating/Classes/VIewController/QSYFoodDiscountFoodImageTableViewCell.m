//
//  QSYFoodDiscountFoodImageTableViewCell.m
//  Eating
//
//  Created by System Administrator on 12/27/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSYFoodDiscountFoodImageTableViewCell.h"
#import "QSAPIModel+CouponDetail.h"
#import "QSConfig.h"
#import "UIImageView+AFNetworking.h"  ///扩展图片URL申请的方法
#import "NSString+Name.h"       ///让传进的ＵＲＬ对象能访问ImageURl方法

#import <objc/runtime.h>

///关联
static char FoodImageKey;//!<菜品图片
static char FoodNameKey;//!<菜品名字
static char FoodOrignalPriceKey;//!<原价
static char FoodRealPriceKey;//!<现价

@implementation QSYFoodDiscountFoodImageTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///背景
        self.backgroundColor = [UIColor clearColor];
        
        ///搭建UI
        [self createFoodDiscountInfoUI];
        
    }
    
    return self;

}

/**
 *  @author wangshupeng, 14-12-27 11:12:11
 *
 *  @brief  搭建UI
 *
 *  @since  2.0
 */
#pragma mark - 搭建UI
- (void)createFoodDiscountInfoUI
{
    
    CGFloat height =  DeviceHeight <= 568.0f ? 160.0f : (160.0f * (DeviceWidth - 2 * MARGIN_LEFT_RIGHT) / 300.0f);

    ///图片框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 5.0f, DEFAULT_MAX_WIDTH, height)];
    imageView.userInteractionEnabled = YES;    ///用户交互
    [self.contentView addSubview:imageView];
    objc_setAssociatedObject(self, &FoodImageKey, imageView, OBJC_ASSOCIATION_ASSIGN);//设置运行时添加
    
    ///其他信息的底view
    UIImageView *infoRootView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, height+10.0f-30.0f, DEFAULT_MAX_WIDTH, 25.0f)];
    infoRootView.backgroundColor = [UIColor whiteColor];
    infoRootView.userInteractionEnabled = YES;
    
    ///添加信息显示的view
    [self createInfoSubviews:infoRootView];
    
    [self.contentView addSubview:infoRootView];

}

///在信息的底view上添加信息展示的子view
- (void)createInfoSubviews:(UIView *)view
{

    ///菜品名
    UILabel *foodNameLabel = [[UILabel alloc] init];
    foodNameLabel.font = [UIFont systemFontOfSize:16.0f];
    foodNameLabel.textColor = kBaseLightGrayColor;
    foodNameLabel.translatesAutoresizingMaskIntoConstraints = NO;///实现自动布局
    [view addSubview:foodNameLabel];
    objc_setAssociatedObject(self, &FoodNameKey, foodNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///原价
    UILabel *orignalPriceLabel = [[UILabel alloc] init];
    orignalPriceLabel.font = [UIFont systemFontOfSize:12.0f];
    orignalPriceLabel.textColor = kBaseLightGrayColor;
    orignalPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:orignalPriceLabel];
    objc_setAssociatedObject(self, &FoodOrignalPriceKey, orignalPriceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///原价上的划线
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = kBaseLightGrayColor;
    lineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [orignalPriceLabel addSubview:lineLabel];
    
    ///划线约束
    NSString *___hVFL_line = @"H:|[lineLabel(==orignalPriceLabel)]|";
    NSString *___vVFL_line = @"V:[lineLabel(0.5)]";
    ///划线的约束添加
    [orignalPriceLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_line options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(lineLabel,orignalPriceLabel)]];
    [orignalPriceLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_line options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(lineLabel)]];
    [orignalPriceLabel addConstraint:[NSLayoutConstraint constraintWithItem:lineLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:orignalPriceLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    ///现价前的人民币符号
    UILabel *rmbLabel = [[UILabel alloc] init];
    rmbLabel.text = @"￥";
    rmbLabel.font = [UIFont systemFontOfSize:12.0f];
    rmbLabel.translatesAutoresizingMaskIntoConstraints = NO;
    rmbLabel.textColor = kBaseOrangeColor;
    [view addSubview:rmbLabel];
    
    ///现价
    UILabel *realPriceLabel = [[UILabel alloc] init];
    realPriceLabel.textColor = kBaseOrangeColor;
    realPriceLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    realPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:realPriceLabel];
    objc_setAssociatedObject(self, &FoodRealPriceKey, realPriceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///所有信息view的约束
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(foodNameLabel,orignalPriceLabel,rmbLabel,realPriceLabel);
    NSString *___hVFL_All = @"H:|-10-[foodNameLabel]-(>=10)-[orignalPriceLabel]-[rmbLabel][realPriceLabel]-10-|";
    NSString *___vVFL_foodName = @"V:|-(>=2.5)-[foodNameLabel(20)]-2.5-|";
    NSString *___vVFL_orignalPrice = @"V:|-(>=3)-[orignalPriceLabel(15)]-2.5-|";
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_All options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_foodName options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_orignalPrice options:0 metrics:nil views:viewsDict]];

}

/**
 *  @author             wangshupeng, 14-12-27 10:12:33
 *
 *  @brief              根据给定的数据模型更新每个菜品的信息
 *
 *  @param imageModel   菜品优惠数据模型
 *
 *  @since              2.0
 */
#pragma mark - 刷新UI
- (void)updateFoodImageInfoWithModel:(QSYFoodOfferFoodDiscountDataModel *)imageModel andDiscount:(NSString *)discount
{
    
    ///更新原价
    [self updateFoodOriginalPrice:imageModel.foodOriginalPrice];
    
    ///更新现价
    [self updateFoodReadPrice:discount andOrignalPrice:imageModel.foodOriginalPrice];
    
    ///更新标题
    [self updateFoodName:imageModel.foodTitle];

    ///更新菜品图片
    [self updateFoodImage:imageModel.foodImageURLString];

}

///更新菜品名
- (void)updateFoodName:(NSString *)foodName
{
    
    UILabel *label = objc_getAssociatedObject(self, &FoodNameKey);
    if (label && foodName) {
        
        label.text = foodName;
        
    }

}

///更新原价
- (void)updateFoodOriginalPrice:(NSString *)orignalPrice
{

    UILabel *label = objc_getAssociatedObject(self, &FoodOrignalPriceKey);
    if (label && orignalPrice) {
        
        label.text = [NSString stringWithFormat:@"￥%.2f",[orignalPrice floatValue]];
        
    }

}

///更新现价
- (void)updateFoodReadPrice:(NSString *)discount andOrignalPrice:(NSString *)orignalPrice
{

    UILabel *label = objc_getAssociatedObject(self, &FoodRealPriceKey);
    if (label && discount && orignalPrice) {
        
        CGFloat realPrice = [orignalPrice floatValue] * ([discount floatValue] / 100.0f);
        label.text = [NSString stringWithFormat:@"%.2f",realPrice];
        
    }

}

///更新菜品图片
- (void)updateFoodImage:(NSString *)urlString
{

    UIImageView *view = objc_getAssociatedObject(self, &FoodImageKey);
    if (view && urlString) {
        
        [view setImageWithURL:[NSURL URLWithString:[urlString imageUrl]] placeholderImage:nil];
        
    }

}

@end
