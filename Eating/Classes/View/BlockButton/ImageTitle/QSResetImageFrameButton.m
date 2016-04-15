//
//  QSResetImageFrameButton.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSResetImageFrameButton.h"

@interface QSResetImageFrameButton ()

- (instancetype)initWithCallBack:(void (^)(UIButton *))callBack;

@end

@implementation UIButton (QSResetImageFrameButton)

/**
 *  @author         yangshengmeng, 14-12-19 12:12:58
 *
 *  @brief          创建一个图片在左侧，标题在右侧的按钮
 *
 *  @param frame    在父视图中的大小
 *  @param callBack 点击时的回调
 *
 *  @return         返回当前创建的按钮
 *
 *  @since          1.0
 */
+ (UIButton *)createImageAndTitleButton:(CGRect)frame andCallBack:(void (^)(UIButton *))callBack
{
    QSResetImageFrameButton *button = [[QSResetImageFrameButton alloc] initWithFrame:frame andCallBack:callBack];
    return button;
}

/**
 *  @author         yangshengmeng, 14-12-19 12:12:39
 *
 *  @brief          创建一个标题在右侧的按钮，同时不设置frame
 *
 *  @param callBack 单击时的回调
 *
 *  @return         返回当前按钮对象
 *
 *  @since          2.0
 */
+ (UIButton *)createRightTitleButton:(void(^)(UIButton *button))callBack
{

    QSResetImageFrameButton *button = [[QSResetImageFrameButton alloc] initWithCallBack:callBack];
    
    return button;

}

@end

@implementation QSResetImageFrameButton

- (instancetype)initWithCallBack:(void (^)(UIButton *))callBack
{

    if (self = [super init]) {
        
        if (callBack) {
            self.callBack = callBack;
        }
        
        [self addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(UIButton *))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        if (callBack) {
            self.callBack = callBack;
        }
        
        [self addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)imageButtonAction:(UIButton *)button
{
    if (self.callBack) {
        self.callBack(button);
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.height+5.0f, 0.0f, contentRect.size.width-contentRect.size.height-5.0f, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0f, 0.0f, contentRect.size.height, contentRect.size.height);
}

@end