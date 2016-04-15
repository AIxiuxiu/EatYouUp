//
//  QSFoodDetectiveNormalSeperateView.m
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodDetectiveNormalSeperateView.h"
#import "QSConfig.h"

@implementation QSFoodDetectiveNormalSeperateView

- (void)drawRect:(CGRect)rect
{
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置画圆
    CGContextAddEllipseInRect(context, CGRectMake(0.0, 0.0, 8.0, 8.0));
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:182.0f/255.0f green:182.0f/255.0f blue:182.0f/255.0f alpha:1.0f] CGColor]));
    CGContextFillPath(context);
    
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 2.0);
    
    //设置颜色：0xB6B6B6 =
    CGContextSetRGBStrokeColor(context, 182.0f/255.0, 182.0f/255.0, 182.0f/255.0, 1.0);
    
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, self.frame.size.width / 2.0f, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.frame.size.width / 2.0f, self.frame.size.height);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

@end
