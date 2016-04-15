//
//  QSSelectedChangeBgColorButton.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSSelectedChangeBgColorButton.h"

@implementation UIButton (QSSelectedChangeBgColorButton)

+ (UIButton *)createSelectedChangeBgColorButton:(CGRect)frame andStyle:(QSButtonStyleModel *)buttonStyle andCallBack:(BLOCK_BUTTON_CALLBACK)callBack
{
    QSSelectedChangeBgColorButton *button = [[QSSelectedChangeBgColorButton alloc] initWithFrame:frame andButtonStyle:buttonStyle];
    if (callBack) {
        button.callBack = callBack;
    }
    return button;
}

@end

@implementation QSSelectedChangeBgColorButton

- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSButtonStyleModel *)buttonStyle
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置按钮风格
        [self setButtonStyle:buttonStyle];
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
        self.normalBGColor = buttonStyle.bgColor;
    }
    
    if (buttonStyle.bgColorHighlighted) {
        self.highlightedBGColor = buttonStyle.bgColorHighlighted;
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

#pragma mark - 重写selected方法，不同状态不同的背景颜色
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = self.highlightedBGColor;
    } else {
        self.backgroundColor = self.normalBGColor;
    }
}

@end
