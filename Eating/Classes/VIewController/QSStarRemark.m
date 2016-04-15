//
//  QSStarRemark.m
//  Eating
//
//  Created by ysmeng on 14/11/26.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSStarRemark.h"
#import "QSConfig.h"
#import "QSImageView.h"

#import <objc/runtime.h>

//关联
static char StarLevelKey;
@implementation QSStarRemark

//******************************
//          初始化/UI搭建
//******************************
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(CGFloat))callBack
{
    if (self = [super initWithFrame:frame]) {
        //保存block
        if (callBack) {
            self.callBack = callBack;
        }
        
        //创建UI
        [self createStarRemarkUI];
    }
    
    return self;
}

//创建星级评论UI
- (void)createStarRemarkUI
{
    //说明
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 7.0f, 80.0f, 30.0f)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = kBaseLightGrayColor;
    titleLabel.text = @"总体点评：";
    [self addSubview:titleLabel];
    
    //白星星
    QSImageView *whiteStar = [[QSImageView alloc] initWithFrame:CGRectMake(90.0f, 12.0f, 100.0f, 20.0f)];
    whiteStar.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_normal"];
    [self addSubview:whiteStar];
    [self addWhiteStartapAction:whiteStar];
    
    //黄星星：fooddetective_freefoodstore_star_highlighted
    //黄色星星的底view
    UIView *scoreStarRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, whiteStar.frame.size.width-40.0f, whiteStar.frame.size.height)];
    [whiteStar addSubview:scoreStarRootView];
    scoreStarRootView.clipsToBounds = YES;
    objc_setAssociatedObject(self, &StarLevelKey, scoreStarRootView, OBJC_ASSOCIATION_ASSIGN);
    
    //黄色星星view
    QSImageView *scoreStarView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, whiteStar.frame.size.width, whiteStar.frame.size.height)];
    [scoreStarRootView addSubview:scoreStarView];
    scoreStarView.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_highlighted"];
    [self addYellowStarTapAction:scoreStarView];
}

#pragma mark - 点击白色星星时增加星级
- (void)addWhiteStartapAction:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addStartLevel:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
}

- (void)addStartLevel:(UITapGestureRecognizer *)tap
{
    UIView *view = objc_getAssociatedObject(self, &StarLevelKey);
    if (view.frame.size.width < 100.0f) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width + 10.0f, view.frame.size.height);
        if (self.callBack) {
            self.callBack(view.frame.size.width/100.0f);
        }
    }
}

#pragma mark - 点击黄色星星时减少星级
- (void)addYellowStarTapAction:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reduceStartLevel:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
}

- (void)reduceStartLevel:(UITapGestureRecognizer *)tap
{
    UIView *view = objc_getAssociatedObject(self, &StarLevelKey);
    if (view.frame.size.width > 0.0f) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width - 10.0f, view.frame.size.height);
        if (self.callBack) {
            self.callBack(view.frame.size.width/100.0f);
        }
    }
}

@end
