//
//  QSBottomTitleBlockButton.m
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSBottomTitleBlockButton.h"

@implementation UIButton (QSBottomTitleBlockButton)

+ (UIButton *)createBottomTitleButton:(CGRect)frame andStyle:(QSButtonStyleModel *)buttonStyle andCallBack:(void(^)(UIButton *button))callBack
{
    QSBottomTitleBlockButton *button = [[QSBottomTitleBlockButton alloc] initWithFrame:frame andButtonStyle:buttonStyle];
    
    if (callBack) {
        button.callBack = callBack;
    }
    
    return button;
}

@end

@implementation QSBottomTitleBlockButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0f, contentRect.size.height-15.0f, contentRect.size.width, 15.0f);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0f, 0.0f, contentRect.size.width, contentRect.size.height-15.0f);
}

@end
