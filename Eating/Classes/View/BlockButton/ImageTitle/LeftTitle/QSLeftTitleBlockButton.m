//
//  QSLeftTitleBlockButton.m
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSLeftTitleBlockButton.h"

@implementation UIButton (QSLeftTitleBlockButton)

+ (UIButton *)createLeftTitleButton:(CGRect)frame andStyle:(QSButtonStyleModel *)buttonStyle andCallBack:(void(^)(UIButton *button))callBack
{
    QSLeftTitleBlockButton *button = [[QSLeftTitleBlockButton alloc] initWithFrame:frame andButtonStyle:buttonStyle];
    
    if (callBack) {
        button.callBack = callBack;
    }
    
    return button;
}

@end

@implementation QSLeftTitleBlockButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0f, 0.0f, contentRect.size.width-contentRect.size.height-10.0f, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width-contentRect.size.height-5.0f, 0.0f, contentRect.size.height, contentRect.size.height);
}

@end
