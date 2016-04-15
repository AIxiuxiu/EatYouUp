//
//  QSYBannerAdverDetailViewController.m
//  Eating
//
//  Created by ysmeng on 15/1/6.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import "QSYBannerAdverDetailViewController.h"

@interface QSYBannerAdverDetailViewController (){

    NSString *_detailURL;//!<详情地址

}

@end

@implementation QSYBannerAdverDetailViewController

/**
 *  @author             yangshengmeng, 15-01-06 12:01:28
 *
 *  @brief              根据给定的活动地址初始化活动详情页面
 *
 *  @param urlString    活动地址url
 *
 *  @return             返回活动详情页面
 *
 *  @since              2.0
 */
- (instancetype)initWithURL:(NSString *)urlString
{

    if (self = [super init]) {
        
        ///保存地址
        _detailURL = [urlString copy];
        
    }
    
    return self;

}

- (void)createNavigationBar
{

    [super createNavigationBar];
    
    ///显示标题
    [self setNavigationBarMiddleTitle:@"活动详情"];

}

- (void)createMainShowView
{
    
    [super createMainShowView];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64.0f, DeviceWidth, DeviceHeight - 64.0f)];
    [self.view addSubview:webView];
    [self.view sendSubviewToBack:webView];
    
    ///设置背景颜色
    webView.backgroundColor = [UIColor whiteColor];
    
    ///取消滚动条
    for (UIView *obj in [webView subviews]) {
        
        if ([obj isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)obj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)obj).showsVerticalScrollIndicator = NO;
            
        }
        
    }
    
    ///加载活动信息
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_detailURL]]];

}

@end
