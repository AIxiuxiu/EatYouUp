//
//  QSTextField.m
//  Eating
//
//  Created by ysmeng on 14/11/26.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSTextField.h"

@implementation QSTextField

// 控制 placeHolder 的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectInset(rect, 8, 0);
}

// 控制文本的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectInset(rect, 8, 0);
}

@end
