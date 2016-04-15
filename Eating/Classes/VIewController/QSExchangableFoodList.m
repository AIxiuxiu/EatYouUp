//
//  QSExchangableFoodList.m
//  Eating
//
//  Created by ysmeng on 14/12/8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSExchangableFoodList.h"
#import "QSConfig.h"

//记录头信息tag
#define TAG_EXCHANGABLE_FOODLIST_HEADER_TIPS 310
#define TAG_EXCHANGABLE_FOODLIST_HEADER_SEP 311

@implementation QSExchangableFoodList

/**
 *  按给定的数据源创建可兑菜品列表视图
 *
 *  @param dataSource       可兑换菜品数组
 *  @param frame            在父视图中的坐标
 *  @param return           返回菜品列表视图
 */
#pragma mark - 按给定的数据源创建可兑菜品列表视图
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)dataSource
{
    if (self = [super initWithFrame:frame]) {
        
        //说明头信息
        [self createTitleLabel];
        
        //根据数据源创建UI
        [self createInfoUI:dataSource];
        
    }
    
    return self;
}

- (void)createTitleLabel
{
    //说明头
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, self.frame.size.width-20.0f, 20.0f)];
    titleLabel.text = @"可兑菜品(一份)";
    titleLabel.textColor = kBaseLightGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:titleLabel];
    titleLabel.tag = TAG_EXCHANGABLE_FOODLIST_HEADER_TIPS;
    
    //分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 29.5f, self.frame.size.width, 0.5f)];
    sepLabel.backgroundColor = kBaseLightGrayColor;
    sepLabel.alpha = 0.5f;
    [self addSubview:sepLabel];
    sepLabel.tag = TAG_EXCHANGABLE_FOODLIST_HEADER_SEP;
}

/**
 *  刷新可兑换菜品列表
 *
 *  @param foodList     可兑换菜品数组
 */
#pragma mark - 刷新可兑换菜品列表
- (void)updateExchangableFoodList:(NSArray *)foodList
{
    [self createInfoUI:foodList];
}

//根据数据源搭建UI
- (void)createInfoUI:(NSArray *)foodList
{
    //清空
    for (UIView *obj in [self subviews]) {
        
        if (obj.tag == TAG_EXCHANGABLE_FOODLIST_HEADER_TIPS || obj.tag == TAG_EXCHANGABLE_FOODLIST_HEADER_SEP) {
            continue;
        }
        
        [obj removeFromSuperview];
    }
    
    for (int i = 0; i < [foodList count]; i++) {
        
        //取得数组中的字典
        NSDictionary *tempDict = foodList[i];
        
        //菜品名
        UILabel *foodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 35.0f+20.0f*i, 80.0f, 20.0f)];
        foodNameLabel.font = [UIFont systemFontOfSize:12.0f];
        foodNameLabel.textColor = kBaseGrayColor;
        foodNameLabel.textAlignment = NSTextAlignmentLeft;
        foodNameLabel.text = [tempDict valueForKey:@"foodName"];
        [self addSubview:foodNameLabel];
        
        //份数
        UILabel *changeCount = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0f-30.0f, 35.0f+20.0f*i, 30.0f, 20.0f)];
        changeCount.font = [UIFont systemFontOfSize:12.0f];
        changeCount.textColor = kBaseGrayColor;
        changeCount.textAlignment = NSTextAlignmentRight;
        changeCount.text = [NSString stringWithFormat:@"%@份", [tempDict valueForKey:@"count"]];
        [self addSubview:changeCount];
        
        //单价
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-70.0f, 35.0f+20.0f*i, 60.0f, 20.0f)];
        priceLabel.font = [UIFont systemFontOfSize:12.0f];
        priceLabel.textColor = kBaseGrayColor;
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text = [NSString stringWithFormat:@"￥%@",[tempDict valueForKey:@"price"]];
        [self addSubview:priceLabel];
        
    }
}

@end
