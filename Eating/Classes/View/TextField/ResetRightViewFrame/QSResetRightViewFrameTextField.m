//
//  QSResetRightViewFrameTextField.m
//  Eating
//
//  Created by ysmeng on 14/12/8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSResetRightViewFrameTextField.h"

@implementation QSResetRightViewFrameTextField

//重置右侧视图的坐标
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect frame = [super rightViewRectForBounds:bounds];
    return CGRectMake(frame.origin.x-10.0f, frame.origin.y, frame.size.width, frame.size.height);
}

@end
