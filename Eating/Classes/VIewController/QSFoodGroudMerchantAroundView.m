//
//  QSFoodGroudMerchantAroundView.m
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodGroudMerchantAroundView.h"
#import "QSAPIModel+FoodGroud.h"
#import "UIImageView+AFNetworking.h"
#import "QSConfig.h"

@interface QSFoodGroudMerchantAroundView()<UIScrollViewDelegate>

@end

@implementation QSFoodGroudMerchantAroundView

/**
 *  @author             yangshengmeng, 14-12-25 10:12:24
 *
 *  @brief              更新商户环境图片
 *
 *  @param imageList    图片数组
 *
 *  @since              2.0
 */
- (void)updateMerchantAround:(NSArray *)imageList
{
    ///先移除
    for (UIView *obj in [self subviews]) {
        
        [obj removeFromSuperview];
        
    }

    ///重新创建
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    ///取消滚动
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    
    for (int i = 0; i < [imageList count]; i++) {
        
        ///获取模型
        QSFoodGroudMerchantImageModel *model = imageList[i];
        
        ///添加滚动图片
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollView.frame.size.width, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height)];
        
        [view setImageWithURL:[NSURL URLWithString:model.imageLink] placeholderImage:nil];
        
        [scrollView addSubview:view];
        
    }
    
    ///设置滚动的尺寸
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [imageList count], scrollView.frame.size.height);
    
    ///添加页码管理器
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    pageControl.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height-50.0f);
    pageControl.numberOfPages = [imageList count];
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = kBaseLightGrayColor;
    [self addSubview:pageControl];
    [self bringSubviewToFront:pageControl];
    pageControl.tag = 361;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    UIPageControl *pageControll = (UIPageControl *)[self viewWithTag:361];
    pageControll.currentPage = page;

}

@end
