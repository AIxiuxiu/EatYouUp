//
//  QSPrepaidCardDetailTabbarView.m
//  Eating
//
//  Created by ysmeng on 14/11/29.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidCardDetailTabbarView.h"
#import "QSBottomTitleBlockButton.h"
#import "QSConfig.h"

//配置文件信息
#define PREPAIDCARD_DETAILTABBAR_FILENAME @"prepaidCardDetailTabbar"
#define PREPAIDCARD_DETAILTABBAR_FILETYPE @"plist"
#define PREPAIDCARD_DETAILTABBAR_ARRAY @"topic_array"

@implementation QSPrepaidCardDetailTabbarView

//****************************************
//             初始化/UI搭建
//****************************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(PREPAIDCARD_DETAIL_TABBAR_CALLBACKTYPE actionType))callBack
{
    if (self = [super initWithFrame:frame]) {
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        //加载分类按钮
        [self createTopicButton];
    }
    
    return self;
}

//不同信息按钮
- (void)createTopicButton
{
    NSArray *topicArray = [self getPrepaidCardDetailTabbarInfo];
    if (!([topicArray count] > 0)) {
        
        return;
    }
    
    //计算按钮间隙
    CGFloat width = 48.0f;
    CGFloat gap = (DeviceWidth - [topicArray count] * width) / ([topicArray count] + 1);
    
    //创建信息按钮
    for (int i = 0; i < [topicArray count]; i++) {
        UIButton *button = [UIButton createBottomTitleButton:CGRectMake(gap + (width + gap) * i, 0.0f, width, self.frame.size.height) andStyle:nil andCallBack:^(UIButton *button) {
            
            ///回调
            if (self.callBack) {
                self.callBack(FIRST_BUTTON_PDTC+i);
            }
            
        }];
        
        //取得风格字典
        NSDictionary *dict = topicArray[i];
        
        //添加图片
        [button setImage:[UIImage imageNamed:[dict valueForKey:@"normal"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[dict valueForKey:@"highlighted"]] forState:UIControlStateHighlighted];
        
        //设置标题
        [button setTitle:[dict valueForKey:@"title"] forState:UIControlStateNormal];
        
        //设置按钮标题颜色/大小
        [button setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
        [button setTitleColor:kBaseLightGrayColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
        [self addSubview:button];
    }
}

//获取配置信息
- (NSArray *)getPrepaidCardDetailTabbarInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:PREPAIDCARD_DETAILTABBAR_FILENAME ofType:PREPAIDCARD_DETAILTABBAR_FILETYPE];
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    return [infoDict valueForKey:PREPAIDCARD_DETAILTABBAR_ARRAY];
}

@end
