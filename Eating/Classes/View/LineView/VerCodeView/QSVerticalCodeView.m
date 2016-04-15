//
//  QSVerticalCodeView.m
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSVerticalCodeView.h"
#import "QSConfig.h"

@interface QSVerticalCodeView ()

@property (nonatomic,strong) UIView *showView;//显示随机验证码的view
@property (nonatomic,copy) NSString *code;//随机验证码文字

@end

@implementation QSVerticalCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //背景颜色
        self.backgroundColor = kBaseHighlightedGrayBgColor;
        
        //添加视图
        [self createVerShowUI];
        
        //添加单击手势
        [self addSingleTapGesture];
        
        //生成验证码
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeVerticalCode];
        });
    }
    
    return self;
}

//创建显示UI
- (void)createVerShowUI
{
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 2.0f, self.frame.size.width-10.0f, self.frame.size.height-8.0)];
    self.showView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.showView];
}

//添加单击手势事件
- (void)addSingleTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToGenerateCode:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)onTapToGenerateCode:(UITapGestureRecognizer *)tap {
    //首先清空
    for (UIView *view in self.showView.subviews) {
        [view removeFromSuperview];
    }
    
    //生成新的验证码
    [self changeVerticalCode];
}

- (void)changeVerticalCode
{
#if 0
    //生成随机背景色
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [self setBackgroundColor:color];
#endif
    
    //生成随机验证码文字
    const int count = 6;
    char data[count];
    for (int x = 0; x < count; x++) {
        int j = '0' + (arc4random_uniform(75));
        if((j >= 58 && j <= 64) || (j >= 91 && j <= 96)){
            --x;
        }else{
            data[x] = (char)j;
        }
    }
    NSString *text = [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    
    //保存验证码
    self.code = text;
    
    CGSize cSize = [@"S" sizeWithFont:[UIFont systemFontOfSize:18]];
    int width = self.showView.frame.size.width / text.length - cSize.width;
    int height = self.showView.frame.size.height - cSize.height;
    CGPoint point;
    float pX, pY;
    for (int i = 0; i < count; i++) {
        pX = arc4random() % width + self.showView.frame.size.width / text.length * i - 1;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, pY,
                                                       self.showView.frame.size.width / 5,
                                                       self.showView.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.font = [UIFont boldSystemFontOfSize:24.0f];
        tempLabel.text = textC;
        [self.showView addSubview:tempLabel];
    }
    
    // 干扰线
    float redDisturb;
    float greenDisturb;
    float blueDisturb;
    UIColor *colorDisturb;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    for(int i = 0; i < count; i++) {
        //随机颜色
        redDisturb = arc4random() % 100 / 100.0;
        greenDisturb = arc4random() % 100 / 100.0;
        blueDisturb = arc4random() % 100 / 100.0;
        colorDisturb = [UIColor colorWithRed:redDisturb green:greenDisturb blue:blueDisturb alpha:1.0];
        //绘画
        CGContextSetStrokeColorWithColor(context, [colorDisturb CGColor]);
        pX = arc4random() % (int)self.showView.frame.size.width;
        pY = arc4random() % (int)self.showView.frame.size.height;
        CGContextMoveToPoint(context, pX, pY);
        pX = arc4random() % (int)self.showView.frame.size.width;
        pY = arc4random() % (int)self.showView.frame.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        CGContextStrokePath(context);
    }
    
    //回调生成的随便验证码
    if (self.callBack) {
        self.callBack(text);
    }
    return;
}

@end
