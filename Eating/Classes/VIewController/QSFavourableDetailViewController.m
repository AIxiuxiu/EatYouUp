//
//  QSFavourableDetailViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFavourableDetailViewController.h"

@interface QSFavourableDetailViewController (){

    NSString *_commetInfo;//!<详情信息

}

@end

@implementation QSFavourableDetailViewController

//**********************************
//             初始化/UI搭建
//**********************************
#pragma mark - 初始化/UI搭建
/**
 *  @author         yangshengmeng, 15-01-06 09:01:16
 *
 *  @brief          根据详情信息初始化详情说明
 *
 *  @param comment  说明信息
 *
 *  @return         返回一个显示详情的页面
 *
 *  @since          2.0
 */
- (instancetype)initWithDetailComment:(NSString *)comment
{

    if (self = [super init]) {
        
        _commetInfo = [comment copy];
        
    }
    
    return self;

}

///重写导航栏
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"优惠详情"];
}

- (void)createMainShowView
{
    
    [super createMainShowView];

    UIWebView *commentWebview = [[UIWebView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, 90.0f, DEFAULT_MAX_WIDTH, DeviceHeight - 100.0f)];
    commentWebview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:commentWebview];
    
    ///取消滚动条
    for (UIView *obj in [commentWebview subviews]) {
        
        if ([obj isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)obj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)obj).showsVerticalScrollIndicator = NO;
            
        }
        
    }
    
    [commentWebview loadHTMLString:[NSString stringWithFormat:@"<p>%@</p>",_commetInfo] baseURL:nil];

}

@end
