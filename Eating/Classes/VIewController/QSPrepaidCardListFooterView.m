//
//  QSPrepaidCardListFooterView.m
//  Eating
//
//  Created by ysmeng on 14/11/28.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidCardListFooterView.h"
#import "QSBlockActionButton.h"
#import "QSConfig.h"

@interface QSPrepaidCardListFooterView (){
    BOOL _footerStatus;//脚视图状态
}

@end

@implementation QSPrepaidCardListFooterView

- (instancetype)initWithFrame:(CGRect)frame andStatus:(BOOL)status andCallBack:(void(^)(PREPAIDCARD_LIST_FOOTER_ACTIONTYPE actionType,BOOL flag))callBack
{
    if (self = [super initWithFrame:frame]) {
        if (callBack) {
            //保存回调
            self.callBack = callBack;
            
            //保存状态
            _footerStatus = status;
            
            //创建UI
            [self createPrepaidCardFooterUI:status];
        }
    }
    
    return self;
}

- (void)createPrepaidCardFooterUI:(BOOL)status
{
    //底view
    UIImageView *rootView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f,0.0f, self.frame.size.width-20.0f, self.frame.size.height)];
    rootView.userInteractionEnabled = YES;
    rootView.image = [UIImage imageNamed:@"prepaidcard_list_none"];
    [self addSubview:rootView];
    
    UIButton *moreButton = [UIButton createBlockActionButton:CGRectMake(20.0f, 2.5f, rootView.frame.size.width-40.0f, 15.0f) andStyle:nil andCallBack:^(UIButton *buttonTarget) {
        
        //回调
        if (self.callBack) {
            self.callBack(LOADMORE_PLFA,!status);
        }
        
    }];
    moreButton.selected = status;
    [moreButton setTitle:@"显示全部" forState:UIControlStateNormal];
    [moreButton setTitle:@"收起" forState:UIControlStateSelected];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    moreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [moreButton setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
    [moreButton setTitleColor:kBaseLightGrayColor forState:UIControlStateHighlighted];
    [rootView addSubview:moreButton];
}

#pragma mark - 重置状态
- (void)resetFooterStatus:(BOOL)flag
{
    
}

@end
