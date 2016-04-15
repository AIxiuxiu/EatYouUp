//
//  QSAddImageView.m
//  Eating
//
//  Created by ysmeng on 14/11/26.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAddImageView.h"
#import "QSConfig.h"

@implementation QSAddImageView

//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //创建UI
        [self createAddDetectiveStoreImageUI];
    }
    
    return self;
}

//创建添加店铺图片UI
- (void)createAddDetectiveStoreImageUI
{
    //创建底scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5.0f, 10.0f, self.frame.size.width - 10.0f, self.frame.size.height-20.0f)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
}

//开始touches时，将事件传到父视图
#pragma mark - 将触摸事件传到父视图
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

@end
