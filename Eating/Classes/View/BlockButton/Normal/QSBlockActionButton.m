//
//  QSBlockActionButton.m
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSBlockActionButton.h"

@implementation UIButton (QSBlockActionButton)

/**
 *  @author             yangshengmeng, 14-12-16 17:12:05
 *
 *  @brief              生成一个给定frame的按钮，点击时直接执行block
 *
 *  @param frame        按钮在父视图的相以位置
 *  @param buttonStyle  按钮风格
 *  @param callBack     按钮点击时的回调
 *
 *  @return             返回一个按钮
 *
 *  @since              2.0
 */
+ (UIButton *)createBlockActionButton:(CGRect)frame andStyle:(QSButtonStyleModel *)buttonStyle andCallBack:(BLOCK_BUTTON_CALLBACK)callBack
{
    QSBlockActionButton *button = [[QSBlockActionButton alloc] initWithFrame:frame andButtonStyle:buttonStyle];
    if (callBack) {
        button.callBack = callBack;
    }
    return button;
}

/**
 *  @author             yangshengmeng, 14-12-16 17:12:05
 *
 *  @brief              生成一个给定风格的按钮，点击时直接执行block
 *
 *  @param buttonStyle  按钮风格
 *  @param callBack     按钮点击时的回调
 *
 *  @return             返回一个按钮
 *
 *  @since              2.0
 */
+ (instancetype)createBlockActionButton:(QSButtonStyleModel *)buttonStyle andCallBack:(BLOCK_BUTTON_CALLBACK)callBack
{
    QSBlockActionButton *button = [[QSBlockActionButton alloc] initWithButtonStyle:buttonStyle];
    
    if (callBack) {
        button.callBack = callBack;
    }
    
    return button;
}

@end

@implementation QSBlockActionButton

/**
 *  @author             yangshengmeng, 14-12-17 23:12:51
 *
 *  @brief              按给定的按钮风格，创建一个无frame的按钮
 *
 *  @param buttonStyle  按钮风格
 *
 *  @return             返回当前按钮
 *
 *  @since              2.0
 */
- (instancetype)initWithButtonStyle:(QSButtonStyleModel *)buttonStyle
{
    if (self = [super init]) {
        
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置按钮风格
        if (buttonStyle) {
            [self setButtonStyle:buttonStyle];
        }
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSButtonStyleModel *)buttonStyle
{
    if (self = [super initWithFrame:frame]) {
        
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置按钮风格
        if (buttonStyle) {
            [self setButtonStyle:buttonStyle];
        }
    }
    
    return self;
}

- (void)buttonAction:(UIButton *)button
{
    if (self.callBack) {
        self.callBack(button);
    }
}

- (void)setButtonStyle:(QSButtonStyleModel *)buttonStyle
{
    if (buttonStyle.title) {
        [self setTitle:buttonStyle.title forState:UIControlStateNormal];
    }
    
    if (buttonStyle.bgColor) {
        self.backgroundColor = buttonStyle.bgColor;
    }
    
    if (buttonStyle.titleNormalColor) {
        [self setTitleColor:buttonStyle.titleNormalColor
                   forState:UIControlStateNormal];
    }
    
    if (buttonStyle.titleHightedColor) {
        [self setTitleColor:buttonStyle.titleHightedColor
                   forState:UIControlStateHighlighted];
    }
    
    if (buttonStyle.titleSelectedColor) {
        [self setTitleColor:buttonStyle.titleSelectedColor
                   forState:UIControlStateSelected];
    }
    
    if (buttonStyle.borderColor) {
        self.layer.borderColor = [buttonStyle.borderColor CGColor];
    }
    
    if (buttonStyle.borderWith >= 0.5f && buttonStyle.borderWith <= 10.0f) {
        self.layer.borderWidth = buttonStyle.borderWith;
    }
    
    if (buttonStyle.imagesNormal) {
        UIImage *image = [UIImage imageNamed:buttonStyle.imagesNormal];
        [self setImage:image forState:UIControlStateNormal];
    }
    
    if (buttonStyle.imagesHighted) {
        [self setImage:[UIImage imageNamed:buttonStyle.imagesHighted]
              forState:UIControlStateHighlighted];
    }
    
    if (buttonStyle.imagesSelected) {
        [self setImage:[UIImage imageNamed:buttonStyle.imagesSelected]
              forState:UIControlStateSelected];
    }
    
    if (buttonStyle.cornerRadio > 1.0f && buttonStyle.cornerRadio <= 100.0f) {
        self.layer.cornerRadius = buttonStyle.cornerRadio;
    }
    
    if (buttonStyle.titleFont) {
        self.titleLabel.font = buttonStyle.titleFont;
    }
    
    if (buttonStyle.aboveImage) {
        UIImageView *aboveImageView = [[UIImageView alloc]
                                       initWithFrame:CGRectMake(0.0f, 0.0f,
                                                                self.frame.size.width,
                                                                self.frame.size.height)];
        aboveImageView.image = [UIImage imageNamed:buttonStyle.aboveImage];
        [self addSubview:aboveImageView];
    }
}

@end
