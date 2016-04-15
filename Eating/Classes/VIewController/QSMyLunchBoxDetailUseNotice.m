//
//  QSMyLunchBoxDetailUseNotice.m
//  Eating
//
//  Created by ysmeng on 14/12/8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyLunchBoxDetailUseNotice.h"
#import "QSConfig.h"

#import <objc/runtime.h>

///关联
static char UserNoticeKey;//!<使用知须信息
@implementation QSMyLunchBoxDetailUseNotice

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //创建普通UI
        [self createNormalDetailUI];
        
    }
    
    return self;
}

- (void)createNormalDetailUI
{
    
    //说明信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, self.frame.size.width-20.0f, 20.0f)];
    tipsLabel.text = @"使用须知";
    tipsLabel.font = [UIFont systemFontOfSize:12.0f];
    tipsLabel.textColor = kBaseGrayColor;
    [self addSubview:tipsLabel];
    
    //分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 29.5f, self.frame.size.width, 0.5f)];
    sepLabel.backgroundColor = kBaseLightGrayColor;
    sepLabel.alpha = 0.5f;
    [self addSubview:sepLabel];
    
    //详情显示webview
    UIWebView *useNotice = [[UIWebView alloc] initWithFrame:CGRectMake(10.0f, 35.0f, self.frame.size.width-20.0f, self.frame.size.height-40.0f)];
    useNotice.backgroundColor = [UIColor whiteColor];
    useNotice.layer.cornerRadius = 8.0f;
    [self addSubview:useNotice];
    
    //去除滚动条
    for (UIView *webViewObj in [useNotice subviews]) {
        if ([webViewObj isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)webViewObj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)webViewObj).showsVerticalScrollIndicator = NO;
            ((UIScrollView *)webViewObj).contentSize = CGSizeMake(0.0f, 0.0f);
        }
    }
    
    //加载默认内容：0x888888
    NSString *defaultNotice = @"<p style=\"text-align:left;font-size:12px; color: rgb(136, 136, 136)\">·有效期：2013-12-20至2015-12-31</p><p style=\"text-align:left;font-size:12px; color: rgb(136, 136, 136)\">·除外日期：<br>2013-12-20至2015-12-31</br><br>2013-12-20至2015-12-31不可用</br></p><p style=\"text-align:left;font-size:12px; color: rgb(136, 136, 136)\">·预约信息：无须预约消费高峰时可能需要排队</p><p style=\"text-align:left;font-size:12px; color: rgb(136, 136, 136)\">·食堂外带：本单只适用于食堂，包厢大厅随您使用</p><p style=\"text-align:left;font-size:12px; color: rgb(136, 136, 136)\">·规则提醒：可累积使用，不兑现，不找零</p><p style=\"text-align:left;font-size:12px; color: rgb(136, 136, 136)\">·不适用范围：<br>不可抵扣茶位，特价菜，季节性产品，酒水，宴席3围</br><br>以上不再与店内其他优惠同享</br></p><p style=\"text-align:left;font-size:12px; color: rgb(136, 136, 136)\">·商家服务：免费提供wifi</p><p style=\"text-align:left;font-size:12px; color: rgb(136, 136, 136)\">·温馨提示：需团购卷发票，请您在消费时向商户咨询</p>";
    [useNotice loadHTMLString:defaultNotice baseURL:nil];
    
    objc_setAssociatedObject(self, &UserNoticeKey, useNotice, OBJC_ASSOCIATION_ASSIGN);
    
}

/**
 *  @author         yangshengmeng, 14-12-23 11:12:00
 *
 *  @brief          更新使用须知信息
 *
 *  @param notice   须知信息
 *
 *  @since          2.0
 */
#pragma mark - 更新使用须知信息
- (void)updateUserNotice:(NSString *)notice
{

    UIWebView *userNotice = objc_getAssociatedObject(self, &UserNoticeKey);
    [userNotice loadHTMLString:notice baseURL:nil];

}

@end
