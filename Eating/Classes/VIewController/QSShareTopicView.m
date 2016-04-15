//
//  QSShareTopicView.m
//  Eating
//
//  Created by ysmeng on 14/11/26.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSShareTopicView.h"
#import "QSConfig.h"
#import "QSBlockActionButton.h"

@implementation QSShareTopicView

//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(SHARE_FOODSTORE_TOMICRBLOG_BLOCK)callBack
{
    if (self = [super initWithFrame:frame]) {
        //创建UI
        [self createShareTopicUI];
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
    }
    
    return self;
}

//创建UI
- (void)createShareTopicUI
{
    //说明
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 7.0f, 60.0f, 30.0f)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = kBaseLightGrayColor;
    titleLabel.text = @"分享到：";
    [self addSubview:titleLabel];
    
    //取得分享主题数据
    NSArray *array = [self getShareTopicArray];
    if (!([array count] > 0)) {
        return;
    }
    
    //创建分享主题按钮
    for (int i = 0; i < [array count]; i++) {
        UIButton *button = [UIButton createBlockActionButton:CGRectMake(70.0f + (30.0f + 10) * i, 7.0f, 30.0f, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
            if (self.callBack) {
                self.callBack(i + 1 + DEFAULT_STY);
            }
        }];
        
        NSDictionary *imageDict = array[i];
        [button setImage:[UIImage imageNamed:[imageDict valueForKey:@"image_normal"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[imageDict valueForKey:@"image_highlighted"]] forState:UIControlStateHighlighted];
        
        [self addSubview:button];
    }
}

//取得按钮图片字典
- (NSArray *)getShareTopicArray
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QSShareTopic" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *resultArray = [dict valueForKey:@"shareType"];
    
    return resultArray;
}

@end
